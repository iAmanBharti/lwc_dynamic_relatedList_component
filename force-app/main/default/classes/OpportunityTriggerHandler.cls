public class OpportunityTriggerHandler {

    //public static Boolean isFirstTime = true;

    public static void afterInsert(List<Opportunity> newOppoList){
        
        Set<Id> accountIdSet = new Set<Id>();//Set of AccountId, of Opportunity that insert

        Map<Id,Opportunity> oppoMap = new Map<Id,Opportunity>();//Map of Opportunity that insert // oppIdToOppMap
        
        for(Opportunity oppo : newOppoList){
            if(oppo.AccountId != null){     // skipping Opportunity that don't assign to an Account
                oppoMap.put(oppo.Id,oppo);
                accountIdSet.add(oppo.AccountId);
            }  
        }
        
        System.debug('--------We are here----in afterInsert--->');
        //List <Account> accUpdateList = [SELECT Id,Stage__c,Opportunity_Count__c FROM Account WHERE Id IN : accountIdSet];
        //Map <Id,Account> accUpdateMap = new Map<Id,Account>([SELECT Id,Stage__c,Opportunity_Count__c FROM Account WHERE Id IN : accountIdSet]);
        
        Map <Id,Account> accUpdateMap = new Map<Id,Account>();//Map of Accounts on which new Opportunity insert
        //List of Accounts on which new Opportunity insert
        List<Account> accUpdateList = [SELECT Id,Stage__c,Opportunity_Count__c FROM Account WHERE Id IN : accountIdSet];
        
        Set<String> accStageSet = new Set<String>();//Set of Account StageName
       
        //Putting value in Map
        for(Account acc : accUpdateList){
            acc.Opportunity_Count__c = 0;
            accUpdateMap.put(acc.Id,acc);
            accStageSet.add(acc.Stage__c);
        }
        System.debug('-opp stage name set---'+accStageSet);
        List<Opportunity> allOppList = [SELECT Id,AccountId,StageName FROM Opportunity WHERE AccountId IN :accountIdSet AND StageName IN :accStageSet];
        //List<AggregateResult> stageCount = [SELECT COUNT(Id) countId FROM Opportunity WHERE AccountId IN : accountIdSet AND StageName IN :accStageSet];
        //increasing Opportunity count on Account when new Opportunity insert and StageName same as Account Stage
        for(Opportunity opp : allOppList){
            System.debug('--All Opportunity --count'+allOppList.size()+'--StageName--'+opp.StageName);
            if(opp.StageName == accUpdateMap.get(opp.AccountId).Stage__c){
                accUpdateMap.get(opp.AccountId).Opportunity_Count__c +=1;
            }
        }
        /***** */
        //Putting value in Map
        
        //increasing Opportunity count on Account when new Opportunity insert and StageName same as Account Stage
        /*for(Opportunity oppo : newOppoList){
            if(oppo.StageName == accUpdateMap.get(oppo.AccountId).Stage__c){
                accUpdateMap.get(oppo.AccountId).Opportunity_Count__c += 1;
            }
        }*/
       /*for(Account acc : accUpdateList){
           System.debug('------AccountId----'+acc.Id);
            for(Opportunity oppo : newOppoList){
                System.debug('--opportunity--'+oppo.Id);
                if(acc.Id == oppo.AccountId && acc.Stage__c == oppo.StageName){
                    acc.Opportunity_Count__c ++;
                }
            }
        }*/
        update accUpdateList;
        
    }
    public static void beforeDelete(List<Opportunity> oldOppoList,Map<Id,Opportunity> oldOppoMap){
        
        Set<Id> accountIdSet = new Set<Id>();//Set of AccountId of Opportunity that delete

        for(Opportunity oppo : oldOppoList){
            if(oppo.AccountId != null){
                accountIdSet.add(oppo.AccountId);
            }  
        }
        //
        List <Account> accDeleteList = [SELECT Id,Stage__c,Opportunity_Count__c FROM Account WHERE Id IN : accountIdSet];
        //
        Map<Id,Account> accDeleteMap = new Map<Id,Account>();//Map of Accounts on which Oppertunity delete
        //
        Set<String> accStageSet = new Set<String>();//Set of Account StageName 
        for(Account acc : accDeleteList){
            acc.Opportunity_Count__c = 0;
            accDeleteMap.put(acc.Id,acc);
            accStageSet.add(acc.Stage__c);
        }
        /****** */
        List<Opportunity> allOppList = [SELECT  Id,AccountId,StageName FROM Opportunity  WHERE AccountId IN : accountIdSet AND StageName IN : accStageSet ];//GROUP BY StageName
        //List<AggregateResult> allOppLists = [SELECT  StageName,COUNT(Id) oppCount FROM Opportunity  WHERE AccountId IN : accountIdSet AND StageName IN : accStageSet GROUP BY StageName];//
        
        for(Opportunity opp : allOppList){
            System.debug('--all oppo list--count'+allOppList.size()+'-stage Name--'+opp.StageName);
            if(opp.StageName == accDeleteMap.get(opp.AccountId).Stage__c){
                accDeleteMap.get(opp.AccountId).Opportunity_Count__c +=1;
            }
        }
        ///
        //System.debug('-allOppList#############--'+allOppLists);
        /*for(Opportunity opp : allOppList){
            System.debug('--all oppo list--count'+allOppList.size()+'-stage Name--'+opp.StageName);
            if(opp.StageName == accDeleteMap.get(opp.AccountId).Stage__c){
                accDeleteMap.get(opp.AccountId).Opportunity_Count__c +=1;
            }
        }*/
        /****** */
        // decreasing opportunity count of releted Account when an Opportunity delete with same stage as Account
        for(Opportunity oppo : oldOppoMap.values()){
            if(oppo.StageName == accDeleteMap.get(oppo.AccountId).Stage__c){
                accDeleteMap.get(oppo.AccountId).Opportunity_Count__c -= 1;
            }
        }
        /*for(Account acc : accDeleteList){
            for(Opportunity oppo : oldOppoList){
                if(acc.Id == oppo.AccountId && acc.Stage__c == oppo.StageName){
                    acc.Opportunity_Count__c --;
                }
            }
        }*/
        update accDeleteList;
    }
    /*******************
     * ******************
     * *****************
     */

    public static void afterUpdate(List<Opportunity> newOppoUpdateList,Map<Id,Opportunity> oldOppoMap){
        System.debug('--new oppo.---'+newOppoUpdateList);
        System.debug('--old oppo.---'+oldOppoMap);
        //if(isFirstTime){
          //  isFirstTime = false;
            Set<Id> accountIdSet = new Set<Id>(); // Set of AccountId on which Opportunity changes

            //
            /*for(Opportunity oppo : newOppoUpdateList){// adding value to accountIdSet
                if(oppo.StageName != oldOppoMap.get(oppo.Id).StageName && oppo.AccountId != null){
                    accountIdSet.add(oppo.AccountId);
                } 
                if(oppo.AccountId != oldOppoMap.get(oppo.Id).AccountId){
                    accountIdSet.add(oldOppoMap.get(oppo.Id).AccountId);
                } 
            }
            System.debug('--Account Id Set--'+accountIdSet);
            */
            for(Opportunity oppo : newOppoUpdateList){
                accountIdSet.add(oppo.AccountId);   
            }
            for(Opportunity oppo : oldOppoMap.values()){
                accountIdSet.add(oppo.AccountId);
            }
            System.debug('--Account Id Set--'+accountIdSet);
            /********* */
            List<Account> accUpdateList = [SELECT Id,Stage__c,Opportunity_Count__c FROM Account WHERE Id IN : accountIdSet];
            System.debug('---oppo-after--update-----here--->'+accUpdateList);

            Map<Id,Account> accUpdateMap = new Map<Id,Account>();//Map of AccountId and Account
            Set<String> accStageSet = new Set<String>();//Set of Account StageName
            for(Account acc : accUpdateList){
                acc.Opportunity_Count__c = 0;
                accUpdateMap.put(acc.Id,acc);
                accStageSet.add(acc.Stage__c);
            }
            System.debug('---aac stage set-'+accStageSet);
            System.debug('---aac update Map-'+accUpdateMap);
            //
            List<Opportunity> allOppoList = [SELECT Id,AccountId,StageName FROM Opportunity WHERE AccountId IN : accountIdSet AND StageName IN : accStageSet];
            
            System.debug('---allOppList update---- Count->>'+allOppoList.size()+'---'+allOppoList);
            //for(Opportunity oppo : newOppoUpdateList){
            for(Opportunity oppo : allOppoList){    
                System.debug('opp stageName====>'+oppo.StageName+',----accountId===>'+accUpdateMap.get(oppo.AccountId).Stage__c);
               if(oppo.StageName == accUpdateMap.get(oppo.AccountId).Stage__c){
                    System.debug('-----First if---');
                    accUpdateMap.get(oppo.AccountId).Opportunity_Count__c +=1;
                }
                else if(oldOppoMap.get(oppo.Id).StageName == accUpdateMap.get(oppo.AccountId).Stage__c){
                    System.debug('-----Second if---');    
                    accUpdateMap.get(oppo.AccountId).opportunity_Count__c -=1;  
                }
                /*
                System.debug('--accId-'+oppo.AccountId);
                System.debug('--oldaccId--'+oldOppoMap.get(oppo.Id).AccountId);
                System.debug('--old OppstageName--'+oldOppoMap.get(oppo.Id).StageName+'--old accStage--'+accUpdateMap.get(oldOppoMap.get(oppo.Id).AccountId).Stage__c);
                */
                /*if(oppo.AccountId != oldOppoMap.get(oppo.Id).AccountId && oldOppoMap.get(oppo.Id).StageName == accUpdateMap.get(oldOppoMap.get(oppo.Id).AccountId).Stage__c){
                    System.debug('-----third if---');
                    accUpdateMap.get(oldOppoMap.get(oppo.Id).AccountId).Opportunity_Count__c -=1;
                } */
            }
            
           /*for(Opportunity oppo : newOppoUpdateList){
                System.debug('--oppo --Name-'+oppo.Name+'--old count-->'+accUpdateMap.get(oldOppoMap.get(oppo.Id).AccountId).Opportunity_Count__c);
                if(oppo.AccountId != oldOppoMap.get(oppo.Id).AccountId && oldOppoMap.get(oppo.Id).StageName == accUpdateMap.get(oldOppoMap.get(oppo.Id).AccountId).Stage__c){
                    System.debug('-----third if---');
                    accUpdateMap.get(oldOppoMap.get(oppo.Id).AccountId).Opportunity_Count__c -=1;
                }
                System.debug('----after count---'+accUpdateMap.get(oldOppoMap.get(oppo.Id).AccountId).Opportunity_Count__c);
            }*/
            


            /********* */

            /*List <Account> accUpdateList = [SELECT Id,Stage__c,Opportunity_Count__c FROM Account WHERE Id IN : accountIdSet];
            System.debug('---oppo-after--update-----here--->'+accUpdateList);
            for(Account acc : accUpdateList){
                System.debug('---account--->'+acc.Id+'--before Oppo-count-'+acc.Opportunity_Count__c);
                for(Opportunity oppo : newOppoUpdateList){
                    //if(oppo.AccountId != oldOppoMap.get(oppo.AccountId).AccountId && oldOppoMap.get(oppo.AccountId).StageName == ){
                    if(oppo.AccountId == acc.Id && oldOppoMap.get(oppo.Id).StageName == acc.Stage__c && oppo.StageName != acc.Stage__c ||
                        oppo.AccountId != acc.Id && oldOppoMap.get(oppo.Id).AccountId == acc.Id && oldOppoMap.get(oppo.Id).StageName == acc.Stage__c){
                        acc.Opportunity_Count__c --;
                    }
                    else if((oppo.AccountId == acc.Id && oppo.stageName == acc.Stage__c) && 
                            (oldOppoMap.get(oppo.Id).StageName != acc.Stage__c || oldOppoMap.get(oppo.Id).AccountId != acc.Id)){
                    
                // else if(oppo.AccountId == acc.Id && oldOppoMap.get(oppo.Id).StageName != acc.Stage__c && oppo.stageName == acc.Stage__c 
                    //       || oppo.AccountId == acc.Id && oldOppoMap.get(oppo.Id).AccountId != acc.Id && oppo.stageName == acc.Stage__c){
                        acc.Opportunity_Count__c ++;
                    }
                }
                System.debug('---account--->'+acc.Id+'--after Oppo-count-'+acc.Opportunity_Count__c);
            }*/
        //************************** */
        /*Set<Id> oldAccountIdSet = new Set<Id>();
        for(Opportunity oppo : oldOppoMap.values()){
            oldAccountIdSet.add(oppo.AccountId);
        }
        List<Account> oldAccountList = [SELECT Id,Stage__c,Opportunity_Count__c FROM Account WHERE Id IN : oldAccountIdSet];
        for(Account acc : oldAccountList){
            for(Opportunity oppo : newOppoUpdateList){
                if(acc.Id == oldOppoMap.get(oppo.Id).AccountId && acc.Stage__c == oldOppoMap.get(oppo.Id).StageName && acc.Id != oppo.AccountId){
                    acc.Opportunity_Count__c --;
                }
            }
        }
        List<Account> accountToBeUpdateList = new List<Account>();
        accountToBeUpdateList.addAll(accUpdateList);
        System.debug('---accUpdateList---'+accUpdateList);
        accountToBeUpdateList.addAll(oldAccountList);
        System.debug('---oldAccountList---'+accUpdateList);*/
        //************************* */
        update accUpdateList;
        //update accountToBeUpdateList;
        //}
    }

    public static void afterUndelete(List<Opportunity> newOppoList){
        
        Set<Id> accountIdSet = new Set<Id>();//AccountId Set of undelete opportunity

        Map<Id,Opportunity> oppoMap = new Map<Id,Opportunity>();//Map of Opportunity that undelete
        
        
        for(Opportunity oppo : newOppoList){
            if(oppo.AccountId != null){     //if a opportunity that recover/undelete that don't have AccountId
                oppoMap.put(oppo.Id,oppo);
                accountIdSet.add(oppo.AccountId);
            }

           
        }
        //List of Accounts where opportuntiy undelete
        List<Account> accUpdateList = [SELECT Id,Stage__c,Opportunity_Count__c FROM Account WHERE Id IN : accountIdSet];
        
        Map<Id,Account> accUpdateMap = new Map<Id,Account>();//Map of account where opportunity undelete
        
        Set<String> accStageSet = new Set<String>();//Set of Account StageName

        for(Account acc : accUpdateList){
            acc.Opportunity_Count__c = 0;
            accUpdateMap.put(acc.Id,acc);
            accStageSet.add(acc.Stage__c);
        }
        

        /******** */
        List<Opportunity> allOppList = [SELECT Id,AccountId,StageName FROM Opportunity WHERE AccountId IN :accountIdSet AND StageName IN : accStageSet];
        for(Opportunity oppo : allOppList){
            if(oppo.StageName == accUpdateMap.get(oppo.AccountId).Stage__c){
                accUpdateMap.get(oppo.AccountId).Opportunity_Count__c +=1;//updating opportunity count on Account
            }
        }
        /******* */
        /*for(Opportunity oppo : newOppoList){
            if(oppo.StageName == accUpdateMap.get(oppo.AccountId).Stage__c){
                accUpdateMap.get(oppo.AccountId).Opportunity_Count__c += 1;//updating opportunity count on Account
            }
        }*/
        /*for(Account acc : accUpdateList){
            for(Opportunity oppo : newOppoList){
                if(acc.Id == oppo.AccountId && acc.Stage__c == oppo.StageName){
                    acc.Opportunity_Count__c ++;
                }
            }
        }*/
        update accUpdateList;
    }
}