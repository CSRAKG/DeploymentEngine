({
	handleClick : function(component, event, helper) {
        
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
        
		 var action = component.get("c.ReturnAccessToken");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               var res =  response.getReturnValue();
               // component.set("v.userList", response.getReturnValue());
               window.open(res);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
	},
    
    openActionWindow : function(component, event, helper) {
        //component.set('v.PreviewDeploymentSection',true);
        //component.set('v.openDeploymentSection',false);
		 window.open("https://devoppsapp-dev-ed--c.visualforce.com/apex/deployment?core.apexpages.request.devconsole=1","_self");
	},
    handleClose : function(component,event,helper){
                component.set('v.PreviewDeploymentSection',false);
    },
    openDeploymentSection: function(component,event,helper){
        component.set('v.PreviewDeploymentSection',false);
        component.set('v.openDeploymentSection',true);
    }
})