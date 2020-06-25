({
	doInit : function(component, event, helper) {
		        helper.fetchTypePicklist(component); // fetches PickList Values of Type Field

	},
        retrieveId: function(component,event,helper){
        var div = event.target.value;
        var recordid = div.getAttribute('data-recordid');
        console.log('@@@@@@@@@@@@@@id  '+recordid);
         action.setParams({OrgId:recordid});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
                        if (state === "SUCCESS"){

            component.set("v.recordId",response.getReturnValue());
                        }
            
        });
        $A.enqueueAction(action);

    },
    onChange: function (cmp, event, helper) {
 var selPickListValue = event.getSource().get("v.value");
        console.log('******selPickListValue :'+selPickListValue );
}

})