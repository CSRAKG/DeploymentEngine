public with sharing class deployment_sessionidDemo {
   public string selectedValue {get;set;}
    @RemoteAction
    public static String checkRetrieveStatus(String asyncProcessId,Boolean includeZip) {
        MetadataFactory.MetadataOutlet port = getPort();
        MetadataFactory.RetrieveResult result = port.checkRetrieveStatus(asyncProcessId, includeZip);
        System.debug(result.zipFile);
        
        return result.zipFile; 
    }
    
    @RemoteAction
    public static String retrieve_x() {
        MetadataFactory.MetadataOutlet port = getPort();
        
        MetadataFactory.PackageTypeMembers member = new MetadataFactory.PackageTypeMembers();
        member.name = 'ApexClass';
        member.members = new String[]{'*'};
            
            MetadataFactory.PackageTypeMembers[] types = new MetadataFactory.PackageTypeMembers[]{member};
                
                MetadataFactory.Package_x pkg = new MetadataFactory.Package_x();
        pkg.types = types;
        
        MetadataFactory.RetrieveRequest r = new MetadataFactory.RetrieveRequest();
        r.apiVersion = 48.0;
        r.unpackaged = pkg;
        r.packageNames = new String[]{};
            r.singlePackage = false;
        r.specificFiles = new String[]{};
            
            system.debug('r'+r);
        system.debug('types'+pkg.types);
        
        MetadataFactory.AsyncResult result = port.retrieve_x(r);
        
        System.debug(result.id);
        System.debug(result.state);
        
        return result.id;
    }
    
    public PageReference redirect(){
        PageReference pg = new PageReference('https://devoppsapp-dev-ed.lightning.force.com/lightning/n/DevoppsApp');
        return pg;
    }
    
    public static MetadataFactory.MetadataOutlet getPort() {
        MetadataFactory.SessionHeader_element sheader = new MetadataFactory.SessionHeader_element();
      //  sheader.sessionid = UserInfo.getSessionId();
        sheader.sessionid ='00D0o000001QQ6e!ARQAQF_2r8m6aC4fEWZHNn4rk2NNr8FmNLWsiTBtJV7jYbM17ovdlbbZ216dtFz3i_dY9l9RiUOq5axgKTDw7h65GLFpoA5g';
        
        MetadataFactory.AllOrNoneHeader_element aonHeader= new MetadataFactory.AllOrNoneHeader_element();
        aonHeader.allOrNone = true;
        
        MetadataFactory.MetadataOutlet port = new MetadataFactory.MetadataOutlet();
        port.SessionHeader = sheader;
        port.AllOrNoneHeader = aonHeader;
        return port;
    }
    @AuraEnabled
    public static List<OrgAuthorizationInfo__c> getOrgList() {
        return [Select Id, UserEmail__c, org_name__c, name, Authorised__c FROM OrgAuthorizationInfo__c];
    }
    //the values for the dropdown come from here
    public SelectOption[] getselectValues() {     
        SelectOption[] options = new SelectOption[]{};
            for(OrgAuthorizationInfo__c oneRelationship : [Select  Id, org_name__c FROM OrgAuthorizationInfo__c]) {
                options.add(new SelectOption(
                    String.valueOf(oneRelationship.Id),oneRelationship.org_name__c));                 
            } 
        return options;           
    } 
}