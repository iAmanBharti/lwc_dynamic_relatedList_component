public class ContactTriggerHandler {

    public static Boolean isFirstTime = true;
    
    /*public static void beforeInsert(List<Contact> newContactList){
        
        //Create a Set of all inserted AccountId 
        Set <Id> newAccountIdSet = new Set<Id>();
        //====================================================================================================//
       Double minOrder = 0;	//To find min value of Order Field
        for(Contact con : newContactList){
            newAccountIdSet.add(con.AccountId);
            
            if(minOrder == 0){
                minOrder = con.Order__c;
            }
            else{
                if(minOrder > con.Order__c){
                 	minOrder = con.Order__c;   
                }
            }
        }
       //========================================================================================================//
      
        //
        Map<Id,Double> accountOrderMinValueMap = new Map<Id,Double>();
        //
        Map<Id,List<Double>> accountContactOrderMap = new Map<Id,List<Double>>();
        //
        //
        Map<Id,List<Contact>> accountContactMap = new Map<Id,List<Contact>>();

        for(Contact con : newContactList){
            if(accountContactOrderMap.containsKey(con.AccountId)){
                accountContactOrderMap.get(con.AccountId).add(con.Order__c);
            }
            else{
                List<Double> doubleList =  new List<Double>();
                doubleList.add(con.Order__C);
                accountContactOrderMap.put(con.AccountId,doubleList);
            }
            if(accountContactMap.containsKey(con.AccountId)){
                accountContactMap.get(con.AccountId).add(Con);
            }
            if(accountOrderMinValueMap.containsKey(con.AccountId)){
                if(accountOrderMinValueMap.get(con.AccountId) > con.Order__c){
                    accountOrderMinValueMap.put(con.AccountId,con.Order__c);
                }
            }
            
            else{
                List<Contact> newContact = new List<Contact>();
                newContact.add(con);
                accountContactMap.put(con.AccountId,newContact);
                accountOrderMinValueMap.put(con.AccountId,con.Order__c);
            }
        }
        //------------>
        Map<Id,Contact> oldContactMap = new Map<Id,Contact>([SELECT Id,LastName,Order__c,AccountId FROM Contact WHERE AccountId IN :newAccountIdSet]);
        
        //------------>
        //records that going to update
        Map<Id,List<Contact>> oldAccountContactMap = new Map<Id,List<Contact>>();
        //
        //List<Account> accountContactList = [SELECT Id,(SELECT LastName,Order__c FROM Contacts WHERE Order__c >= minOrder) FROM Account WHERE Id IN:newAccountIdSet];
        List<Contact> contactList = [SELECT Lastname,Order__c,AccountId FROM Contact WHERE AccountId IN:newAccountIdSet];
        List<Contact> contactThatUpdate = new List<Contact>();//List of contact that going to update
        for(Contact con : contactList){
            if(con.Order__c >= accountOrderMinValueMap.get(con.AccountId)){
                contactThatUpdate.add(con);
            }
        }
        System.debug('--- contact list ---'+contactList);
        System.debug('-- contact that update list --'+contactThatUpdate);
        
        //-----------------
        System.debug('--newContactList Insert--size = '+newContactList.size()+'--List-->'+newContactList);
        for(Contact con: newContactList){
            System.debug('---**Update**------new ----DATA----LastName---->'+con.LastName+'Order---->'+con.Order__c);
            for(Contact cont:contactThatUpdate){
                System.debug('----**beforeUpdate**---LastName---->'+cont.LastName+'Order---->'+cont.Order__c);
               if(con.AccountId == cont.AccountId && cont.Order__c >= con.Order__c){
                        cont.Order__c++;
                    }
                System.debug('---**afterUpdate**----LastName---->'+cont.LastName+'Order---->'+cont.Order__c);   
            } 
        }
        
       
        isFirstTime = false;
       update contactThatUpdate;
       isFirstTime = true;

        System.debug('newContactList afterInsert size = '+newContactList.size()+'--List-->'+newContactList);
        Integer count = 0;
        Integer newListSize = newContactList.size();
        //for(Contact con : newContactList){
        for(Integer i=0;i<newListSize;i++){
            System.debug('new Contact after insert --in-----LastName------>'+newContactList[i].LastName+'Order---'+newContactList[i].Order__c);
            //for(Contact conn : newContactList){
            for(Integer j=i+1;j<newListSize;j++){    
               
                if(newContactList[i].AccountId == newContactList[j].AccountId && newContactList[i].Order__c >= newContactList[j].Order__c){
                    count ++;
                }
                
            }
            System.debug('Count=='+count);
            newContactList[i].Order__c = newContactList[i].Order__c + count;
            count=0;
            System.debug('new Contact after insert -- out -----LastName------>'+newContactList[i].LastName+'Order---'+newContactList[i].Order__c);
        }
        //System.debug('second print'+newContactList[0].Order__c);

        //update newContactList;
      

        //System.debug(contactThatUpdate);
        //update contactThatUpdate;
        
        //adding data to the Map
        for(Contact con: contactList){
            if(oldAccountContactMap.containsKey(con.AccountId)){
                if(con.Order__c >= accountOrderMinValueMap.get(con.AccountId)){
                  	oldAccountContactMap.get(con.AccountId).add(con);  
                }
                
            }
            else{
                List<Contact> conList = new List<Contact>();
                if(con.Order__c >= accountOrderMinValueMap.get(con.AccountId)){
                    conList.add(con);
                    oldAccountContactMap.put(con.AccountId,conList);
                }
            }
        }
        //
        
        
        
      
        
    }*/
    /*
    ********************************************************
    ********************************************************
    ********************************************************
    ********************************************************
    ********************************************************
    */
    public static void afterUpdate(List<Contact> newUpdateContactList,List<Contact> oldUpdateConatctList){
        
        Set<Id> contactAccountIdSet = new Set<Id>();
        Double orderMin = 0;
        Double orderMax = 0;
        for(Contact con : newUpdateContactList){
            contactAccountIdSet.add(con.AccountId);
            if(orderMin == 0 || orderMin > con.Order__c){
                orderMin = con.Order__c;
            }
            if(orderMax == 0 || orderMax < con.Order__c){
                orderMax = con.Order__c;
            }
        }
        for(Contact con : oldUpdateConatctList){
            if(orderMin > con.Order__c){
                orderMin = con.Order__c;
            }
            if(orderMax < con.Order__c){
                orderMax = con.Order__c;
            }
        }
        System.debug('-----Order Min----- '+orderMin+'----Order Max--'+orderMax);

        List<Contact> contactThatUpdate = [SELECT Id,AccountId,LastName,Order__c FROM Contact WHERE AccountId IN : contactAccountIdSet AND Order__c >= :orderMin AND Order__c <= :orderMax];
        

    }
    
   /* public static void afterUpdate(List<Contact> newUpdateContactList,List<Contact> oldContactList){
       System.debug('--> in afterUpdate Method on Top <--');
       
    if(isFirstTime){
        System.debug('--> afterUpdate if condition <--');
        isFirstTime = false;
    
        System.debug('newUpdateContactList--inAfterUpdate--> size'+newUpdateContactList.size()+'--List-- '+newUpdateContactList);
        System.debug('oldContactList--inAfterUpdate--> Size'+oldContactList.size()+'--List -- '+oldContactList);
        Set<Id> UpdateContactAccountIdSet = new Set<Id>();
        for(Contact con : newUpdateContactList){
            UpdateContactAccountIdSet.add(con.AccountId);
        }
        System.debug('Set size--> '+UpdateContactAccountIdSet.size()+'--set data-->'+UpdateContactAccountIdSet);
        Map<Id,Double> accountIdMinOrderVal = new Map<Id,Double>();
        for(Contact con : [SELECT AccountId,Id,LastName,Order__c FROM Contact WHERE AccountID IN : UpdateContactAccountIdSet]){
            if(accountIdMinOrderVal.containsKey(con.AccountId)){
                if(accountIdMinOrderVal.get(con.AccountId) > con.Order__c){
                    accountIdMinOrderVal.put(con.AccountId,con.Order__c);
                }
            }
            else{
                accountIdMinOrderVal.put(con.AccountId,con.Order__c);
            }
        }
        List<Contact> allContactList = [SELECT Id,AccountId,LastName,Order__c FROM Contact WHERE AccountId IN : UpdateContactAccountIdSet ORDER BY Order__c ASC];
        System.debug('--all contact list--Size'+allContactList.size()+'--list--'+allContactList);
        
        //
        Map<Id,Contact> oldContactIdMap = new Map<Id,Contact>();
        for(Contact con : oldContactList){
            oldContactIdMap.put(con.Id,con);
        }
        for(Contact con : newUpdateContactList){
            System.debug('----->new List----------------- in update-------------LastName---'+con.LastName+'--Order--'+con.Order__c);
            for(Contact cont : oldContactList){
                System.debug('----old list----->before change in update---LastName---'+cont.LastName+'--Order--'+cont.Order__c);
                if(con.Id == cont.Id){
                    for(Contact kon : allContactList){
                        
                        if(oldContactIdMap.containsKey(kon.Id) && con.Id != kon.Id){
                            System.debug('---all contact--before replace->'+kon.lastName+'Order-->'+kon.Order__c);
                            kon.Order__c = oldContactIdMap.get(kon.Id).Order__c;
                            System.debug('---all contact--after replace->'+kon.lastName+'Order-->'+kon.Order__c);
                        }
                        
                        System.debug('on all contact ---before --LastName----->'+kon.LastName+'--Order--'+kon.Order__c);
                        if(con.Order__c > cont.Order__c){
                            if(kon.Order__c > cont.Order__c && kon.Order__c <= con.Order__c && kon.Id != cont.Id){
                                kon.Order__c--;
                                //contactUpdated.add();
                            }
                        }
                        
                        else if(con.Order__c < cont.Order__c){
                            if(kon.Order__c < cont.Order__c && kon.Order__c >= con.Order__c && kon.Id != cont.Id){
                                kon.Order__c++;
                            }
                        }
                        System.debug('on all contact ---after --LastName----->'+kon.LastName+'--Order--'+kon.Order__c);   
                    }
                }
                System.debug('--after change in update--LastName---'+cont.LastName+'--Order--'+cont.Order__c);
            }
        }
        System.debug('all contact after change -- size'+allContactList.size()+'--list--'+allContactList);
        update allContactList;
        

    }
    }*/
    /*****************************************************
     *****************************************************
     *****************************************************
     ***************************************************** 
     ****************************************************/
    public static void beforeDelete(List<Contact> oldDeleteContactList){
        System.debug('old Delete contact list Size'+oldDeleteContactList.size()+'<--List-->'+oldDeleteContactList);
        Set<Id> deleteContactAccountIdSet = new Set<Id>();
        Set<Id> deleteContactIdSet = new Set<Id>();
        for(Contact con : oldDeleteContactList){
            deleteContactAccountIdSet.add(con.AccountId);
            deleteContactIdSet.add(con.Id);
        }
        
        List<Contact> oldDeleteContactListSorted = [SELECT Id,AccountId,LastName,Order__c FROM Contact WHERE Id IN:deleteContactIdSet ORDER BY Order__c DESC];
        List<Contact> allContactList = [SELECT Id,AccountId,LastName,Order__c FROM Contact WHERE AccountId IN : deleteContactAccountIdSet ];//ORDER BY Order__c DESC];
        
        for(Contact con : oldDeleteContactListSorted){
            System.debug('---------------------------------LastName-->'+con.LastName+'<-- Order -->'+con.Order__c);
            for(Contact cont : allContactList){
                System.debug('in loop--before change>'+cont.LastName+'--Order-->'+cont.Order__c);
                if(con.AccountId == cont.AccountId){
                    if(cont.Order__c > con.Order__c){
                        cont.Order__c--;
                    }
                    System.debug('in loop--after change>'+cont.LastName+'--Order-->'+cont.Order__c);
                }
            }
        }
        for(Integer i=0;i<allContactList.size();i++){
            System.debug('just before update --->'+allContactList[i]);
        }

        isFirstTime = false;
        update allContactList;
        isFirstTime = true;
        
    }
    /***********************************************************
     * ********************************************************
     * ***************************************************
     * *************************************************
     */
    public static void afterInsert(List<Contact> newContactList,Map<Id,Contact> newContactIdMap){
        Set<Id> newContactAccountIdSet = new Set<Id>();
        Map<Id,Double> accountIdMinOrderVal = new Map<Id,Double>();

        Double minOrder = 0;
        for(Contact con : newContactList){
            newContactAccountIdSet.add(con.AccountId);
            System.debug('--before--minOrder---'+minOrder);
            
            if(minOrder == 0 || minOrder > con.Order__c){
                minOrder = con.Order__c;
            }
            System.debug('--after--minOrder---'+minOrder);

            if(!accountIdMinOrderVal.containsKey(con.AccountId) || (accountIdMinOrderVal.get(con.AccountId) > con.Order__c)){
                accountIdMinOrderVal.put(con.AccountId,con.Order__c);
            }
        }
        
        System.debug('----Min Order Value--->'+minOrder);
        System.debug('----Map Order Value--->'+accountIdMinOrderVal);
        
        List<Contact> allContactList = [SELECT Id,AccountId,LastName,Order__c FROM Contact WHERE AccountId IN : newContactAccountIdSet AND Order__c >= : minOrder ORDER BY Order__c];
        System.debug('----all contact list --->'+allContactList);
        List<Contact> contactThatUpdate = new List<Contact>();
        for(Contact con : allContactList){
            if(con.Order__c >= accountIdMinOrderVal.get(con.AccountId)){
                contactThatUpdate.add(con);
            }
        }
        for(Contact newCon : newContactList){
            for(Contact con : contactThatUpdate){
                if(newCon.Id == con.Id){
                    con.Order__c = newCon.Order__c;
                }
                else if(con.AccountId == newCon.AccountId && con.Order__c >= newCon.Order__c){//&& !newContactIdMap.containsKey(con.Id)
                    con.Order__c++; 
                }
            }
        }
        update contactThatUpdate;
    }
}