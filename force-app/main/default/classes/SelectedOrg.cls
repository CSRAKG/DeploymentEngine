public class SelectedOrg {
     @AuraEnabled
    public static List<OrgAuthorizationInfo__c> getOrgList() {
        return [Select Id, UserEmail__c, org_name__c, name, Authorised__c FROM OrgAuthorizationInfo__c where Authorised__c =:true];
    }
}