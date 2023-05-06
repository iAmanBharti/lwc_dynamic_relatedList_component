@isTest
public class AccountTriggerHandlerTest {
	@testSetup
    static void accountDataTest(){
       /* Account acc = new Account(Name='A1',Stage__c ='Prospecting');
        insert acc;*/
        TestDataFactory.testRecords(3,5);
    }
    @isTest static void accountUpdateTest(){

        List<Account> ac = [SELECT Id,Name,Stage__c FROM Account];
        
        System.assert(ac != null,'their is no account');
        System.assertEquals(3, ac.size(),'required count of account not inserted');
        System.debug('--total account->>'+ac.size());
        

        Account acc = [SELECT Id,Name,Stage__c FROM Account WHERE Name='A1' LIMIT 1];

        List<Opportunity> op = [SELECT Id,Name,StageName FROM Opportunity WHERE AccountId =: acc.Id];
        System.debug('--oppo count on account 1--'+op.size());

        System.assert(acc != null);
        System.debug('--account Id--'+acc.Id);
        
        test.startTest();
        acc.Stage__c = 'Qualification';
        update acc;
        
        acc.Stage__c = 'Prospecting';
        update acc;
        test.stopTest();
    }
    @isTest static void accountUpdateAgainTest(){
        
        Account acc = [SELECT Id,Name,Stage__c FROM Account WHERE Name='A1' LIMIT 1];
        acc.Rating = 'Hot';
        test.startTest();
        update acc;
        test.stopTest();
    }

}