@RestResource(urlMapping = '/Accounts/*/Contacts')
global class AccountManager {
    @HttpGet
    global static Account getAccount(){
        RestRequest request = RestContext.request;
        String accId = request.requestURI.substringBetween('Accounts/','/Contacts');
        System.debug('-===================================in AccountManager accId-'+accId);
        Account acc = [SELECT Id,Name,(SELECT Id,LastName FROM Contacts) FROM Account WHERE Id=:accId];
        System.debug('=======*****in accountManager****===='+acc);
        return acc;
       
    }
}