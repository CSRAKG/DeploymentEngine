public class requestAccessToken {
    
    public   class jsonWrapper
{
// here rows is the name of field in json this variable should be
public string access_token ;
public string refresh_token;
public string instance_url ; 
}
    
 public static jsonWrapper ReturnAccessToken(string authCode) {
    
         
         String clientId ='3MVG97quAmFZJfVwECQOtaGh29aW7o6cHq9TPNpVzvOmo4Mwua5NewG_bdgfi5gJb8Bv5zodOwjA2zzx4g5zc';
         String clientsecret ='D85B22D0FF2EE24E639B44BB8FD57E47E4AEF8187872AF717824E06015B17648';
         string redirectionurl ='https://devoppsapp-dev-ed.my.salesforce.com/apex/OauthDemoRedirection';
         //string authorizationCode ='aPrxKlcUBVrDN5055GRxobLAba67i_uPuC5xZ88B7fflvTYCqalyY6_qJBJHaYv8yhdIHxa7VQ==';
          string authorizationCode =authCode;
         String reqbody ='client_id='+clientId+'&client_secret='+clientsecret+'&grant_type=authorization_code&code='+authorizationCode+'&redirect_uri='+redirectionurl;
         HttpRequest req1 = new HttpRequest();    
         //req1.setTimeout(120000);
         req1.setHeader('Accept', 'application/json');
         req1.setHeader('Content-type', 'application/x-www-form-urlencoded');
         req1.setBody(reqbody);
         req1.setMethod('POST');
         // web server flow request
         req1.setEndpoint('https://login.salesforce.com/services/oauth2/token');
         String response = '';
 jsonWrapper Jsondatawrapper=new jsonWrapper();
    try{
          Http h = new Http();
         HttpResponse httpResponse = h.send(req1);
         system.debug('res@@@@'+httpResponse);
          if (httpResponse.getStatusCode() == 200 ) {  
			   response = JSON.serializePretty( JSON.deserializeUntyped(httpResponse.getBody()) );  
                Jsondatawrapper = (jsonWrapper)JSON.deserialize(response,jsonWrapper.class);
              System.debug('aaa'+ Jsondatawrapper);
              
               String name =Jsondatawrapper.instance_url.substringAfter('//');
                 name=name.substringBefore('.');
              List<String> res = name.split('-');
              String domainName='';
              for(integer i=0;i<res.size();i++){
                  domainName=domainName+res.get(i)+'_';
              }
                domainName = domainName+'devoppsapp';
              System.debug('name@@@@  '+domainName);
               RemoteSetting.createRemoteSiteSettings(domainName ,Jsondatawrapper.instance_url);

		 } else {  
			   System.debug(' httpResponse ' + httpResponse.getBody() );  
			   throw new CalloutException( httpResponse.getBody() );  
		 }  
    } catch( System.Exception e) {  
		 System.debug('ERROR: '+ e);  
		 throw e;  
} 
    System.debug(' ** response ** : ' + response );  
      
         return Jsondatawrapper;
     }
 
}