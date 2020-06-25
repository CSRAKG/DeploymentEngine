public class RM_DeploymentDetails {

    
    @AuraEnabled
    public static List<RM_DeploymentDetail__c> getDeploymentDetailSuccess(){
         
        
        List<RM_DeploymentDetail__c>  deploymentDetailSuccess=[Select Done__c,ErrorMessage__c,StateDetail__c,Status__c,ComponentFailure__c,
                                                          TestCompleted__c ,DeploymentId__c,CancelledbyName__c,Canceled__c,TotalComponent__c,
                                                          TotalTest__c ,ErrorStatusCode__c ,ComponentDeployed__c,CreatedDate__c	 from RM_DeploymentDetail__c
                                                               where Status__c='success'and CreatedDate = LAST_N_DAYS:30   order by CreatedDate__c	 Desc];
        return deploymentDetailSuccess;
    }
    
        @AuraEnabled
    public static List<RM_DeploymentDetail__c> getDeploymentDetailFailure(){
         
        
        List<RM_DeploymentDetail__c>  deploymentDetailFailure=[Select RunTestErrorMessage__c,ComponentFailureMessage__c, Done__c,ErrorMessage__c,StateDetail__c,Status__c,ComponentFailure__c,
                                                          TestCompleted__c ,DeploymentId__c,CancelledbyName__c,Canceled__c,TotalComponent__c,
                                                          TotalTest__c ,ErrorStatusCode__c ,ComponentDeployed__c,CreatedDate__c	 from RM_DeploymentDetail__c
                                                        where Status__c='failure' and CreatedDate = LAST_N_DAYS:30 order by CreatedDate__c Desc ];
        return deploymentDetailFailure;
    }  
       @AuraEnabled
    public static RM_DeploymentDetail__c getDeploymentDetail(string deploymentid){
         
        
        RM_DeploymentDetail__c  deploymentDetail=[Select Id,RunTestErrorMessage__c,ComponentFailureMessage__c, Done__c,ErrorMessage__c,StateDetail__c,Status__c,ComponentFailure__c,
                                                          TestCompleted__c ,DeploymentId__c,CancelledbyName__c,Canceled__c,TotalComponent__c,
                                                          TotalTest__c ,ErrorStatusCode__c ,ComponentDeployed__c,CreatedDate__c	 from RM_DeploymentDetail__c
                                                        where Id=:deploymentid  ];
        return deploymentDetail;
    }  
    
    
}