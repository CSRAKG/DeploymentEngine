({
	toggle: function (component, event, helper) {
         var sel = component.find("mySelect");
         var nav =	sel.get("v.value");
        console.log('nav',nav);
         if (nav == "1") {     
              component.set("v.toggleEng", true);
         }
        else{
            component.set("v.toggleEng", false);
        }
    }
})