({
    fetchTypePicklist : function(component){
        var action = component.get("c.getOrgList");
       
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                component.set("v.TypePicklist", a.getReturnValue());
            } 
        });
        $A.enqueueAction(action);
    },    
   
})