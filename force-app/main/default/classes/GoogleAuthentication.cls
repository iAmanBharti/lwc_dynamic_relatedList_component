public class GoogleAuthentication {
    private String key = '784189186673-ug8jjo2i63p8e91vhlml2fud3nq3sm19.apps.googleusercontent.com';
    private String secret = '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';
    private String redirectURI = 'https://cunning-hawk-pe368m-dev-ed--c.trailblaze.vf.force.com/apex/GoogleIntegration';
    private String authToken;
    private String accessToken;

    
    public GoogleAuthentication(){
        authToken = ApexPages.currentPage().getParameters().get('code');
        System.debug('AuthToken ============= - '+authToken);
        getAccessToken();
    } 
    public PageReference gdriveAuth(){
        PageReference pr = new PageReference(new AuthURIapiRequest(key,redirectURI).authenticationURI);
        return pr;
    }

    public void getAccessToken(){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://accounts.google.com/o/oauth2/token');
        req.setHeader('Content-type', 'application/x-www-form-urlencoded');
        String msgBody = 
            'code='+authToken+
            '&client_id='+key+
            '&client_secret='+secret+
            '&redirect_uri='+redirectURI+
            '&grant_type=authorization_code';
        req.setHeader('Content-length',String.valueOf(msgBody.length()));   
        req.setBody(msgBody);
        HttpResponse response = http.send(req);
        String res = response.getBody();
        System.debug('=========='+res);

        JSONParser parser = JSON.createParser(res);
        while(parser.nextToken() != null){
            if((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                String fieldName = parser.getText();
                parser.nextToken();
                if(fieldName == 'access_token'){
                    accessToken = parser.getText();
                    System.debug('++++++++'+accessToken);
                }
            }
        }
    }  
}