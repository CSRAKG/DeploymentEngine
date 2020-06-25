public class AsyncMetadataFactory {
    public class deleteMetadataResponse_elementFuture extends System.WebServiceCalloutFuture {
        public MetadataFactory.DeleteResult[] getValue() {
            MetadataFactory.deleteMetadataResponse_element response = (MetadataFactory.deleteMetadataResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }

    public class describeMetadataResponse_elementFuture extends System.WebServiceCalloutFuture {
        public MetadataFactory.DescribeMetadataResult getValue() {
            MetadataFactory.describeMetadataResponse_element response = (MetadataFactory.describeMetadataResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class checkDeployStatusResponse_elementFuture extends System.WebServiceCalloutFuture {
        public MetadataFactory.DeployResult getValue() {
            MetadataFactory.checkDeployStatusResponse_element response = (MetadataFactory.checkDeployStatusResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class checkRetrieveStatusResponse_elementFuture extends System.WebServiceCalloutFuture {
        public MetadataFactory.RetrieveResult getValue() {
            MetadataFactory.checkRetrieveStatusResponse_element response = (MetadataFactory.checkRetrieveStatusResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class retrieveResponse_elementFuture extends System.WebServiceCalloutFuture {
        public MetadataFactory.AsyncResult getValue() {
            MetadataFactory.retrieveResponse_element response = (MetadataFactory.retrieveResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class describeValueTypeResponse_elementFuture extends System.WebServiceCalloutFuture {
        public MetadataFactory.DescribeValueTypeResult getValue() {
            MetadataFactory.describeValueTypeResponse_element response = (MetadataFactory.describeValueTypeResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class deployResponse_elementFuture extends System.WebServiceCalloutFuture {
        public MetadataFactory.AsyncResult getValue() {
            MetadataFactory.deployResponse_element response = (MetadataFactory.deployResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class readMetadataResponse_elementFuture extends System.WebServiceCalloutFuture {
        public MetadataFactory.ReadResult getValue() {
            MetadataFactory.readMetadataResponse_element response = (MetadataFactory.readMetadataResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class listMetadataResponse_elementFuture extends System.WebServiceCalloutFuture {
        public MetadataFactory.FileProperties[] getValue() {
            MetadataFactory.listMetadataResponse_element response = (MetadataFactory.listMetadataResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.result;
        }
    }
    public class AsyncMetadataOutlet {
        public String endpoint_x = 'https://login.salesforce.com/services/Soap/m/38.0';
        public Map<String,String> inputHttpHeaders_x;
        public String clientCertName_x;
        public Integer timeout_x;
        public MetadataFactory.SessionHeader_element SessionHeader;
        public MetadataFactory.DebuggingInfo_element DebuggingInfo;
        public MetadataFactory.DebuggingHeader_element DebuggingHeader;
        public MetadataFactory.CallOptions_element CallOptions;
        public MetadataFactory.AllOrNoneHeader_element AllOrNoneHeader;
        private String SessionHeader_hns = 'SessionHeader=http://soap.sforce.com/2006/04/metadata';
        private String DebuggingInfo_hns = 'DebuggingInfo=http://soap.sforce.com/2006/04/metadata';
        private String DebuggingHeader_hns = 'DebuggingHeader=http://soap.sforce.com/2006/04/metadata';
        private String CallOptions_hns = 'CallOptions=http://soap.sforce.com/2006/04/metadata';
        private String AllOrNoneHeader_hns = 'AllOrNoneHeader=http://soap.sforce.com/2006/04/metadata';
        private String[] ns_map_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata', 'MetadataFactory'};
        public AsyncMetadataFactory.deleteMetadataResponse_elementFuture beginDeleteMetadata(System.Continuation continuation,String type_x,String[] fullNames) {
            MetadataFactory.deleteMetadata_element request_x = new MetadataFactory.deleteMetadata_element();
            request_x.type_x = type_x;
            request_x.fullNames = fullNames;
            return (AsyncMetadataFactory.deleteMetadataResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncMetadataFactory.deleteMetadataResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/2006/04/metadata',
              'deleteMetadata',
              'http://soap.sforce.com/2006/04/metadata',
              'deleteMetadataResponse',
              'MetadataFactory.deleteMetadataResponse_element'}
            );
        }

        public AsyncMetadataFactory.describeMetadataResponse_elementFuture beginDescribeMetadata(System.Continuation continuation,Double asOfVersion) {
            MetadataFactory.describeMetadata_element request_x = new MetadataFactory.describeMetadata_element();
            request_x.asOfVersion = asOfVersion;
            return (AsyncMetadataFactory.describeMetadataResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncMetadataFactory.describeMetadataResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/2006/04/metadata',
              'describeMetadata',
              'http://soap.sforce.com/2006/04/metadata',
              'describeMetadataResponse',
              'MetadataFactory.describeMetadataResponse_element'}
            );
        }
        public AsyncMetadataFactory.checkDeployStatusResponse_elementFuture beginCheckDeployStatus(System.Continuation continuation,String asyncProcessId,Boolean includeDetails) {
            MetadataFactory.checkDeployStatus_element request_x = new MetadataFactory.checkDeployStatus_element();
            request_x.asyncProcessId = asyncProcessId;
            request_x.includeDetails = includeDetails;
            return (AsyncMetadataFactory.checkDeployStatusResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncMetadataFactory.checkDeployStatusResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/2006/04/metadata',
              'checkDeployStatus',
              'http://soap.sforce.com/2006/04/metadata',
              'checkDeployStatusResponse',
              'MetadataFactory.checkDeployStatusResponse_element'}
            );
        }
        public AsyncMetadataFactory.checkRetrieveStatusResponse_elementFuture beginCheckRetrieveStatus(System.Continuation continuation,String asyncProcessId,Boolean includeZip) {
            MetadataFactory.checkRetrieveStatus_element request_x = new MetadataFactory.checkRetrieveStatus_element();
            request_x.asyncProcessId = asyncProcessId;
            request_x.includeZip = includeZip;
            return (AsyncMetadataFactory.checkRetrieveStatusResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncMetadataFactory.checkRetrieveStatusResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/2006/04/metadata',
              'checkRetrieveStatus',
              'http://soap.sforce.com/2006/04/metadata',
              'checkRetrieveStatusResponse',
              'MetadataFactory.checkRetrieveStatusResponse_element'}
            );
        }
        public AsyncMetadataFactory.retrieveResponse_elementFuture beginRetrieve_x(System.Continuation continuation,MetadataFactory.RetrieveRequest retrieveRequest) {
            MetadataFactory.retrieve_element request_x = new MetadataFactory.retrieve_element();
            request_x.retrieveRequest = retrieveRequest;
            return (AsyncMetadataFactory.retrieveResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncMetadataFactory.retrieveResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/2006/04/metadata',
              'retrieve',
              'http://soap.sforce.com/2006/04/metadata',
              'retrieveResponse',
              'MetadataFactory.retrieveResponse_element'}
            );
        }

        public AsyncMetadataFactory.describeValueTypeResponse_elementFuture beginDescribeValueType(System.Continuation continuation,String type_x) {
            MetadataFactory.describeValueType_element request_x = new MetadataFactory.describeValueType_element();
            request_x.type_x = type_x;
            return (AsyncMetadataFactory.describeValueTypeResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncMetadataFactory.describeValueTypeResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/2006/04/metadata',
              'describeValueType',
              'http://soap.sforce.com/2006/04/metadata',
              'describeValueTypeResponse',
              'MetadataFactory.describeValueTypeResponse_element'}
            );
        }

        public AsyncMetadataFactory.deployResponse_elementFuture beginDeploy(System.Continuation continuation,String ZipFile,MetadataFactory.DeployOptions DeployOptions) {
            MetadataFactory.deploy_element request_x = new MetadataFactory.deploy_element();
            request_x.ZipFile = ZipFile;
            request_x.DeployOptions = DeployOptions;
            return (AsyncMetadataFactory.deployResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncMetadataFactory.deployResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/2006/04/metadata',
              'deploy',
              'http://soap.sforce.com/2006/04/metadata',
              'deployResponse',
              'MetadataFactory.deployResponse_element'}
            );
        }
        public AsyncMetadataFactory.readMetadataResponse_elementFuture beginReadMetadata(System.Continuation continuation,String type_x,String[] fullNames) {
            MetadataFactory.readMetadata_element request_x = new MetadataFactory.readMetadata_element();
            request_x.type_x = type_x;
            request_x.fullNames = fullNames;
            return (AsyncMetadataFactory.readMetadataResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncMetadataFactory.readMetadataResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/2006/04/metadata',
              'readMetadata',
              'http://soap.sforce.com/2006/04/metadata',
              'readMetadataResponse',
              'MetadataFactory.readMetadataResponse_element'}
            );
        }
        public AsyncMetadataFactory.listMetadataResponse_elementFuture beginListMetadata(System.Continuation continuation,MetadataFactory.ListMetadataQuery[] queries,Double asOfVersion) {
            MetadataFactory.listMetadata_element request_x = new MetadataFactory.listMetadata_element();
            request_x.queries = queries;
            request_x.asOfVersion = asOfVersion;
            return (AsyncMetadataFactory.listMetadataResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncMetadataFactory.listMetadataResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/2006/04/metadata',
              'listMetadata',
              'http://soap.sforce.com/2006/04/metadata',
              'listMetadataResponse',
              'MetadataFactory.listMetadataResponse_element'}
            );
        }
    }
}