public class CaseTriggerHandler {
    public static void beforeInsert(List<Case> newCase){
        
        Double max =0;
        Double min =0;
        for(Case c : newCase){
            if(min == 0 || min > c.Order__c){
                min = c.Order__c;
            }
            if(max < c.Order__c){
                max = c.Order__c;
            }
        }
        List<Case> caseToBeUpdate = [SELECT Id,Order__c FROM Case WHERE Order__c >= :min];
        for(Case cas : caseToBeUpdate){
            for(Case c : newCase){
                if(cas.Order__c >= c.Order__c){
                    cas.Order__c++;
                }
            }
        }
        update caseToBeUpdate;
    }
    /******************************************************************************************************/
        /******************************************************************************************************/
    /******************************************************************************************************/
    /******************************************************************************************************/

    /*public static void beforeUpdate(Map<Id,Case> newCaseMap,Map<Id,Case> oldCaseMap){
      
        System.debug('--before update handler--');
        Double min = 0;
        Double max = 0;
        for(Case cas : newCaseMap.values()){
            if(min ==0 || cas.Order__c < min){
                min = cas.Order__c;
            }
            if(max < cas.Order__c){
                max = cas.Order__c;
            }
        }
        for(Case cas : oldCaseMap.values()){
            if(min > cas.Order__c){
				min = cas.Order__c;                
            }
            if(max < cas.Order__c){
                max = cas.Order__c;
            }
        }
        System.debug('---min-->'+min+'---max---'+max);
        List<Case> caseToBeUpdateList = [SELECT Id,Order__c FROM Case WHERE Order__c >= :min AND Order__c <= :max ORDER BY Order__c];
        System.debug('caseToBeUpdateList'+caseToBeUpdateList.size());
        
        System.debug('------> CaseToBeUpdateList <------');
        for(Integer i = 0; i<caseToBeUpdateList.size();i++){
            System.debug(caseToBeUpdateList[i].Order__c);
        }
        
        Map<Id,Case> toBeUpdateCaseMap = new Map<Id,Case>();
        for(Case c : caseToBeUpdateList){
            System.debug('---toBeUpdate-----Order---------------------------->'+c.Order__c);
            for(Case ca : newCaseMap.values()){
                System.debug('---new map values------Order-->'+ca.Order__c);
                if(ca.Order__c < oldCaseMap.get(ca.Id).Order__c && c.Order__c >= ca.Order__c && c.Order__c < oldCaseMap.get(ca.Id).Order__c){
                    c.Order__c++;
                    toBeUpdateCaseMap.put(c.Id,c);
                    System.debug('---toBeUpdate-----Order---plus---------->'+c.Order__c);
                }
                else if(ca.Order__c > oldCaseMap.get(ca.Id).Order__c && c.Order__c <= ca.Order__c && c.Order__c > oldCaseMap.get(ca.Id).Order__c){
                    c.Order__c--;
                    toBeUpdateCaseMap.put(c.Id,c);
                    System.debug('---toBeUpdate-----Order------minus------->'+c.Order__c);
                }
            }
            System.debug('---toBeUpdate----after-->---------------------------Order-->'+c.Order__c);
        }
        List<Case> updateCaseList = toBeUpdateCaseMap.values();
        for(Integer i=0;i<updateCaseList.size();i++){
            	System.debug('---->Id---->'+updateCaseList[i].Id+'---order--->'+updateCaseList[i].Order__c);
        }
        		System.debug('------->just before update-------');
        update updateCaseList;  
        		System.debug('------>>>>The END<<<<<<-------');
        
    }*/
    
    
   /* public static void beforeUpdate(Map<Id,Case> newCaseMap,Map<Id,Case> oldCaseMap){
        Double max = 0;
        Double min = 0;
        Set<Id> newIdSet = newCaseMap.keySet();
        Map<Double,Id> newOrderCaseMap = new Map<Double,Id>();
        for(Case newCase : newCaseMap.values()){
            if(newCase.Order__c > max){
                max = newCase.Order__c;
            }
            if(oldCaseMap.get(newCase.Id).Order__c > max){
                max = oldCaseMap.get(newCase.Id).Order__c;
            }
            if(newCase.Order__c < min || min == 0){
                min = newCase.Order__c;
            }
            if(oldCaseMap.get(newCase.Id).Order__c < min){
                min = oldCaseMap.get(newCase.Id).Order__c;
            }
            newOrderCaseMap.put(newCase.Order__c,newCase.Id);
        }
        
        System.debug('---newOrderCaseMap-->'+newOrderCaseMap);
        Set<Double> newOrderSet = newOrderCaseMap.keySet();
        
        System.debug('---->Min--'+min+'-----Max----->>>'+max);
        
        Set<Id> newCaseIdSet = newCaseMap.keySet();
        
        List<Case> caseToBeUpdateList = [SELECT Id,Order__c FROM Case WHERE Order__c >= :min AND Order__c <= :max ORDER BY Order__c];
        System.debug('---CaseToBeUpdateList----'+caseToBeUpdateList.size());
        for(Case c : caseToBeUpdateList){
            System.debug('----->'+c.Order__c);
        }
        List<Case> updatedCaseList = new List<Case>();
       
        Integer caseIndex = 0;
        Integer j = 0;
        System.debug('---loop count till this number-->'+(max-min+1));
        
        for(Integer i=0;i<(max-min);i++){//min =1,max =6
            //if(!newOrderSet.contains(caseToBeUpdateList[i].Order__c)){
            if(!newCaseIdSet.contains(caseToBeUpdateList[i].Id)){
                updatedCaseList[j] = caseToBeUpdateList[i];
            }
            
        }
        
         System.debug('----->updatedCaseList<---');
        for(Integer i=0;i<(min+max);i++){
            System.debug('--Id == '+updatedCaseList[i].Id+'--Order == '+updatedCaseList[i].Order__c);
        }
        
        
    }*/
    
}