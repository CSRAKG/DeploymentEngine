public with sharing class CreateOrgObj {
    
    @AuraEnabled
    public static string createOrg(OrgAuthorizationInfo__c org){
        
        insert org;
        return org.Id;
    }

}