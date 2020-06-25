public class requestAccessToken2 {

    public static String ReturnAccessToken() {
        
        String clientId = '3MVG97quAmFZJfVwECQOtaGh29aW7o6cHq9TPNpVzvOmo4Mwua5NewG_bdgfi5gJb8Bv5zodOwjA2zzx4g5zc';
        String clientsecret ='D85B22D0FF2EE24E639B44BB8FD57E47E4AEF8187872AF717824E06015B17648';
        
        //    https://login.salesforce.com/services/oauth2/authorize?response_type=code&display=popup&client_id={{ConnApp_ConsumerKey}}&redirect_uri={{ConnApp_CallbackURL}}
        //    String password = 'krishna251091@gmail.com';
        //   string username = 'Krishna@25';
        //    string redirectionurl = 'https://www.salesforce.com/oauth2/callback';
        //    
        string redirectionurl = 'https://devoppsapp-dev-ed.my.salesforce.com/apex/AccessTokenfetch';
        string authorizationCode ='aPrxKlcUBVrDN5055GRxobLAbdW5kpGQgcrPaCzjWiR.sL.jhVBzm_K8DU.dutL0C5pIZbTGDQ==';
        // web server flow request
        //   String reqbody = 'https://login.salesforce.com/services/oauth2/authorize?response_type=code&display=popup&client_id=' + clientId + '&redirect_uri=' + redirectionurl + '&response_type=code';
        
        String reqbody = 'https://login.salesforce.com/services/oauth2/token HTTP/1.1?grant_type=authorization_code&code='+authorizationCode+'&client_id=' + clientId + '&redirect_uri=' + redirectionurl + '&response_type=code';
        Http h = new Http();
        HttpRequest req1 = new HttpRequest();
        req1.setBody(reqbody);
        req1.setMethod('GET');
        
        // web server flow request
        req1.setEndpoint('https://login.salesforce.com/services/oauth2/token HTTP/1.1');
        HttpResponse res = h.send(req1);
        string location = '';
        /*   if(res.getStatusCode() == 302){
location = res.getHeader('Location');
}*/
        
        
        /*    while (res.getStatusCode() == 302) {
system.debug('inside while loop@@@@');
HttpRequest req = new HttpRequest();
system.debug('header location@@@@'+res.getHeader('Location'));
req.setEndpoint(res.getHeader('Location'));
// res = new Http().send(req);
//   system.debug('value of res@@@@'+res);
}*/
        
        return location;
    }

}