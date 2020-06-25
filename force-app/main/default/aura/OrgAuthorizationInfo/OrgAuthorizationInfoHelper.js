({
	  getOrgList : function(component) {
        var action = component.get("c.getOrgList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.orgList", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    } ,
    showSuccess : function(component, event, helper,msg) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Success',
                message: msg,
                duration:' 5000',
                key: 'info_alt',
                type: 'success',
                mode: 'pester'
            });
            toastEvent.fire();
        },
    showError : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message:'Something went wrong please try again',
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    }
})