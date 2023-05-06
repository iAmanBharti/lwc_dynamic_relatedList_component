public with sharing class AccountTriggerHelper {//AccountTriggerHelper.isFirstTime

    public static List<Account> createChildRecords(List<String> childRTList,String accId){
        List<Account> newAccList = new List<Account>();
        for(String rt : childRTList){
            Account account = new Account(Name =rt+'test Account' ,	Select_Parent_Account__c = accId ,	Stage__c='Prospecting', RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(rt).getRecordTypeId());
            newAccList.add(account);   
        }    
        return newAccList;    
    }

    public static void createChildRecordOnInsert(List<Account> newAccountList){
        System.debug('Inside createChildRecordOnInsert');
        String childRecordTypes = '';
        List<Account> createAccountList = new List<Account>();
        for(Account acc : newAccountList){
            List<String> childRecordTypeList = new List<String>();
            if(acc.Child_Record_Type__c != null){
                childRecordTypes = acc.Child_Record_Type__c;
                childRecordTypeList.addAll(childRecordTypes.split(';',0));   
            }

            //createChildRecords(childRecordTypeList,acc.Id);
           /* for(String rt : childRecordTypeList){
                Account account = new Account(Name =rt+'test Account' ,	Select_Parent_Account__c = acc.Id ,	Stage__c='Prospecting', RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(rt).getRecordTypeId());
                createAccountList.add(account);   
            }*/
            createAccountList.addAll(createChildRecords(childRecordTypeList,acc.Id));  
        }
        insert createAccountList;
    }


    public static void createChildRecordOnUpdate(Map<Id,Account> newAccountMap,Map<Id,Account> oldAccountMap){
        System.debug('createChildRecordOnUpdate');
        String recordTypes = '';
        String oldRecordTypes = '';
        List<Account> delelteAccList = new List<Account>();
        List<String> newChildRecordTypeList = new List<String>();
        List<String> oldChildRecordTypeList = new List<String>();
        List<Account> insertAccList = new List<Account>();
        Set<String> deleteRTSet = new Set<String>();
        Map<Id,List<String>> deleteAccIdToRTMap = new Map<Id,List<String>>();
        
        for(Account acc : newAccountMap.values()){
            recordTypes = acc.Child_Record_Type__c;
            if(recordTypes != null){
                newChildRecordTypeList.addAll(recordTypes.split(';',0));
            }
            
            oldRecordTypes = oldAccountMap.get(acc.Id).Child_Record_Type__c;//
            if(oldRecordTypes != null){                       
                oldChildRecordTypeList.addAll(oldRecordTypes.split(';',0));
            }
            for(String rt : newChildRecordTypeList){                        
                if(!oldChildRecordTypeList.contains(rt)){
                    Account account  = new Account(Name= rt+' test '+acc.AccountNumber,Stage__c = 'Prospecting',Select_Parent_Account__c = acc.Id, RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(rt).getRecordTypeId());
                    insertAccList.add(account);
                }
            }
            for(String rt : oldChildRecordTypeList){                              
                if(!newChildRecordTypeList.contains(rt)){
                  if(!deleteAccIdToRTMap.containsKey(acc.Id)){
                    deleteAccIdToRTMap.put(acc.Id,new List<String>());
                  } 
                    deleteAccIdToRTMap.get(acc.Id).add(Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(rt).getRecordTypeId());
                    deleteRTSet.add(Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(rt).getRecordTypeId());         
                }       
            }      
        }
        List<Account> accountList = [SELECT Id,Name,Select_Parent_Account__c,RecordTypeId FROM Account WHERE Select_Parent_Account__c IN : deleteAccIdToRTMap.keySet() AND RecordTypeId IN :deleteRTSet];
        
        for(Account acc : accountList){   
            if(deleteAccIdToRTMap.get(acc.Select_Parent_Account__c).contains(acc.RecordTypeId)){
                delelteAccList.add(acc);
            }
        }
        insert insertAccList;
        delete delelteAccList;
    }

    //////////////////////////////////////////////////////////////////////
    public static Integer rootFolderCount;
    public static Integer childFolderCount;
    public static Boolean isFirstTime = true;
    @future(callout=true)
    public static void getRootFolderCount(Set<Id> newAccIdSet){
        String accessToken='ya29.a0Ael9sCOOjB1K0udo5gp3IrLgt1nv-UEWOLKzOgMxwnK-g-f7AH0R_GPEAj-0zO6FKM4nOXZKh3tSH0JaCgUwEi6GxOjloceiA8nQ3UhyL7cwFc6jbsCo6S29jobbS0qWSQhy3amHe9pvqcP-Mj48wgcXCczfaCgYKAUASARASFQF4udJhF70l-iGJIm1CKTbmQJJwrw0163';
        System.debug('inside getRootFolderCount MEthod');
        HttpResponse response = GoogleAuthentication.getGoogleFolderCount(accessToken);
        System.debug('JSON Output first response == '+JSON.deserializeUntyped(response.getBody()));

        

        Map<String, Object> rootFoldersMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        List<Object> fileList = (List<Object>) rootFoldersMap.get('files');
        rootFolderCount = fileList.size();
        System.debug('Root Folder Count = '+rootFolderCount);

        String firstFolderId = (String)((Map<String, Object>)fileList[0]).get('id');
        System.debug('first fodler id === '+firstFolderId);
        System.debug('before second ');

        //updating account
        List<Account> updateAccList = new List<Account>();
        for(Account acc : [SELECT Id,Root_Folder_Count__c FROM Account WHERE Id IN : newAccIdSet]){
            acc.Root_Folder_Count__c = rootFolderCount;
            //acc.Child_Folder_Count__c = childFolderCount;
            updateAccList.add(acc);
        }
        isFirstTime = false;
        update updateAccList;
        System.debug('updateAccList === '+updateAccList);
        //second callout
        
        HttpResponse responseChild = GoogleAuthentication.getGoogleFirstFolderCount(firstFolderId,accessToken);
        System.debug('JSON Output second response == '+JSON.deserializeUntyped(responseChild.getBody()));
        Map<String, Object> childFolders = (Map<String, Object>) JSON.deserializeUntyped(responseChild.getBody());
        List<Object> folderList = (List<Object>) childFolders.get('files');
        childFolderCount = folderList.size();
        System.debug('first Folder Count = '+childFolderCount);

        List<Account> updateAccAgainList = new List<Account>();
        for(Account acc : [SELECT Id,Child_Folder_Count__c FROM Account WHERE Id IN : newAccIdSet]){
            //acc.Root_Folder_Count__c = rootFolderCount;
            acc.Child_Folder_Count__c = childFolderCount;
            updateAccAgainList.add(acc);
        }
        //isFirstTime = false;
        update updateAccAgainList;
    }




    // public static void updateAccount(Set<Id> newAccIdSet){
    //     List<Account> updateAccList = new List<Account>();
    //     for(Account acc : [SELECT Id,Root_Folder_Count__c FROM Account WHERE Id IN : newAccIdSet]){
    //         acc.Root_Folder_Count__c = rootFolderCount;
    //         acc.Child_Folder_Count__c = childFolderCount;
    //         updateAccList.add(acc);
    //     }
    //     update updateAccList;

    // }
    //////////////////////////////////////////////////////////////////////
}