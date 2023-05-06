public with sharing class AccountTriggerHandler {

    public static void afterInsert(List<Account> newAccountList){
        List<Account> accountIronmanRTList = new List<Account>();
        for(Account acc : newAccountList){
            if(acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Ironman').getRecordTypeId()){
                accountIronmanRTList.add(acc);
            }
        }
        if(!accountIronmanRTList.isEmpty()){
            AccountTriggerHelper.createChildRecordOnInsert(accountIronmanRTList);
        }
        
    }

    public static void afterUpdate(Map<Id,Account> newAccountIdMap,Map<Id,Account> oldAccountIdMap){
        Map<Id,Account> updateAccIdToAccountMap = new Map<Id,Account>();
        for(Account acc : newAccountIdMap.values()){
            if(acc.Child_Record_Type__c != oldAccountIdMap.get(acc.Id).Child_Record_Type__c && acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Ironman').getRecordTypeId()){
                updateAccIdToAccountMap.put(acc.Id,acc);
            }
        }
        
        AccountTriggerHelper.createChildRecordOnUpdate(updateAccIdToAccountMap,oldAccountIdMap);
        
        
        
       	Set<Id> accountIdSet = new Set<Id>();//Set of AccountId those Stage field changed

        Map<Id,Account> newUpdateAccountMap = new Map<Id,Account>();//Map of Account those Stage field changed
        
        //new
        Set<String> accStageSet = new Set<String>();
        //
        List<Account> newAccountList = newAccountIdMap.values();
        for(Account acc : newAccountList){
            if(acc.Stage__c == oldAccountIdMap.get(acc.Id).Stage__c){
                continue;
            }
            acc.Opportunity_Count__c = 0;
            accountIdSet.add(acc.Id);
            newUpdateAccountMap.put(acc.Id,acc);
            accStageSet.add(acc.Stage__c);
        }
        //List of opportunity that associated to Accounts those Stage field updated
        List<Opportunity> oppoList = [SELECT Id, AccountId, Name,StageName FROM Opportunity WHERE AccountId IN : accountIdSet AND StageName IN : accStageSet];
        System.debug('--oppoList count---'+oppoList.size()+'--oppoList-'+oppoList);
        //Integer count = 0;
        // increasing Opportunity count on Account when a opportunity comes with same StageName as Account
        for(Opportunity oppo : oppoList){
            if(oppo.StageName == newUpdateAccountMap.get(oppo.AccountId).Stage__c){
                //count++;
                newUpdateAccountMap.get(oppo.AccountId).Opportunity_Count__c += 1;
            }
            //newUpdateAccountMap.get(oppo.AccountId).Opportunity_Count__c += count;
            System.debug('--count in account-->'+newUpdateAccountMap.get(oppo.AccountId).Opportunity_Count__c);
            //count = 0;
        }
        
        /*
            for(Account acc : newAccountList){
                
                for(Opportunity oppo : oppoList){
                    
                    if(acc.Id == oppo.AccountId && acc.Stage__c == oppo.StageName){
                        count++;
                    }
                }
                acc.Opportunity_Count__c = count;
                count = 0;
            }*/
            //update newAccountList;
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////
    public static void calloutUpdate(List<Account> newAccountList){
        Set<Id> accIdSet = new Set<Id>();

        for(Account acc : newAccountList){
            accIdSet.add(acc.Id);
        }
        
        AccountTriggerHelper.getRootFolderCount(accIdSet);
        
        
        System.debug('====******Inside calloutUpdate MEthod');

        
        
        //HttpResponse response = GoogleAuthentication.getGoogleFolderCount(accIdSet);
        //System.debug(JSON.deserializeUntyped(response.getBody()));   
    }
    ///////////////////////////////////////////////////////////////////////////////////////////
}