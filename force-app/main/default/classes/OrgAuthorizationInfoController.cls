public with sharing class OrgAuthorizationInfoController{
    @AuraEnabled
    public static List<OrgAuthorizationInfo__c> getOrgList() {
        return [Select  Id,UserEmail__c, org_name__c,name,Authorised__c FROM OrgAuthorizationInfo__c ];
    }
     @AuraEnabled
    public static List<OrgAuthorizationInfo__c> deleteOrg(String OrgId)
    {
        OrgAuthorizationInfo__c delOrg=[Select Id from OrgAuthorizationInfo__c where id=:OrgId];
        delete delOrg;
        return getOrgList();
    }
	@auraEnabled
    public static String ReturnAccessToken() {
        
        String clientId = '3MVG97quAmFZJfVwECQOtaGh29aW7o6cHq9TPNpVzvOmo4Mwua5NewG_bdgfi5gJb8Bv5zodOwjA2zzx4g5zc';
        String clientsecret ='D85B22D0FF2EE24E639B44BB8FD57E47E4AEF8187872AF717824E06015B17648';
        //    https://login.salesforce.com/services/oauth2/authorize?response_type=code&display=popup&client_id={{ConnApp_ConsumerKey}}&redirect_uri={{ConnApp_CallbackURL}}
        
      //  String password = 'krishna251091@gmail.com';
      //  string username = 'Krishna@25';
        
        //    string redirectionurl = 'https://www.salesforce.com/oauth2/callback';
        //  string redirectionurl = 'https://semykolon-dev-ed--c.visualforce.com/apex/OauthDemoRedirection';
        string redirectionurl = ' https://devoppsapp-dev-ed.my.salesforce.com/apex/OauthDemoRedirection';
        // web server flow request
        String reqbody = 'https://login.salesforce.com/services/oauth2/authorize?response_type=code&display=popup&client_id=' + clientId + '&redirect_uri=' + redirectionurl + '&response_type=code';
        Http h = new Http();
        HttpRequest req1 = new HttpRequest();
        req1.setBody(reqbody);
        req1.setMethod('GET');
        
        // web server flow request
        req1.setEndpoint('https://login.salesforce.com/services/oauth2/authorize');
        HttpResponse res = h.send(req1);
        string location = '';
        if(res.getStatusCode() == 302){
            location = res.getHeader('Location');
        }
        return location;
    }
    @AuraEnabled
    public static string  InsertCustomSetdata(string orgId) {
        string returnMsg ='';
        //fetches or creates a Custom Setting at the organization level 
        try{
            OrgTempData__c setting = OrgTempData__c.getOrgDefaults();
            setting.OrgRecordId__c = orgId;
            upsert setting;
            returnMsg ='Success';
        }
        catch(exception e){
              returnMsg ='Error';
        }
       return returnMsg;
    }
}