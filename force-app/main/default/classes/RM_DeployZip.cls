public class RM_DeployZip {
    
    @AuraEnabled
    public static string datavalue(String rawData){
        return deployZip(rawData).Id;
    }
    @AuraEnabled
    public static string checkstatus(string asynResId){
        return checkAsyncRequest(asynResId);
    }
    private static MetadataService.AsyncResult deployZip(String ZipData){
        // Deploy zip file posted back from the page action function				
        MetadataService.MetadataPort service = createService();
        MetadataService.DeployOptions deployOptions = new MetadataService.DeployOptions();
        deployOptions.allowMissingFiles = false;
        deployOptions.autoUpdatePackage = false;
        deployOptions.checkOnly = false;
        deployOptions.ignoreWarnings = false;
        deployOptions.performRetrieve = false;
        deployOptions.purgeOnDelete = false;
        deployOptions.rollbackOnError = true;
        deployOptions.testLevel = 'NoTestRun';
        deployOptions.singlePackage = true;					
        return service.deploy(ZipData, DeployOptions);
    }	
    private static string checkAsyncRequest(String resultId){	
        string msg;
        // Check the status of the retrieve request
        MetadataService.MetadataPort service = createService();
        MetadataService.DeployResult deployResult = service.checkDeployStatus(resultId, true);
        if(deployResult.done)
        {
            // Deployment errors?
            if(deployResult.details!=null && deployResult.details.componentFailures!=null){
                for(MetadataService.DeployMessage deployMessage : deployResult.details.componentFailures)
                    if(deployMessage.problem!=null)
                    msg = msg+deployMessage.fileName+'(Line: ' + deployMessage.lineNumber + ': Column:' + deployMessage.columnNumber + ') : '+deployMessage.problem;}
            msg = 'deployment complete';
        }
        else
        {
            msg = 'Deploying...';
        }	
        return msg;
    }
    private static MetadataService.MetadataPort createService(){ 
        /*OrgTempData__c Orgdata =[select id,DestinationOrg__c from OrgTempData__c];
          string selectedOrg = [select id,DestinationOrg__c from OrgTempData__c].DestinationOrg__c;
          OrgAuthorizationInfo__c OrgInfo = [select id,AccessToken__c,RefreshToken__c,instance_url__c	 from OrgAuthorizationInfo__c where id=:selectedOrg limit 1];
          string accessToken = RefrshAccessToken.RefreshAccessToken(OrgInfo.RefreshToken__c);
          MetadataService.MetadataPort service = new MetadataService.MetadataPort();
          service.SessionHeader = new MetadataService.SessionHeader_element();
          service.SessionHeader.sessionId = accessToken;
          service.endpoint_x = OrgInfo.instance_url__c+'/services/Soap/m/42.0';
          system.debug('service.SessionHeader.sessionId@@@@'+service.SessionHeader.sessionId);
          system.debug('service.endpoint_x@@@@'+service.endpoint_x);*/
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = '!ARkAQNJaxmNyCS5fOVOXHyAVD8g_Yncvt_7QQEpHgIrxhQruor4ENPyrUJvFsA9ItOaXdPy_SVOZYS.6o3GZy1iBChKwS8hR';
        service.endpoint_x = 'https://narutouzumaki-dev-ed.my.salesforce.com/services/Soap/m/42.0';
        return service;		
    }		 
}