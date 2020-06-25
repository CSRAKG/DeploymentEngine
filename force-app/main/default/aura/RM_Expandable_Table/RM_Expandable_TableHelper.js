({
	fetchTypePicklist : function(component){
        var action = component.get("c.init");
       
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                component.set("v.MetadataHeader", a.getReturnValue());
            } 
        });
        $A.enqueueAction(action);
    },
})