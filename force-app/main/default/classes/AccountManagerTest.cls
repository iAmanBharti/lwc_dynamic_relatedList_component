@isTest
private class AccountManagerTest {
    @isTest static void getAccountByIdTest(){
        Id accId = createTestRecord();
        System.debug('account Id====================================='+accId);
        RestRequest request = new RestRequest();
        request.requestUri = 'https://cunning-hawk-pe368m-dev-ed.trailblaze.my.salesforce.com/services/apexrest/Accounts/'+accId+'/Contacts';
    	request.httpMethod = 'GET';
        RestContext.request = request;
        Account thisAccount = AccountManager.getAccount();
        System.debug('---=in test=---'+thisAccount.Contacts);
        System.assert(thisAccount != null);
        System.assertEquals('testAccount',thisAccount.Name,'Account not inserted');
    }
    //helper
    private static Id createTestRecord(){
        System.debug('--in create method-');
        Account acc = new Account(Name='testAccount');
        insert acc;
        Contact con = new Contact(LastName='testContact',AccountId=acc.Id,Order__c = 1);
        insert con;
        System.debug('--===================******=============================acc.Id->'+acc.Id);
         System.debug('--=====================================================con.Id->'+con.Id+'cons accId'+con.AccountId);
        return acc.Id;
    }
}