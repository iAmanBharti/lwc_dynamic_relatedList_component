public class WeeklyAccountUpdateScheduler implements Schedulable {
    public void execute(SchedulableContext ctx) {
  
        WeeklyAccountUpdate batch = new WeeklyAccountUpdate();
        Database.executeBatch(batch);   
    }
}