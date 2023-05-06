public class AccountProcessor {
    @future(callout=true)
    public static void countContacts(List<Id> accountIdList){//Number_Of_Contacts__c
        Map<Id,Double> contactCountMap = new Map<Id,Double>();
        List<Contact> conList = [SELECT Id,AccountId FROM Contact];
        for(Contact con:conList){
            if(contactCountMap.containsKey(con.AccountId)){
                Double count = contactCountMap.get(con.AccountId);
                contactCountMap.put(con.AccountId,++count);//contactCountMap.get(con.AccountId)+1; 
            }
            else{
                contactCountMap.put(con.AccountId,1);
            }
        }
        System.debug('-count map--'+contactCountMap);
    }
}