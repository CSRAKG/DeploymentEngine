public class testclass1 {
public PageReference listMetadataItems()
	{
		   Integer METADATA_API_VERSION =  Integer.valueOf(new MetadataService.MetadataPort().endpoint_x.substringAfterLast('/'));
        // List Metadata items for the selected Metadata Type
		List< SelectOption > MetaDataItems = new List<SelectOption>();		
		MetadataService.MetadataPort service = createService();				
		List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();		
		MetadataService.ListMetadataQuery queryLayout = new MetadataService.ListMetadataQuery();
		
		queryLayout.type_x = 'ApexClass';
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
        
        System.debug('MetaDataItems@@@@@@@@@@@'+MetaDataItems);
        System.debug('fullNames@@@@@@@@@@@'+fullNames);
        System.debug('queries@@@@@@@@@@@'+queries);
        System.debug('queryLayout@@@@@@@@@@@'+queryLayout);

		return null;	
	}
      private static MetadataService.MetadataPort createService()
    { 
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        service.endpoint_x = 'your salesforceorg base url'+'/services/Soap/m/42.0';
        return service;		
    }	

}