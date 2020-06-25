public class RM_MetadataRetrieveController 
{    
    public static Map<String,List<String>>  metadata_all=new  Map<String,List<String>>();
    private static final Integer METADATA_API_VERSION = Integer.valueOf(new MetadataService.MetadataPort().endpoint_x.substringAfterLast('/'));
    public static string selectedValue {get;set;}
    public static string selectedValueDestination {get;set;}
    public static string selectedOrg;
    
    public static List<SelectOption> MetaDataTypes {get; set;}
    public static String MetaDataType {get; set;}		
    public static List<SelectOption> MetaDataItems {get; set;}
    public static String MetaDataFolder {get; set;} 
    public static String MetaDataItem {get; set;}	
    public  static String MetadataFileName {get; set;}
    public static String MetadataFileData {get; set;}
    public static MetadataService.AsyncResult AsyncResult {get; private set;}
    public static String MetaDataRetrieveZip { get; private set; }	
    public static string zipvalue{get; private set;}
    public static List<MetadataFile> MetadataFiles { get; set; }	
    public static String zipAttachmentId {get; private set;}
    public MetadataService.AsyncResult result{get; private set;}
    
    
    @AuraEnabled
    public  static string getSourceOrg(String sourceOrg){
        selectedValue = sourceOrg;
        System.debug('selectorg  '+selectedValue);
        return selectedValue;
    }
    @AuraEnabled
    public static string retrieveSelectedPackage(String packagevalueJson){
        System.debug('packagevalueJson'+packagevalueJson);
        List<packageJson> lstOfTypeAndItem = (List<packageJson>)JSON.deserialize(packagevalueJson,List<packageJson>.class);
        system.debug('lstOfTypeAndItem'+lstOfTypeAndItem);
        try{
            MetadataService.AsyncResult asynObj = retrieveMetadataItem(lstOfTypeAndItem); 
            return asynObj.Id;
        }catch(CalloutException e){
            return e.getMessage();
        }
        
    }
    public SelectOption[] getselectValues() {     
        SelectOption[] options = new SelectOption[]{};
            for(OrgAuthorizationInfo__c oneRelationship : [Select  Id, org_name__c FROM OrgAuthorizationInfo__c where Authorised__c =:true]) {
                options.add(new SelectOption(
                    String.valueOf(oneRelationship.Id),oneRelationship.org_name__c));                 
            } 
        return options;           
    } 
    @AuraEnabled
    public static List<string> add_Map(String  Metadata_type){
        
        System.debug('add_Map%%%%%%%%%%%%%%%%%%%%$$$$$$$$$$$$$$$$$$$$$$');
        List<string>  meta_members= new List<String>();
        meta_members=listMetadataItems(Metadata_type);
        //   List<string> meta_members_previous= metadata_all.get(Metadata_type);
        //  meta_members_previous=meta_members;
        //  System.debug('metadata_all@@@'+metadata_all);
        return meta_members;
    }
    
    @AuraEnabled
    public static Map<string,List<string>> init()
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
        System.debug('metadataTypeNames@@ ' +metadataTypeNames);        
        // Sort Metadata Types
        metadataTypeNames.sort();
        MetaDataTypes = new List<SelectOption>();
        // Map<String,List<String>>  metadata_all=new  Map<String,List<String>>();
        
        for(String metadataTypeName : metadataTypeNames)
            MetaDataTypes.add(new SelectOption(metadataTypeName, metadataTypeName));
        // Default to first Metadata Type returned	
        MetaDataType = MetaDataTypes[0].getValue();				
        
        //   Map<String,List<String>>  metadata_all=new  Map<String,List<String>>();
        
        //   List<string> meta_members = new List<string>{'test'};
        //     meta_members=listMetadataItems(metadata_TypeName);
        //  if(meta_members!=null&&meta_members.size()>0){
        // metadata_all.put('metadata_TypeNamw', meta_members);
        for(String metadata_TypeName : metadataTypeNames)
        {
            List<String> meta_members =new List<String>();
            metadata_all.put(metadata_TypeName,meta_members);
            
        }
        system.debug('metadata_all'+metadata_all);
        
        //System.debug('listMetadataItems@@@@@@@@@@###########'+listMetadataItems('ApexClass'));
        
        return metadata_all;
        
    }
    @AuraEnabled
    public static List<OrgAuthorizationInfo__c> getOrgList() {
        return [Select Id, UserEmail__c, org_name__c, name, Authorised__c FROM OrgAuthorizationInfo__c where Authorised__c =:true];
    }
    @AuraEnabled
    public static List<String> listMetadataItems(String MetaData_Type)
    {
        System.debug('MetaDataItems@@@@@@ listMetadataItems');
        
        // List Metadata items for the selected Metadata Type
        MetaDataItems = new List<SelectOption>();	
        System.debug('MetaDataItems@@@@@@ '+MetaDataItems);
        
        MetadataService.MetadataPort service = createService();
        System.debug('service@@@@@@ '+service);
        
        List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();	
        System.debug('queries@@@@@@ '+queries);
        
        MetadataService.ListMetadataQuery queryLayout = new MetadataService.ListMetadataQuery();
        System.debug('queryLayout@@@@@@ '+queryLayout);
        
        if(MetaDataFolder!=null && MetaDataFolder.length()>0)
            queryLayout.folder = MetaData_Type;
        queryLayout.type_x = MetaData_Type;
        System.debug('queryLayout.type_x@@@@@@ '+queryLayout.type_x);
        
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
        System.debug('fullNames@@@@@@ '+fullNames);
        return fullNames;
    }
    @AuraEnabled
    public static MetadataService.AsyncResult retrieveMetadataItem(List<packageJson> packageFile)
    {		
        // Construct unmanaged package with list of desired components to retrieve in zip
        MetadataService.MetadataPort service = createService();	
        MetadataService.RetrieveRequest retrieveRequest = new MetadataService.RetrieveRequest();
        retrieveRequest.apiVersion = METADATA_API_VERSION;
        retrieveRequest.packageNames = null;
        retrieveRequest.singlePackage = true;
        retrieveRequest.specificFiles = null;
        retrieveRequest.unpackaged = new MetadataService.Package_x();
        retrieveRequest.unpackaged.types = new List<MetadataService.PackageTypeMembers>();
        for(packageJson packageReq : packageFile){
            MetadataService.PackageTypeMembers packageType = new MetadataService.PackageTypeMembers();
            packageType.name = packageReq.key; 
            packageType.members = packageReq.value;
            retrieveRequest.unpackaged.types.add(packageType);
        }
        return service.retrieve(retrieveRequest);
    }
    @AuraEnabled
    public static string deploySelectedPackage(String zipFile,String testlevel,String allTestClass){
        try{
            system.debug('zipFile'+zipFile);
            MetadataService.AsyncResult result = MetadataDeployController.deployZip(zipFile,testlevel,allTestClass);
            system.debug('id'+result.Id);
            system.debug('AsyncResultdone'+result.done);
            system.debug('AsyncResultmessage'+result.message);
            system.debug('AsyncResultmessage'+result.message);
            system.debug('AsyncResultstate'+result.state);
            system.debug('AsyncResultstatusCode'+result.statusCode);          
            return result.Id;
        }catch(CalloutException e){
            return e.getMessage();
        }
    }
    @AuraEnabled
    public static string checkdeploymentresult(String resId){
        try{
            String response = MetadataDeployController.checkAsyncRequest(resId);
            system.debug('responsemf'+response);
            return response;
        }catch(CalloutException e){
            return e.getMessage();
        }
    }
    @AuraEnabled
    public static string checkAsyncRequest(String requestId)
    {
        // Check the status of the retrieve request
        String response = '';
        try{
            MetadataService.MetadataPort service = createService();
            MetadataService.RetrieveResult retrieveResult = service.checkRetrieveStatus(requestId, true);
            if(retrieveResult.done)
            {
                if(retrieveResult.status != 'Succeeded')
                {
                    response = 'error';
                }
                else
                {
                    response = retrieveResult.zipFile;
                }
            }
            return response;
        }catch(CalloutException e){
            return e.getMessage();
        }
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
        
        // System.debug('@@@@@selectedValue' + selectedValue);
        System.debug('@@@@@selectedOrg' + selectedOrg);
        if(selectedValue !=null){
            selectedOrg = selectedValue;
        }
        else{
            selectedOrg = [select name ,SourceOrg__c from OrgTempData__c].SourceOrg__c;
        }
        selectedValueDestination=[select name ,DestinationOrg__c from OrgTempData__c].DestinationOrg__c;
        String RecordId = selectedOrg;
        OrgAuthorizationInfo__c OrgInfo = [select id,AccessToken__c,RefreshToken__c,instance_url__c	 from OrgAuthorizationInfo__c where id=:RecordId limit 1];
        System.debug('@@@@@OrgInfo'+OrgInfo);
        string accessToken = RefrshAccessToken.RefreshAccessToken(OrgInfo.RefreshToken__c);
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        //   service.SessionHeader.sessionId ='00D0o000001QQ6e!ARQAQB89RMV7nOY5pLGJo1VB26Rt_CUeioSSDCPiMaezKzf836r5VEWFMqoUu_LjYh_CJEB2DCTDfSM_9u52UOIzwfZcfUJB';
        //  service.SessionHeader.sessionId = UserInfo.getSessionId();
        service.SessionHeader.sessionId = accessToken;
        service.endpoint_x = OrgInfo.instance_url__c+'/services/Soap/m/42.0';
        System.debug('@@@@@ service.SessionHeader.sessionId'+ service.SessionHeader.sessionId);
        System.debug('@@@@@service.endpoint_x'+service.endpoint_x);
        // service.endpoint_x = 'https://krish25-dev-ed.my.salesforce.com/services/Soap/m/42.0';
        return service;		
    }	
    
    public static PageReference downloadMetadataZipFile()
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
            return null  ;
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
    
    @AuraEnabled
    public static string  getInsertCustomSetdata(string selectedOrg) {
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
    @AuraEnabled
    public  static void  getInsertCustomSetdataDestination(String Dest_Org) {
        string returnMsg ='';
        //fetches or creates a Custom Setting at the organization level 
        try{
            // insert select source org value in custom setting for tem basis 
            OrgTempData__c setting = OrgTempData__c.getOrgDefaults();
            setting.DestinationOrg__c = Dest_Org;
            upsert setting;
            returnMsg ='Success';
        }
        catch(exception e){
            returnMsg ='Error';
        }
        //   return returnMsg;
    }
    @AuraEnabled
    public static String downloadZipFile(){
        system.debug('downloading....');
        return null;
    }
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
    public class packageJson{
        public string key;
        public List<string> value;
    }
}