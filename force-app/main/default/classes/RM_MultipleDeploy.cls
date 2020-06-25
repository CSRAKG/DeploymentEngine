public class RM_MultipleDeploy {
	private static final Integer METADATA_API_VERSION = 
        Integer.valueOf(new MetadataService.MetadataPort().endpoint_x.substringAfterLast('/'));
    public static string selectedValue {get;set;}
    public static string selectedValueDestination {get;set;}
    public static string selectedOrg;
    Map<String,Set<String>> zipdatamap {get;set;}
    public List<SelectOption> MetaDataTypes {get; set;}
    public String MetaDataType {get; set;}		
    public List<SelectOption> MetaDataItems {get; set;}
    public String MetaDataFolder {get; set;} 
    public String MetaDataItem {get; set;}	
    public String MetadataFileName {get; set;}
    public String MetadataFileData {get; set;}
    public MetadataService.AsyncResult AsyncResult {get; private set;}
    public String MetaDataRetrieveZip { get; private set; }	
    public string zipvalue{get; private set;}
    public List<MetadataFile> MetadataFiles { get; set; }	
    public String zipAttachmentId {get; private set;}
    public MetadataService.AsyncResult result{get; private set;}
    
    public RM_MultipleDeploy(){
		zipdatamap=new Map<String,Set<String>>();        
    }
    
    
    public SelectOption[] getselectValues() {     
        SelectOption[] options = new SelectOption[]{};
            for(OrgAuthorizationInfo__c oneRelationship : [Select  Id, org_name__c FROM OrgAuthorizationInfo__c where Authorised__c =:true]) {
                options.add(new SelectOption(
                    String.valueOf(oneRelationship.Id),oneRelationship.org_name__c));                 
            } 
        return options;           
    } 
    
    public PageReference addpackage(){
        for(string obj : MetaDataItem.split(',')){
            if(!zipdatamap.containsKey(MetaDataType))
            	zipdatamap.put(MetaDataType, new Set<String>());
            zipdatamap.get(MetaDataType).add(obj);
        }
        system.debug('zipdatamap'+zipdatamap);
        return  null;
    }
    
    public void init()
    {
        // List available Metadata Types via the 'describeMetadata' API call
        MetadataService.MetadataPort service = createService();		
        MetadataService.DescribeMetadataResult describeResult = service.describeMetadata(METADATA_API_VERSION);
        List<String> metadataTypeNames = new List<String>();
        for(MetadataService.DescribeMetadataObject metadataObject : describeResult.metadataObjects)
        {
            metadataTypeNames.add(metadataObject.xmlName);
            // Include child Metadata Types (such as CustomField, ValidationRule etc..)
            if(metadataObject.childXmlNames!=null)
                for(String childXmlName : metadataObject.childXmlNames)
                if(childXmlName!=null)
                metadataTypeNames.add(childXmlName);
        }	
        
        // Sort Metadata Types
        metadataTypeNames.sort();
        MetaDataTypes = new List<SelectOption>();				
        for(String metadataTypeName : metadataTypeNames)
            MetaDataTypes.add(new SelectOption(metadataTypeName, metadataTypeName));
        
        // Default to first Metadata Type returned	
        MetaDataType = MetaDataTypes[0].getValue();				
        // Retrieve Metadata items for the selected Metadata Type
        listMetadataItems();		
        // return null;
        string response =  InsertCustomSetdata(selectedValue);
    }
    @AuraEnabled
    public static List<OrgAuthorizationInfo__c> getOrgList() {
        return [Select Id, UserEmail__c, org_name__c, name, Authorised__c FROM OrgAuthorizationInfo__c where Authorised__c =:true];
    }
    public PageReference listMetadataItems()
    {
        // List Metadata items for the selected Metadata Type
        MetaDataItems = new List<SelectOption>();		
        MetadataService.MetadataPort service = createService();				
        List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();		
        MetadataService.ListMetadataQuery queryLayout = new MetadataService.ListMetadataQuery();
        if(MetaDataFolder!=null && MetaDataFolder.length()>0)
            queryLayout.folder = MetaDataFolder;
        queryLayout.type_x = MetaDataType;
        queries.add(queryLayout);		
        MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, METADATA_API_VERSION);
        
        // Sort
        List<String> fullNames = new List<String>();
        if(fileProperties!=null)
        {
            for(MetadataService.FileProperties fileProperty : fileProperties)
                fullNames.add(fileProperty.fullName);
            fullNames.sort();
            for(String fullName : fullNames)
                MetaDataItems.add(new SelectOption(fullName,EncodingUtil.urlDecode(fullName, 'UTF-8')));
        }
        
        return null;	
    }
    
    public PageReference retrieveMetadataItem()
    {		
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Retrieving metadata...'));
        // Reset state from any previous requests
        metaDataRetrieveZip = null;
        // Construct unmanaged package with list of desired components to retrieve in zip
        MetadataService.MetadataPort service = createService();	
        MetadataService.RetrieveRequest retrieveRequest = new MetadataService.RetrieveRequest();
        retrieveRequest.apiVersion = METADATA_API_VERSION;
        retrieveRequest.packageNames = null;
        retrieveRequest.singlePackage = true;
        retrieveRequest.specificFiles = null;
        retrieveRequest.unpackaged = new MetadataService.Package_x();
        retrieveRequest.unpackaged.types = new List<MetadataService.PackageTypeMembers>();
        for(String obj : zipdatamap.keySet()){
            MetadataService.PackageTypeMembers packageType = new MetadataService.PackageTypeMembers();
            packageType.name = obj;
            packageType.members = new List<String>(zipdatamap.get(obj));
            retrieveRequest.unpackaged.types.add(packageType);
        }
        /*packageType.name = MetaDataType; 
        packageType.members = new String[] { MetaDataItem };
            system.debug('MetaDataItem'+MetaDataItem);
        retrieveRequest.unpackaged.types.add(packageType);*/
        
        AsyncResult = service.retrieve(retrieveRequest);
        return null;	
    }
    
    public PageReference deploy(){
        MetadataDeployController obj = new MetadataDeployController();
        result = obj.deployZip(zipvalue);
        system.debug('zipvalue'+zipvalue);
        system.debug('result'+result);
        system.debug('selectedValueDestination'+selectedValueDestination);
        return null;
    }
    
    public PageReference checkdeploymentresult(){
        MetadataDeployController obj = new MetadataDeployController();
        String response = obj.checkAsyncRequest(result);
        if(response == null)
        {
            result = null;
        } 
        return null;
    }
    
    public PageReference checkAsyncRequest()
    {
        // Check the status of the retrieve request
        MetadataService.MetadataPort service = createService();
        MetadataService.RetrieveResult retrieveResult = service.checkRetrieveStatus(AsyncResult.Id, true);
        if(retrieveResult.done)
        {
            // Errors?
            if(retrieveResult.status != 'Succeeded')
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, retrieveResult.errorMessage));
                AsyncResult = null;				
            }
            else
            {
                // Place Base64 encoded zip data onto the page for the JSZip library to handle
                MetaDataRetrieveZip = retrieveResult.zipFile;
                zipvalue = retrieveResult.zipFile;
                MetadataFiles = new List<MetadataFile>();
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Expanding...'));
                AsyncResult = null;
            }
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Retrieving metadata...'));
        }	
        
        return null;
    }
    
    public PageReference receiveMetadataZipFile()
    {
        // In this example the retrieved metadata is stored in viewstate in production cases you would probably use a custom object / attachment
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Expanding ' + MetaDataFileName + '...'));
        MetadataFile metaDataFile = new MetadataFile();
        metaDataFile.fullName = MetaDataFileName;
        metaDataFile.content = MetaDataFileData;
        MetadataFiles.add(metaDataFile);
        return null;
    }
    
    public PageReference receiveComplete()
    {
        // Completed, cleared Base64 encoded zip data from viewstate
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Metadata retrieve completed'));
        //creating zip file.
        Zippex zip = new Zippex();
        string fileName = 'MetaFile.zip';
        //iterating through MetadataFiles for path and file to be zipped.
        for(MetadataFile metaDataRaw : MetadataFiles){
            zip.addFile(metaDataRaw.fullName, Blob.valueOf(metaDataRaw.content), null);
        }
        Blob zipData = zip.getZipArchive();
        //attachment-id to download zip file
        zipAttachmentId = saveToDocument(zipData,fileName);
        MetaDataRetrieveZip = null;		
        return null;
    }
    
    private static MetadataService.MetadataPort createService()
    { 
        // final ConnectorConfig metadataConfig = new ConnectorConfig();
        //  metadataConfig.setServiceEndpoint(Url);
        //  metadataConfig.setSessionId(Accesstoken);
        //  this.metadataConnection = new MetadataConnection(metadataConfig); 
        
        System.debug('@@@@@selectedValue' + selectedValue);
        System.debug('@@@@@selectedOrg' + selectedOrg);
        if(selectedValue !=null){
            selectedOrg = selectedValue;
        }
        else{
            selectedOrg = [select name ,SourceOrg__c from OrgTempData__c].SourceOrg__c;
        }
        String RecordId = selectedOrg;
        OrgAuthorizationInfo__c OrgInfo = [select id,AccessToken__c,RefreshToken__c,instance_url__c	 from OrgAuthorizationInfo__c where id=:RecordId limit 1];
        System.debug('@@@@@OrgInfo'+OrgInfo);
       // String name =OrgInfo.instance_url__c.substringAfter('//');
       // name=name.substringBefore('.');
      //  name = name+'devoppsapp';
      //  RemoteSetting.createRemoteSiteSettings(name,OrgInfo.instance_url__c);
        string accessToken = RefrshAccessToken.RefreshAccessToken(OrgInfo.RefreshToken__c);
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        //   service.SessionHeader.sessionId ='00D0o000001QQ6e!ARQAQB89RMV7nOY5pLGJo1VB26Rt_CUeioSSDCPiMaezKzf836r5VEWFMqoUu_LjYh_CJEB2DCTDfSM_9u52UOIzwfZcfUJB';
        //  service.SessionHeader.sessionId = UserInfo.getSessionId();
        service.SessionHeader.sessionId = accessToken;
        service.endpoint_x = OrgInfo.instance_url__c+'/services/Soap/m/42.0';
        // service.endpoint_x = 'https://krish25-dev-ed.my.salesforce.com/services/Soap/m/42.0';
        return service;		
    }	
    
    public PageReference downloadMetadataZipFile()
    {
        // In this example the retrieved metadata is stored in viewstate in production cases you would probably use a custom object / attachment
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Expanding zip ' + MetaDataFileName + '...'));
        MetadataFile metaDataFile = new MetadataFile();
        metaDataFile.fullName = MetaDataFileName;
        metaDataFile.content = MetaDataFileData;
        MetadataFiles.add(metaDataFile);
        if(zipAttachmentId != 'error' || zipAttachmentId != null){
            PageReference downloadPage = new PageReference('/servlet/servlet.FileDownload?file='+zipAttachmentId);
            //PageReference downloadPage1 = new PageReference('https://devoppsapp-dev-ed.lightning.force.com/lightning/n/DevoppsApp');
            downloadPage.setRedirect(true);
            downloadPage.setRedirectCode(301);
            return downloadPage;
        }
        else
            return null; 
    }
    
    //method for inserting zip file to attachment.
    public static String saveToDocument( Blob zipData, String fileName ){
        try{
            String userId = UserInfo.getUserId();
            List<Document> docList = [SELECT Id, Name, FolderId, Body FROM Document WHERE Name = :fileName AND FolderId = :userId LIMIT 1 ];
            Document doc = new Document();
            if( docList == null || docList.size() == 0 ) {
                doc.Name = fileName;
                doc.FolderId = UserInfo.getUserId();
                doc.Body = zipData;
                insert doc;
            } else {
                doc = docList.get(0);
                doc.Body = zipData;
                update doc;
            }
            return doc.Id ;
        } catch ( Exception ex ) {
            return 'error' ;
        }
    }
    
    
    public static string  InsertCustomSetdata(string selectedOrg) {
        string returnMsg ='';
        //fetches or creates a Custom Setting at the organization level 
        try{
            // insert select source org value in custom setting for tem basis 
            OrgTempData__c setting = OrgTempData__c.getOrgDefaults();
            setting.SourceOrg__c = selectedOrg;
            upsert setting;
            returnMsg ='Success';
        }
        catch(exception e){
            returnMsg ='Error';
        }
        return returnMsg;
    }
    public void  InsertCustomSetdataDestination() {
        string returnMsg ='';
        //fetches or creates a Custom Setting at the organization level 
        try{
            // insert select source org value in custom setting for tem basis 
            OrgTempData__c setting = OrgTempData__c.getOrgDefaults();
            setting.DestinationOrg__c = selectedValueDestination;
            upsert setting;
            returnMsg ='Success';
        }
        catch(exception e){
            returnMsg ='Error';
        }
        //   return returnMsg;
    }
    /**
* Simple container class for retrieve metadata file, may as well leverage the Metadata API class for this
**/
    public class MetadataFile extends MetadataService.MetadataWithContent
    {
        public String getFullname()
        {
            return fullName;
        }
        
        public String getContent()
        {
            return content;
        }
    }
}