public with sharing class deploywithzip {
    
    	    
    public blob getzip{get;  set;}
    public string getdata{get;  set;}
    public boolean show{get; set;}
    public MetadataService.AsyncResult AsyncResult{get; private set;}
    
    public deploywithzip(){
        show = true;
    }
    
    public PageReference datavalue(){
        string zipdata = EncodingUtil.base64Encode(getzip);
        system.debug('zipdata'+zipdata);
        string zipname = getdata.substringBefore('.');
        system.debug('getzip-----'+EncodingUtil.base64Encode(getzip));
        system.debug('getdata-----'+getdata);
        system.debug('zipname'+zipname);
        AsyncResult = deployZip(zipdata);
        show = false;
        return null;
    }
    
    public PageReference checkstatus(){
        checkAsyncRequest();
        return null;
    }
    
	public MetadataService.AsyncResult deployZip(String ZipData)
	{
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Deploying...'));

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
	
	public PageReference checkAsyncRequest()
	{	
		// Check the status of the retrieve request
		MetadataService.MetadataPort service = createService();
		MetadataService.DeployResult deployResult = service.checkDeployStatus(AsyncResult.Id, true);
		if(deployResult.done)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Deployment complete'));

			// Deployment errors?
			if(deployResult.details!=null && deployResult.details.componentFailures!=null)
				for(MetadataService.DeployMessage deployMessage : deployResult.details.componentFailures)
					if(deployMessage.problem!=null)
						ApexPages.addMessage(
							new ApexPages.Message(ApexPages.Severity.Error, 
								deployMessage.fileName + 
									' (Line: ' + deployMessage.lineNumber + ': Column:' + deployMessage.columnNumber + ') : ' + 
										deployMessage.problem));
			AsyncResult = null;
		}
		else
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Deploying...'));
		}	
		return null;
	}
	
	private static MetadataService.MetadataPort createService()
	{ 
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
        
        string selectedOrg = [select name ,SourceOrg__c from OrgTempData__c].SourceOrg__c;
        String RecordId = selectedOrg;
        OrgAuthorizationInfo__c OrgInfo = [select id,AccessToken__c,RefreshToken__c,instance_url__c	 from OrgAuthorizationInfo__c where id=:RecordId limit 1];
        string accessToken = RefrshAccessToken.RefreshAccessToken(OrgInfo.RefreshToken__c);
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = accessToken;
        service.endpoint_x = OrgInfo.instance_url__c+'/services/Soap/m/42.0';
	//	service.SessionHeader.sessionId = '!ARkAQNJaxmNyCS5fOVOXHyAVD8g_Yncvt_7QQEpHgIrxhQruor4ENPyrUJvFsA9ItOaXdPy_SVOZYS.6o3GZy1iBChKwS8hR';
      //  service.endpoint_x = 'https://narutouzumaki-dev-ed.my.salesforce.com/services/Soap/m/42.0';
		return service;		
	}		


}