public class OauthDemoRedirectionCtrl {

       
     
    public string  authId {get;set;}
    public OauthDemoRedirectionCtrl(){
        authId = ApexPages.currentPage().getParameters().get('code'); 
        system.debug('apex page paramters are@@@@'+ApexPages.currentPage().getParameters());
    }
    public PageReference RedirectBack(){
        string orgRecordId = [select name ,OrgRecordId__c from OrgTempData__c].OrgRecordId__c;
        
        // fetching access token on the basis of auth id.
      //   requestAccessToken t =new requestAccessToken();
requestAccessToken.jsonWrapper wrapperResponse =new requestAccessToken.jsonWrapper();
        // t.jsonWrapper a =requestAccessToken.ReturnAccessToken(authId);
  wrapperResponse=     requestAccessToken.ReturnAccessToken(authId);
        OrgAuthorizationInfo__c orgauth = new OrgAuthorizationInfo__c();
        orgauth.id=orgRecordId;
        orgauth.OauthID__c = authId ;
       orgauth.AccessToken__c = wrapperResponse.access_token ;
      orgauth.RefreshToken__c = wrapperResponse.refresh_token ;
       orgauth.instance_url__c = wrapperResponse.instance_url ;
        
        orgauth.Authorised__c = true;
        upsert orgauth;
        string appUrl = 'https://devoppsapp-dev-ed.lightning.force.com/lightning/n/DevoppsApp?authId='+authId;
        PageReference pageRedirect = new PageReference(appUrl);
        return pageRedirect;
    }

}