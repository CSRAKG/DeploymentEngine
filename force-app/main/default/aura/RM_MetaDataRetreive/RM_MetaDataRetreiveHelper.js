({
    fetchTypePicklist : function(component){
        var action = component.get("c.getOrgList");
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                var v=a.getReturnValue();
                console.log('v'+v);
                component.set("v.TypePicklist", a.getReturnValue());
            } 
        });
        $A.enqueueAction(action);
    } ,
    serverSideCall : function(component,action) {
        return new Promise(function(resolve, reject) { 
            action.setCallback(this, 
                               function(response) {
                                   var state = response.getState();
                                   if (state === "SUCCESS") {
                                       resolve(response.getReturnValue());
                                   } else {
                                       reject(new Error(response.getError()));
                                   }
                               }); 
            $A.enqueueAction(action);
        });
    },
    init_Server: function (component, event, helper) {
        var action = component.get("c.init");
        action.setCallback(this, function(a) {
            var state = a.getState();
            console.log("return" +a.getReturnValue());
            if (state === "SUCCESS"){
                var result = a.getReturnValue();
                var arrayMapKeys = [];
                for(var key in result){
                    arrayMapKeys.push({key: key, value: result[key]});
                }
                component.set("v.MetadataHeader_alldata", arrayMapKeys);
            }
        });
        $A.enqueueAction(action);    
    },
    hideShowToggle: function(component,event){
        var sectionAuraId = event.target.getAttribute("data-auraId");
        var sectionDiv = document.getElementById(sectionAuraId);
        //  var sectionState = sectionDiv.getAttribute('class').search('slds-is-close'); 
        var sectionState = sectionDiv.classList.contains('slds-is-close');
        console.log('sectionState@@@',sectionState);
        if(sectionState){
            sectionDiv.setAttribute('class','slds-section slds-is-open');
            //  sectionDiv.removeAttribute('class','slds-is-close');
        }
        else{
            sectionDiv.setAttribute('class' , 'slds-section slds-is-close');
            sectionDiv.removeAttribute('class' , 'slds-is-open');
        }
        /*  if(sectionState == -1){
            sectionDiv.setAttribute('class' , 'slds-section slds-is-close');
        }else{
            sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
        }*/
    },
    /*retrievePackage : function (component, event, packageValue) {
        const that = this;
        var action = component.get("c.retrieveSelectedPackage");
        action.setParams({ 'packagevalueJson' : JSON.stringify(packageValue)});
        action.setCallback(this, function(a) {
            var state = a.getState(); 
            if (state === "SUCCESS"){
                console.log('resultRetrieveId'+a.getReturnValue());
                let asynId = a.getReturnValue();
                if(asynId !== '' || asynId !== null || typeof(asynId) !== undefined){
                    //var asynResult = window.setInterval($A.getCallback(function() { 
                    
                    
                    // }), 2000);
                    that.asynReqZipFile(component,event,asynId);
                }
            }else{
                console.log(a.getState());
            }
        }); 
        $A.enqueueAction(action);
    },
    asynReqZipFile : function (component, event, asynId) {
        var action = component.get("c.checkAsyncRequest");
        console.log('var action = component.get("c.checkAsyncRequest");'+component.get("c.checkAsyncRequest"));
        action.setParams({ 'requestId' : asynId});
        action.setCallback(this, function(a) {
            var state = a.getState(); 
            if (state === "SUCCESS"){
                console.log('resultRetrieve@@@@@@'+a.getReturnValue());
                component.set('v.retrieveResult',a.getReturnValue());
                if(component.get('v.retrieveResult') === 'callOutFailed'){
                    that.showMessage(component,event,'error','Webservice callout failed','5000','error','sticky');
                    // window.clearInterval(asynResult); 
                }
                else{
                    if(component.get('v.retrieveResult') === 'error'){
                        that.showMessage(component,event,'error','Failed to create package','5000','error','pester');
                        //  window.clearInterval(asynResult);
                    }else if(component.get('v.retrieveResult') !== ''){
                        alert('Package created successfully');
                        //that.showMessage(component,event,'success','Package created successfully','5000','success','pester');
                        //window.clearInterval(asynResult);
                        // used for zip folder functionality
                        
                        component.set('v.packageZipFile',component.get('v.retrieveResult'));
                    }        
                }
            }else{
                console.log(a.getState());
            }
        }); 
        $A.enqueueAction(action);
    },*/
    /*deployPackage : function (component, event, zipFileVal) {
        const that = this;
        var action = component.get("c.deploySelectedPackage");
        action.setParams({ 'zipFile' : zipFileVal});
        action.setCallback(this, function(a) {
            var state = a.getState(); 
            if (state === "SUCCESS"){
                console.log('resultDeployId'+a.getReturnValue());
                let asynId = a.getReturnValue();
                if(asynId !== '' || asynId !== null || typeof(asynId) !== undefined){
                    //var asynResult = window.setInterval($A.getCallback(function() { 
                    that.asynDeployResult(component,event,asynId);
                    
                    //}), 2000);
                }
            }else{
                console.log(a.getState());
            }
        }); 
        $A.enqueueAction(action);
    },
    asynDeployResult : function (component, event, asynId) {
        var action = component.get("c.checkdeploymentresult");
        action.setParams({ 'resId' : asynId});
        action.setCallback(this, function(a) {
            var state = a.getState(); 
            if (state === "SUCCESS"){
                console.log('resultDeploy',a.getReturnValue());
                component.set('v.deployResult',a.getReturnValue());
                if(component.get('v.deployResult') === 'callOutFailed'){
                    that.showMessage(component,event,'error','Webservice callout failed','5000','error','sticky');
                    //window.clearInterval(asynResult);
                }
                else{
                    console.log('deployStatus',component.get('v.deployResult'));
                    if(component.get('v.deployResult') === 'success'){
                        alert('Successfully deployed');
                        //that.showMessage(component,event,'success','Successfully deployed','5000','success','pester');
                        //window.clearInterval(asynResult);
                    }else if(component.get('v.deployResult') !== '' && component.get('v.deployResult') !== 'success'){
                        alert('Error');
                        //that.showMessage(component,event,'Deployment error:',component.get('v.deployResult'),'10000','error','sticky');
                        //window.clearInterval(asynResult);
                    }
                } 
            }else{
                console.log('checkdeploymentresult'+a.getState());
            }
        }); 
        $A.enqueueAction(action);
    },*/
    showError : function(component, event, helper,msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message:msg,
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    showSuccess : function(component, event) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'This is a success message',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    
    /* Retrieve & Deploy Package -- Modified...*/
    showMessage : function(component, event, title, message, duration, type, mode){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: message,
            duration: duration,
            key: 'info_alt',
            type: type,
            mode: mode
        });
        toastEvent.fire();
    },
    downloadZipHelper : function(component,event, rawData){
        const that = this;
        let covertedfile = atob(rawData);
        let readZip = new JSZip();
        readZip.loadAsync(covertedfile)
        .then(function (readZip) {
            console.log(readZip.files);
            let content = readZip.generateAsync({type:"blob"})
            .then(function(content){
                saveAs(content, 'Package.zip');
                that.showMessage(component,event,'success','Download started...','1000','success','pester');
            });
        }).catch(err => that.showMessage(component,event,'error','Failed to download : ' + err.message,'1000','error','sticky'));
    },
    retrieveRequest : function(component,event,packageValue){
        let counter =  0;
        const self = this;
        var action = component.get("c.retrieveSelectedPackage");
        console.log('packageValue',packageValue);
        action.setParams({ 'packagevalueJson' : JSON.stringify(packageValue)});
        action.setCallback(self, function(a) {
            var state = a.getState();
            if(state === "SUCCESS"){
                console.log('resultRetrieveId:'+a.getReturnValue());
                let asynId = a.getReturnValue();
                if(asynId !== '' || asynId !== null){
                    self.asynPackageRetrieve(component,asynId,counter+1,self);
                }else{
                    self.showMessage(component,event,'error','Retrieve request error.' + err,'1000','error','sticky');
                    console.log('STATE:',state);
                }
            }
        });
        $A.enqueueAction(action);
    },
    asynPackageRetrieve : function(component,asynId,counter,ref){
        console.log('Processing:',counter,'times with asynId:'+asynId);
        let action = component.get("c.checkAsyncRequest");
        ref.retrieveResponse(asynId,action,ref).then(function(result){ 
            console.log('zipValue:',result);
            component.set('v.packageZipFile',result);
            ref.showMessage(component,event,'Retrieve success','Package successfully retrieved.','1000','success','pester');
        }).catch(function(err){
            console.log('error:',err);
            if(err === '') ref.asynPackageRetrieve(component,asynId,counter+1,ref);
            else ref.showMessage(component,event,'Retrieve error','some error occured : ' + err,'1000','error','sticky');
        });
    },
    retrieveResponse : function(asynId,action,ref){
        return new Promise(function(resolve, reject) {
            action.setParams({ 'requestId' : asynId});
            action.setCallback(ref, function(a) {
                var state = a.getState();
                if(state === "SUCCESS"){
                    let res = a.getReturnValue();
                    if(res=='' || res=='error' || res.includes('error'))
                        reject(res);
                    else
                        resolve(res);
                }else{
                    reject('STATE:'+state);
                }
            });
            $A.enqueueAction(action);
        });
    },
    deployRequest : function(component, event, zipFileVal){
        let counter = 0;
        const self = this;
        var sel = component.find("mySelect");
        var selectTestLevel = sel.get("v.value");
        var specifiedTestClass = '';
        if(selectTestLevel == 'RunSpecifiedTests'){
            specifiedTestClass = component.find("specifiedTestClass").get("v.value");
        }
        var action = component.get("c.deploySelectedPackage");
        action.setParams({ 'zipFile' : zipFileVal,'testlevel' : selectTestLevel,'allTestClass' : specifiedTestClass});
        action.setCallback(self, function(a) {
            var state = a.getState(); 
            if (state === "SUCCESS"){
                console.log('resultDeployId:'+a.getReturnValue());
                let asynId = a.getReturnValue();
                if(asynId !== '' || asynId !== null || typeof(asynId) !== undefined){
                    self.asynPackageDeploy(component,asynId,counter,self);
                }
            }else{
                self.showMessage(component,event,'error','Deploy request error.' + err,'1000','error','sticky');
                console.log('STATE:',state);
            }
        }); 
        $A.enqueueAction(action);
    },
    asynPackageDeploy : function(component,asynId,counter,ref){
        console.log('Processing:',counter,'times with asynId:'+asynId);
        var action = component.get("c.checkdeploymentresult");
        ref.deployResponse(asynId,action,ref).then(function(result){ 
            console.log('Deploy result:',result);
            ref.showMessage(component,event,'Deploy success','Package successfully deployed.','1000','success','pester');
        }).catch(function(err){
            console.log('error:',err);
            if(err === '') ref.asynPackageDeploy(component,asynId,counter+1,ref);
            else ref.showMessage(component,event,'Deploy error','some error occured : ' + err,'1000','error','sticky');
        });
    },
    deployResponse: function(asynId,action,ref){
        return new Promise(function(resolve, reject) {
            action.setParams({ 'resId' : asynId});
            action.setCallback(ref, function(a) {
                var state = a.getState(); 
                if (state === "SUCCESS"){
                    let res = a.getReturnValue();
                    if(res === 'success'){
                        resolve(res);
                    }else{
                        reject(res);
                    }
                }else{
                    reject('STATE:'+state);
                }
            }); 
            $A.enqueueAction(action);
        });
    },
})