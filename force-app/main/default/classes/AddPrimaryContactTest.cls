@isTest
public class AddPrimaryContactTest{
     @isTest static void testAccountRecords(){
        List<Account> acc = new List<Account>();
        for(Integer i=0;i<50;i++){
            acc.add(new Account(Name='test account'+i,BillingState='NY'));
        }
        for(Integer i=0;i<50;i++){
            acc.add(new Account(Name='test account'+i,BillingState='CA'));
        }
        insert acc;
        Contact cont = new Contact(LastName = 'contest',Order__c = 5);
        insert cont;
        String state ='CA';
        AddPrimaryContact priCon = new AddPrimaryContact(cont,state);
        Test.startTest();
        System.enqueueJob(priCon);
        Test.stopTest();
    }
}