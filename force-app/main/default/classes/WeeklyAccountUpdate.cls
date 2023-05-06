public class WeeklyAccountUpdate implements Database.Batchable<sObject>,Database.Stateful { 
    public Integer totalRecordProcesse = 0;
    public Integer totalRecordpass = 0;
    public Integer totalRecordFail = 0;
    public List<String> errorList = new List<String>();
    public Database.queryLocator start(Database.BatchableContext bc){
        System.debug('==inside start==');
        return Database.getQueryLocator([SELECT Id,(SELECT Id,Name FROM Contacts WHERE Active__c = true) FROM Account]);
    }
    public void execute(Database.BatchableContext bc,List<Account> scope){
        System.debug('====inside execute===');
        List<Account> updatedAccountList = new List<Account>();
        for(Account acc : scope){
            totalRecordProcesse ++;
            acc.Active_Contact_Count__c = acc.Contacts.size();
            updatedAccountList.add(acc);
        }
        System.debug('total record process = '+totalRecordProcesse);
 
        Database.SaveResult[] srList = Database.update(updatedAccountList,false);
        
        for(Database.SaveResult sr : srList){
            if(sr.isSuccess()){
                System.debug('==success==');
            }
            else{
                for(Database.Error err : sr.getErrors()){
                    System.debug('Error - '+err.getMessage());
                    errorList.add(err.getMessage());
                }
            }
        }
        totalRecordFail+= errorList.size();
    }
    
    public void finish(Database.BatchableContext bc){
        System.debug('===inside Finish==');
        System.debug('Record Processed = '+totalRecordProcesse+' , Fail Record = '+totalRecordFail);
        System.debug('Error');
        for(String err : errorList){
            System.debug(err);
        }
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String[] toAddress = new String[]{'aman1182119221@gmail.com'};
        email.setToAddresses(toAddress);
        email.setSubject('Batch Process Completed');
        email.setPlainTextBody('Batch Process has completed'+'\n'+
                               'Total Records Processed: ' +totalRecordProcesse+'\n'+
                               'Total Records Failed: '+totalRecordFail+'\n'+
                               'Below are all errors: '+errorList);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
      }
}



/*public Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('==Inside start==');
        return Database.getQueryLocator([Select Id,Name From Contact WHERE Active__c = true]);
    }
    public void execute(Database.BatchableContext bc, List<Contact> scope){
        System.debug('===inside execute===');
        Map<Id,Integer> accIdActiveConCountMap = new Map<Id,Integer>();
            for(Contact con : scope){
                totalRecordProcesse++;
                Integer conCount = accIdActiveConCountMap.get(con.AccountId);//first time null
                if(conCount == null){
                    conCount = 0;
                }
                if(con.AccountId != null){
                    conCount++;
                    accIdActiveConCountMap.put(con.AccountId,conCount);
                }      
            }
        System.debug('===Map Data==');
        System.debug(accIdActiveConCountMap);
            List<Account> updatedAccountList = new List<Account>();
            for(Id accId :accIdActiveConCountMap.keySet()){
                Account acc = new Account(Id=accId,Active_Contact_Count__c = accIdActiveConCountMap.get(accID));
                updatedAccountList.add(acc);
            }
            //Database.SaveResult[] srList = Database.update(updatedAccountList,false);
            update updatedAccountList;
        
        //checking for record updated or fail
        //for(Database.SaveResult sr :srList){
            //if(sr.isSuccess()){
             //   System.debug('update success');
            //}
            //else{
               // totalRecordFail++;
                //for(Database.Error err : sr.getErrors()){
              //      System.debug('Error'+err.getMessage());       
            //  }
          //  }
        //}
    }    */