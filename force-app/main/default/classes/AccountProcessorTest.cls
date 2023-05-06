@isTest
public class AccountProcessorTest {
    @isTest static void countContactTest(){
        Account acc = new Account(Name='testAccount');
        insert acc;
        
        Contact con1 = new Contact(AccountId=acc.Id,LastName='testCon1',Order__c=1);
        Contact con2 = new COntact(AccountId=acc.Id,LastName='testCon2',Order__c=9);
        List<Contact> conList = new List<Contact>();
        conList.add(con1);
        conList.add(con2);
        insert conList;
        
        List<Id> accountId = new List<Id>();
        accountId.add(acc.Id);
        Test.startTest();
        AccountProcessor.countContacts(accountId);
        
        Test.stopTest();
    }
}