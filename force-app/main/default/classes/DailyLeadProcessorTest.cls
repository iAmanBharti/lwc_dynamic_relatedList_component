@isTest
public class DailyLeadProcessorTest {
    @isTest static void testLead(){
        
        String CRON_EXP = '20 15 10 5 1 ?';
        List<Lead> leadList = new List<Lead>();
        for(Integer i=0;i<200;i++){
            leadList.add(new Lead(LastName ='test Lead'+i,Company='Delta CX',Status='Open - Not Contacted'));
        }
        insert leadList;
        Test.startTest();
        String jobId = System.schedule('Daily Lead Processor',CRON_EXP,new DailyLeadProcessor());
        Test.stopTest();
    }
}