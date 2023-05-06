global class AuthURIapiRequest {
    global String authenticationURI = '';
    public AuthURIapiRequest(String clientKey,String redirectURI){
        String key = EncodingUtil.urlEncode(clientKey,'UTF-8');
        String uri = EncodingUtil.urlEncode(redirectURI,'UTF-8');
        String authURI = 'https://accounts.google.com/o/oauth2/v2/auth?'+
            'response_type=code&'+
            'client_id='+key+
            '&scope=https://www.googleapis.com/auth/drive'+
            '&redirect_uri='+uri+
            '&state=security_token%3D138r5719ru3e1%26url%3Dhttps%3A%2F%2Foauth2-login-demo.example.com%2FmyHome'+
            '&login_hint=aman1182119221@example.com'+
            '&nonce=0394852-3190485-2490358'+
            '&hd=gmail.com'+
            '&access_type=offline'+
            '&prompt=consent';
        authenticationURI = authURI;
    }
}