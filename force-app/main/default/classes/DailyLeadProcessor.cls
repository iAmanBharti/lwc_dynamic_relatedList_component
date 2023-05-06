public class DailyLeadProcessor implements Schedulable{
    public void execute(SchedulableContext sc){
        List<Lead> lead = [SELECT Id,Name FROM Lead WHERE LeadSource=null LIMIT 200];
        for(Lead led : lead){
            led.LeadSource = 'Dreamforce';
        }
        update lead;
    }
}