public class ReadMetadata {
  public void retrieveMetadata () {
    // List fullnames of components we want to retrieve
    List<String> componentNameList = 
new List<String>{'ISVNamespace__TestCustomMDType.OrgAuthorizationInfo'};

    // Retrieve components that are records of custom metadata types
    // based on name
    List<Metadata.Metadata> components = Metadata.Operations.retrieve(
Metadata.MetadataType.CustomMetadata, componentNameList);
    Metadata.CustomMetadata customMetadataRecord = (Metadata.CustomMetadata) components.get(0);

    // Check fields of retrieved component
    List<Metadata.CustomMetadataValue> values = customMetadataRecord.values;
    for (integer i = 0; i < values.size(); i++) {
      if (values.get(i).field == 'org_name__c' && 
          values.get(i).value == 'aman') {
        
              System.debug('yes present');
              
              
      }
        else{
            
            
                         System.debug('No present');
 
            
        }
    }
  }
}