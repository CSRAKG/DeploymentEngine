public class CreateMetadata {
 
    public Id doCreate(
        String parentRecDevName,
        String parentRecLabel, 
        String childRecDevName, 
        String childRecLabel) {
 
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
 
        Metadata.CustomMetadata parentRecord = new Metadata.CustomMetadata();
        parentRecord.fullName = 'ParentType.' + parentRecDevName;
        parentRecord.label = parentRecLabel;
        mdContainer.addMetadata(parentRecord);
 
        Metadata.CustomMetadata childRecord = new Metadata.CustomMetadata();
        childRecord.fullName = 'ChildType.' + childRecDevName;
        childRecord.label = childRecLabel;
        Metadata.CustomMetadataValue relValue = new Metadata.CustomMetadataValue();
        relValue.field = 'Parent__c';
        relValue.value = parentRecDevName;
        childRecord.values.add(relValue);
        mdContainer.addMetadata(childRecord);
 
        Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, null);
        return jobId;
    }
 
}