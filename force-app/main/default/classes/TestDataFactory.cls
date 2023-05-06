@isTest
public class TestDataFactory {
	public static void testRecords(Integer accNum,Integer oppoPerAccountNum){
        
        List<Account> accountList = new List<Account>();
        
        for(Integer i = 0; i<accNum;i++){
            Account a = new Account(Name='A'+i,Stage__c = 'Prospecting');
            accountList.add(a);
        }

        insert accountList;

        List<Opportunity> oppoList = new List<Opportunity>();

        Date d = Date.valueOf('2022-12-31');
        for(Integer i=0;i< accNum;i++){
            Account acc = accountList[i];
            for(Integer j=0;j<oppoPerAccountNum;j++){
                Opportunity opp = new Opportunity(Name='O'+j,AccountId = acc.Id,CloseDate = d,StageName = 'Prospecting');
                oppoList.add(opp);
            }
        }
        insert oppoList;

    }
}//Qualification