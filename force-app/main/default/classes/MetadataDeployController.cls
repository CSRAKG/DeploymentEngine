public with sharing class MetadataDeployController 
{	    
    public static MetadataService.AsyncResult deployZip(String ZipData,String testlevel,String allTestClass){
        // Deploy zip file posted back from the page action function	
        MetadataService.MetadataPort service = createService_Deploy();
        MetadataService.DeployOptions deployOptions = new MetadataService.DeployOptions();
        deployOptions.allowMissingFiles = false;
        deployOptions.autoUpdatePackage = false;
        deployOptions.checkOnly = false;
        deployOptions.ignoreWarnings = false;
        deployOptions.performRetrieve = false;
        deployOptions.purgeOnDelete = false;
        deployOptions.rollbackOnError = true;
        //deployOptions.testLevel = 'NoTestRun';
        deployOptions.singlePackage = true;	
        deployOptions.testLevel = testlevel;
        // Set the appropriate test level.
        // deployOptions.setTestLevel(TestLevel.RunSpecifiedTests);
        if(testlevel=='RunSpecifiedTests'){
            String[] testclass = allTestClass.split(',');
            deployOptions.runTests=testclass;
            
        }
        return service.deploy(ZipData, DeployOptions);
    }
    public static String checkAsyncRequest(String asyncResultId)
    {	
        string response ='';
        // Check the status of the retrieve request
        MetadataService.MetadataPort service = createService_Deploy();
        MetadataService.DeployResult deployResult = service.checkDeployStatus(asyncResultId, true);
        if(deployResult!=null){
            System.debug('asyncResultId'+    asyncResultId);
            System.debug('deployResult.numberTestsCompleted@@@@@@@   '+deployResult.numberTestsCompleted);
            System.debug('deployResult.errorMessage@@@@@@@   '+deployResult.errorMessage);
            System.debug('deployResult.success@@@@@@@   '+deployResult.success);
            System.debug('deployResult.checkOnly@@@@@@@   '+deployResult.checkOnly);
            System.debug('deployResult.rollbackOnError@@@@@@@   '+deployResult.rollbackOnError);
            System.debug('deployResult.stateDetail@@@@@@@   '+deployResult.stateDetail);
            System.debug('deployResult.id@@@@@@@   '+deployResult.id);
            System.debug('deployResult.canceledBy@@@@@@@   '+deployResult.canceledBy);
            System.debug('deployResult.canceledByName@@@@@@@   '+deployResult.canceledByName);
            System.debug('deployResult.errorStatusCode@@@@@@@   '+deployResult.errorStatusCode);
            System.debug('deployResult.numberComponentErrors@@@@@@@   '+deployResult.numberComponentErrors);
            System.debug('deployResult.numberComponentsDeployed@@@@@@@   '+deployResult.numberComponentsDeployed);
            System.debug('deployResult.numberComponentsTotal@@@@@@@   '+deployResult.numberComponentsTotal);
            //  System.debug('deployResult.details.componentFailures@@@@@@@   '+deployResult.details.componentFailures);
            System.debug('deployResult.numberTestsTotal@@@@@@@   '+deployResult.numberTestsTotal);
            System.debug('deployResult.numberTestErrors@@@@@@@   '+deployResult.numberTestErrors);
            System.debug('deployResult.status@@@@@@@   '+deployResult.status);
            System.debug('deployResult.errorStatusCode@@@@@@@   '+deployResult.errorStatusCode);
            //      System.debug('deployResult.details.runTestResult.numFailures@@@@@@@   '+deployResult.details.runTestResult.numFailures);
            //System.debug('deployResult.details.runTestResult.numTestsRun@@@@@@@   '+deployResult.details.runTestResult.numTestsRun);
            
            // System.debug('deployResult.details.runTestResult.codeCoverage@@@@@@@   '+deployResult.details.runTestResult.codeCoverage);
            //System.debug('deployResult.details.runTestResult.codeCoverageWarnings@@@@@@@   '+deployResult.details.runTestResult.codeCoverageWarnings);
            //System.debug('deployResult.details.runTestResult.failures@@@@@@@   '+deployResult.details.runTestResult.failures);
            //  System.debug('deployResult.details.runTestResult.successes@@@@@@@   '+deployResult.details.runTestResult.successes);
            // System.debug('deployResult.details.retrieveResult.errorMessage@@@@@@@   '+deployResult.details.retrieveResult.errorMessage);
            //System.debug('deployResult.details.retrieveResult.errorStatusCode@@@@@@@   '+deployResult.details.retrieveResult.errorStatusCode);
            String RunTestErrorMessage='';
            if(deployResult.details!=null&&deployResult.details.runTestResult!=null){
                
                System.debug('deployResult.details.runTestResult.numFailures@@@@@@@   '+deployResult.details.runTestResult.numFailures);
                System.debug('deployResult.details.runTestResult.numTestsRun@@@@@@@   '+deployResult.details.runTestResult.numTestsRun);
                
                System.debug('deployResult.details.runTestResult.codeCoverage@@@@@@@   '+deployResult.details.runTestResult.codeCoverage);
                System.debug('deployResult.details.runTestResult.codeCoverageWarnings@@@@@@@   '+deployResult.details.runTestResult.codeCoverageWarnings);
                if(deployResult.details.runTestResult.codeCoverageWarnings!=null)
                {
                    for(integer i=0;i<deployResult.details.runTestResult.codeCoverageWarnings.size();i++){
                        RunTestErrorMessage=RunTestErrorMessage+' '+deployResult.details.runTestResult.codeCoverageWarnings[i].message;
                    }
                }
                System.debug('deployResult.details.runTestResult.codeCoverageWarnings@@@@@@@   '+RunTestErrorMessage);
                
                System.debug('deployResult.details.runTestResult.failures@@@@@@@   '+deployResult.details.runTestResult.failures);
                System.debug('deployResult.details.runTestResult.successes@@@@@@@   '+deployResult.details.runTestResult.successes);
                
                
            }
            if(deployResult.details!=null&&deployResult.details.retrieveResult!=null){
                
                System.debug('deployResult.details.retrieveResult.errorMessage@@@@@@@   '+deployResult.details.retrieveResult.errorMessage);
                System.debug('deployResult.details.retrieveResult.errorStatusCode@@@@@@@   '+deployResult.details.retrieveResult.errorStatusCode);
                
                //  System.debug('deployResult.details.runTestResult.codeCoverage@@@@@@@   '+deployResult.details.runTestResult.codeCoverage);
                //System.debug('deployResult.details.runTestResult.codeCoverageWarnings@@@@@@@   '+deployResult.details.runTestResult.codeCoverageWarnings);
                //System.debug('deployResult.details.runTestResult.failures@@@@@@@   '+deployResult.details.runTestResult.failures);
                //System.debug('deployResult.details.runTestResult.successes@@@@@@@   '+deployResult.details.runTestResult.successes);
                
                
            }
            
            
            
            
            
            String componentFailureReason='';
            if(deployResult.done)
            {
                // Deployment errors?
                
                
                
                
                
                if(deployResult.details!=null && deployResult.details.componentFailures!=null){
                    for(MetadataService.DeployMessage deployMessage : deployResult.details.componentFailures){
                        if(deployMessage.problem!=null)
                            response = response + deployMessage.fileName + ' (Line: ' + deployMessage.lineNumber + ': Column:' + deployMessage.columnNumber + ') : ' + deployMessage.problem;
                        componentFailureReason=componentFailureReason +'     '+     deployMessage.problem     ;
                        System.debug('responsedeployMessage @@@@@@@   '+componentFailureReason);
                        
                    }
                }
                if(deployResult.success) 
                {
                    response = 'success';
                }
                else{
                    response='failure';
                }
                RM_DeploymentDetail__c deploymentresult= new  RM_DeploymentDetail__c(); 
                deploymentresult.Done__c	='True';
                
                deploymentresult.ErrorMessage__c	=deployResult.errorMessage;
                deploymentresult.StateDetail__c	=deployResult.stateDetail;
                deploymentresult.Status__c	=response;
                deploymentresult.TestCompleted__c	=deployResult.numberTestsCompleted;
                deploymentresult.ComponentFailure__c	=componentFailureReason;
                deploymentresult.DeploymentId__c	=deployResult.id;
                deploymentresult.TotalTest__c	=deployResult.numberTestsTotal;
                deploymentresult.TotalComponent__c	=deployResult.numberComponentsTotal;
                deploymentresult.Canceled__c	=deployResult.canceledBy;
                deploymentresult.CancelledbyName__c	=deployResult.canceledByName;
                deploymentresult.ErrorStatusCode__c		=deployResult.errorStatusCode;
                deploymentresult.ComponentDeployed__c		=deployResult.numberComponentsDeployed;
                deploymentresult.RunTestErrorMessage__c=RunTestErrorMessage;
                deploymentresult.ComponentFailureMessage__c=componentFailureReason;
                insert deploymentresult;
            }
        }
        return response;
    }
    
    private static MetadataService.MetadataPort createService_Deploy()
    { 
        OrgTempData__c Orgdata =[select id,DestinationOrg__c from OrgTempData__c];
        string selectedOrg = [select id,DestinationOrg__c from OrgTempData__c].DestinationOrg__c;
        OrgAuthorizationInfo__c OrgInfo = [select id,AccessToken__c,RefreshToken__c,instance_url__c	 from OrgAuthorizationInfo__c where id=:selectedOrg limit 1];
        string accessToken = RefrshAccessToken.RefreshAccessToken(OrgInfo.RefreshToken__c);
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = accessToken;
        service.endpoint_x = OrgInfo.instance_url__c+'/services/Soap/m/42.0';
        system.debug('service.SessionHeader.sessionId@@@@'+service.SessionHeader.sessionId);
        system.debug('service.endpoint_x@@@@'+service.endpoint_x);
        
        // service.SessionHeader.sessionId = '!ARkAQGIhm_VOdI7XrtbElH1EGpgAHKUaxfgVeZVBtM6mCiYtj8AHtf4pxzOTJie7ArvcY0NwAFgDfOraAB.dAQPBGSDaz35y';
        // service.endpoint_x = 'https://narutouzumaki-dev-ed.my.salesforce.com/services/Soap/m/42.0';
        return service;		
    }
}