({
    doInit : function(component, event, helper) {
        helper.fetchTypePicklist(component); // fetches PickList Values of Type Field
    },
    retrive : function(component, event, helper) {
        var sourceOrg = component.get('v.SourceOrg');
        var destination = component.get('v.DestinationOrg');
        if(sourceOrg=='No Value' || destination=='No Value'){
            helper.showError(component, event, helper,'Please Select Org')
        }
        else{
            helper.init_Server(component); 
        }
        
    },
    setSourceOrg: function (component, event, helper) {
        //var selPickListValue = event.getSource().get("v.value");
        var selPickListValue=component.find('select').get('v.value');
        console.log('selPickListValue@@@',selPickListValue);
        component.set('v.SourceOrg',selPickListValue);
        
        var action = component.get("c.getInsertCustomSetdata");
        action.setParams({selectedOrg: selPickListValue }); 
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
            } 
        });
        
        $A.enqueueAction(action);  
        
    },
    destinationOrg: function (component, event, helper) {
        //var selPickListValue = event.getSource().get("v.value");
        var selectedDestination=component.find('selectDestination').get('v.value');
        console.log('selPickListValueDestination@@@',selectedDestination);
        component.set('v.DestinationOrg',selectedDestination);
        var action = component.get("c.getInsertCustomSetdataDestination");
        action.setParams({Dest_Org: selectedDestination }); 
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
            } 
        });
        $A.enqueueAction(action);  
    },
    toggleSection : function(component, event, helper) {
        var sectionAuraId = event.target.getAttribute("data-auraId");
        console.log('sectionAuraId@@@',sectionAuraId);
        var selectedMetadata = component.get('v.selectedMetaDataType');
        var metaDataWithMembers = component.get('v.MetadataHeader_alldata');
        var sectionDiv = document.getElementById(sectionAuraId);
        //  var sectionState = sectionDiv.getAttribute('class').search('slds-is-close'); 
        var sectionState = sectionDiv.classList.contains('slds-is-close');
        if(sectionState){
            var action = component.get("c.add_Map");
            action.setParams({Metadata_type: sectionAuraId }); 
            
            helper.serverSideCall(component,action).then(
                function(res) {
                    
                    for(var i=0;i<metaDataWithMembers.length;i++){
                        if(metaDataWithMembers[i].key==sectionAuraId){
                            if(res.length!=0){
                                metaDataWithMembers[i].value=res;
                            }
                            
                            break;
                        }
                    }
                    component.set("v.MetadataHeader_alldata", metaDataWithMembers);
                    component.set('v.selectedMetaDataType',sectionAuraId);
                    
                    
                    helper.hideShowToggle(component,event);
                    
                    
                    console.log(res);
                    //alert(res);
                }
                
            ).catch(
                function(error) {
                    console.log(error);
                }
            )
        }
        else{
            
            
            sectionDiv.setAttribute('class' , 'slds-section slds-is-close');
            sectionDiv.removeAttribute('class' , 'slds-is-open');
            
        }
    },
    // common reusable function for toggle sections
    /* toggleSection : function(component, event, helper) {
        var sectionAuraId = event.target.getAttribute("data-auraId");
        console.log('sectionAuraId@@@',sectionAuraId);
        var selectedMetadata = component.get('v.selectedMetaDataType');
        var metaDataWithMembers = component.get('v.MetadataHeader_alldata');
        
        var action = component.get("c.add_Map");
        action.setParams({Metadata_type: sectionAuraId }); 
        
        action.setCallback(this, function(a) {
            console.log('actionsetCallback');
            var state = a.getState();
            if (state === "SUCCESS"){
                var result = a.getReturnValue();
                var arrayMapKeys = [];
                for(var i=0;i<metaDataWithMembers.length;i++){
                    if(metaDataWithMembers[i].key==sectionAuraId){
                        metaDataWithMembers[i].value=result;
                        break;
                    }
                }
                component.set("v.MetadataHeader_alldata", metaDataWithMembers);
                window.setTimeout(
                    $A.getCallback(function() {
                        
                        helper.hideShowToggle(component,event);
                        component.set('v.selectedMetaDataType',sectionAuraId);
                        
                    }), 4000
                );
                
            } 
        });
        $A.enqueueAction(action);
    },*/
    
    
    
    handleOpenInNewWindow : function(component, event, helper) {
        window.open("https://devoppsapp-dev-ed.lightning.force.com/lightning/n/DevoppsApp","_self");
    },
    onSelectAllChange: function(component, event, helper) {
        
        var capturedCheckboxName = event.getSource().get("v.value");
        var selectedmetadata = component.get('v.selectedMetaDataType');
        console.log('selectedmetadata '+selectedmetadata)
        var MetadataMembersMap = component.get('v.SelectedMetadataMembersMap');
        if(MetadataMembersMap === undefined || MetadataMembersMap.length == 0){
            var metaDataMembers = [];
            metaDataMembers.push(capturedCheckboxName);
            MetadataMembersMap.push({key: selectedmetadata, value: metaDataMembers});
            console.log(JSON.stringify(MetadataMembersMap));
        }
        else{
            const index = MetadataMembersMap.indexOf(selectedmetadata);
            console.log('index@@@@@@@@@@@@',index);
            for(var i=0;i<MetadataMembersMap.length;i++){
                
                if(MetadataMembersMap[i].key==selectedmetadata){
                    
                    if(MetadataMembersMap[i].value.indexOf(capturedCheckboxName)== -1)
                    {
                        MetadataMembersMap[i].value.push(capturedCheckboxName);
                    }
                    else{
                        
                        const index = MetadataMembersMap[i].value.indexOf(capturedCheckboxName);
                        if (index > -1) {
                            MetadataMembersMap[i].value.splice(index, 1);
                        }
                    }
                    console.log('finallist',JSON.stringify(MetadataMembersMap));
                    
                }
                else{
                    var metaDataMembers = [];
                    metaDataMembers.push(capturedCheckboxName);
                    MetadataMembersMap.push({key: selectedmetadata, value: metaDataMembers});
                }
            }
            
        }
        component.set('v.MetadataMembersMap',MetadataMembersMap);
        component.set('v.SelectedMetadataMembersMap',MetadataMembersMap);
        console.log('finallist',component.get('v.SelectedMetadataMembersMap'));
        console.log('MetadataMembersMap',component.get('v.MetadataMembersMap'));
        
        console.log('finallistjson',JSON.stringify(MetadataMembersMap));
        
    },
    createPackage: function(component, event, helper) {
        if(Array.isArray(component.get('v.SelectedMetadataMembersMap')) && component.get('v.SelectedMetadataMembersMap').length){
            helper.showMessage(component,event,'info','Creating package... pls wait!','500','info','pester');
            helper.retrieveRequest(component,event,component.get('v.SelectedMetadataMembersMap'));
        }else{
            helper.showMessage(component,event,'error','Please select metadata items first','1000','error','sticky');
        }
    },
    deployPackage : function(component, event, helper) {
        component.set('v.testRunPopup',false);
        if(component.get('v.packageZipFile') !== ''){
            helper.showMessage(component,event,'info','Deploying package... pls wait!','500','info','pester');
            helper.deployRequest(component, event, component.get('v.packageZipFile'));
        }else{
            helper.showMessage(component,event,'error','Please create package first.','1000','error','sticky');
        }
    },
    zipDownload : function(component, event, helper) {
        if(component.get('v.packageZipFile') != ''){
            helper.downloadZipHelper(component, event,component.get('v.packageZipFile'));
        }
        else{
            helper.showMessage(component,event,'error','Nothing to download.','1000','error','sticky');
        }
    },
    deployModal : function(component, event, helper) {
        component.set('v.testRunPopup',true);
    },
    closeModal : function(component, event, helper) {
        component.set('v.testRunPopup',false);
    },
    toggle: function (component, event, helper) {
        var sel = component.find("mySelect");
        var nav =	sel.get("v.value");
        console.log('nav',nav);
        if (nav == "RunSpecifiedTests") {     
            component.set("v.toggleEng", true);
        }
        else{
            component.set("v.toggleEng", false);
        }
    }
    
})