public class AddPrimaryContact implements Queueable{
    private Contact cont;
    private String state;
    public AddPrimaryContact(Contact con,String state){
        this.cont = con;
        this.state = state;
    }
    public void execute(QueueableContext context){
        List<Account> accList = [SELECT Id,Name FROM Account WHERE BillingState=:state LIMIT 200];
        List<Contact> conList = new List<Contact>();
        for(Account acc:accList){
            Contact contact = cont.clone();
            contact.AccountId = acc.Id;
            conList.add(contact);
        }
        System.debug('----conList count'+conList.size());
        insert conList;
    }
}