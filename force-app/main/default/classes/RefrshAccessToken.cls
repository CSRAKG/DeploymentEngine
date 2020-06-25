public class RefrshAccessToken {
    public class jsonWrapper
{
// here rows is the name of field in json this variable should be
public string access_token ;
 }
public static   String RefreshAccessToken(String RefreshToken) {
              
         String clientId ='3MVG97quAmFZJfVwECQOtaGh29aW7o6cHq9TPNpVzvOmo4Mwua5NewG_bdgfi5gJb8Bv5zodOwjA2zzx4g5zc';
         String clientsecret ='D85B22D0FF2EE24E639B44BB8FD57E47E4AEF8187872AF717824E06015B17648';
       //  String refresh='5Aep861ARUdJp8j3X3EySwWIN4UT75YHsxADS8mZmB6MsCQ3qNoL3FdvhjgxHoyLQfl3GQ7U65mOe7TRh6UWbgb';
        String refresh =RefreshToken;
         
         String reqbody = 'client_id='+clientId+'&client_secret='+clientsecret+'&grant_type=refresh_token&refresh_token='+refresh;
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
          if (httpResponse.getStatusCode() == 200 ) {  
			   response = JSON.serializePretty( JSON.deserializeUntyped(httpResponse.getBody()) );  
               Jsondatawrapper = (jsonWrapper)JSON.deserialize(response,jsonWrapper.class);

		 } else {  
			   System.debug(' httpResponse ' + httpResponse.getBody() );  
			   throw new CalloutException( httpResponse.getBody() );  
		 }  
    } catch( System.Exception e) {  
		 System.debug('ERROR: '+ e);  
		 throw e;  
} 
         return Jsondatawrapper.access_token.SubString(15);

     }
}