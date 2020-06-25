({
    doInit: function(component, event, helper) {
        // Set isModalOpen attribute to true
        var selectedorg = component.get('v.selectedOrg');
        helper.getOrgList(component);
    },
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    },
     onLoad : function(component, event, helper) {
         component.set("v.isModalOpen", false);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Loaded!",
            "message": "The record has been Loaded successfully ."
        });
        toastEvent.fire();
    },
    
    submitDetails: function(component, event, helper) {
        // Set isModalOpen attribute to false
        //Add your code to call apex method or do some processing
        component.set("v.isModalOpen", false);
    },
     onSuccess : function(component, event, helper) {
         helper.showSuccess(component, event, helper,'The Org has been added successfully');
         $A.get('e.force:refreshView').fire();
    },
    deleteRecord: function(component,event,helper){
        var div = event.currentTarget;
        var recordid = div.getAttribute('data-recordid');
        
        var action = component.get("c.deleteOrg");
        action.setParams({OrgId:recordid});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                 helper.showSuccess(component, event, helper,'The Org has been removed successfully');
                component.set("v.orgList", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
            component.set("v.orgList",response.getReturnValue());
        });
        $A.enqueueAction(action);

    }, 
    handleOrgAuthorization : function(component, event, helper) {
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Info',
            message: 'Proceeding..',
            duration:' 5000',
            key: 'info_alt',
            type: 'info',
            mode: 'dismissible'
        });
        toastEvent.fire();
        var div = event.currentTarget;
        var dataorg = div.getAttribute('data-org');
       component.set('v.selectedOrg',dataorg);
        var action2 = component.get("c.InsertCustomSetdata");
        action2.setParams({orgId:dataorg});
        action2.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res =  response.getReturnValue();
               $A.enqueueAction(action);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action2);
        
        var action = component.get("c.ReturnAccessToken");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res =  response.getReturnValue();
                console.log('response is @@@',res);
                // component.set("v.userList", response.getReturnValue());
                window.open(res);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
      //  $A.enqueueAction(action);
    },
       handleSubmit :function(component,event,helper){
          $A.get('e.force:refreshView').fire();
    },
    onError :function(component,event,helper){
        helper.showError(component, event, helper)
        $A.get('e.force:refreshView').fire();
    }
    
})