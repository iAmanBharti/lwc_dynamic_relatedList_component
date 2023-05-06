@isTest//(SeeAllData = true)

public class OpportunityTriggerHandlerTest{
    
    @testSetup
    static void opportunityDataTest(){

        /*Date d = Date.valueOf('2022-12-31');
        //Account acc1 = new Account(Name = 'A1');
        Opportunity oppo = new Opportunity(Name='O51',CloseDate = d,StageName='Prospacting',AccountId='0012w000018hcqwAAA');

        insert oppo;*/
        TestDataFactory.testRecords(3,5);
    }
    @isTest static void opportunityInsertTest(){
        Account acc = [SELECT Id,Name,Stage__c FROM Account WHERE Name='A1'];
        System.assert(acc != null);
        Date d = Date.valueOf('2022-12-31');
        Opportunity oppo1 = new Opportunity(Name='O101',CloseDate = d,StageName = 'Prospecting',AccountId=acc.Id);
        test.startTest();
        insert oppo1;

        List<Opportunity> opp = [SELECT Id,Name FROM Opportunity WHERE AccountId =:acc.Id];
        Account acct = [SELECT Id,Opportunity_Count__c FROM Account WHERE Id=:acc.Id];
        test.stopTest();
        System.assertEquals(6,opp.size(),'new records not inserted');
        System.assertEquals(6,acct.Opportunity_Count__c,'opportunity not added in count');

        try{    
            Opportunity oppo2 = new Opportunity();
            insert oppo2;
        }
        catch(DmlException e){
            System.debug('--DML Exception --'+e.getMessage());
        }
    }
    @isTest static void opportunityUpdateTest(){
        

        /*Opportunity oppo1 = [SELECT Id,Name,StageName,AccountId FROM Opportunity WHERE Name = 'O51' LIMIT 1];
        System.assert(oppo1 != null);
        Account acc = [SELECT Id,Name,Stage__c,Opportunity_Count__c FROM Account WHERE Id='0012w000018hcqwAAA'];
        Assert.areEqual(1,acc.Opportunity_Count__c);
        System.debug('----Opportunity_Count__c------'+acc.Opportunity_Count__c);
        oppo1.Name = 'O50';
        //oppo1.StageName = 'Qualification';
		insert oppo1;*/
        Opportunity oppo1 = [SELECT Id,Name,StageName,AccountId FROM Opportunity WHERE Name ='O11' LIMIT 1];
        System.assert(oppo1 != null);
        oppo1.StageName = 'Qualification';
        
        test.startTest();
        update oppo1;
        test.stopTest();
    }
    @isTest static void opportunityDeleteUndeleteTest(){
        Account acc = [SELECT Id,Name,Stage__c,Opportunity_Count__c FROM Account WHERE Name='A1'];

        Opportunity oppo1 = [SELECT Id,Name,StageName,AccountId FROM Opportunity WHERE Name ='O2' AND AccountId=:acc.Id LIMIT 1];
        
        test.startTest();
        delete oppo1;

        List<Opportunity> oppList = [SELECT Id FROM Opportunity WHERE AccountId =: acc.Id];
        System.assertEquals(4,oppList.size(),'no record was deleted');
        Account acct = [SELECT Id,Name,Stage__c,Opportunity_Count__c FROM Account WHERE Name='A1'];
        System.assertEquals(4,acct.Opportunity_Count__c,'Opportunity count not updated');
        
        
        undelete oppo1;
        List<Opportunity> oppoList = [SELECT Id FROM Opportunity WHERE AccountId =:acc.Id];
        System.assertEquals(5,oppoList.size(),'no records was undeleted');
        Account act = [SELECT Id,Name,Stage__c,Opportunity_Count__c FROM Account WHERE Name='A1'];
        System.assertEquals(5,act.Opportunity_Count__c,'Opportunity count not updated');
        test.stopTest();
    }
}