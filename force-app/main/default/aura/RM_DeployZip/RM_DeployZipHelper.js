({  
    uploadHelper: function(component, event) {
        var fileInput = component.find("fileId").get("v.files");
        var file = fileInput[0];
        var self = this;
        var objFileReader = new FileReader();
        // set onload function of FileReader object   
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            console.log('file',fileContents);
            self.deployMeta(component,event,fileContents)
        });
        objFileReader.readAsDataURL(file);
    },
    deployMeta : function(component,event, rawDataValue){
        var action = component.get("c.datavalue");
        var that = this;
        action.setParams({
            rawData: rawDataValue
        });
        // set call back 
        action.setCallback(this, function(response) {
            // store the response / Attachment Id   
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('resultId',response.getReturnValue());
                component.set('v.asynResultId',response.getReturnValue()); 
                if(response.getReturnValue() !== null){
                    var interval = window.setInterval($A.getCallback(function() { 
                        that.statusHelper(component,event);
                        if(component.get('v.message') !== 'Deploying..')
                            window.clearInterval(interval);
                    }), 1000);
                }
            }else{
                component.set('v.message','Some error occured!....Invalid_Session_Id');
                console.log('Error===>');
            }  
        });
        // enqueue the action
        $A.enqueueAction(action);
    },
    statusHelper : function(component,event){
        var action = component.get("c.checkstatus");
        action.setParams({
            asynResId: component.get('v.asynResultId')
        });
        action.setCallback(this, function(response) {
            // store the response / Attachment Id   
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('status',response.getReturnValue());
                component.set('v.message',response.getReturnValue());     
            }else{
                console.log('Error===>');
            }  
        });
        // enqueue the action
        $A.enqueueAction(action);
    },
})