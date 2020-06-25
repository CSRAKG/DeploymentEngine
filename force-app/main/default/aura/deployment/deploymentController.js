({
	myAction : function(component, event, helper) {
		
	},
    retrieve : function(component, event, helper) {
        connsole.log('retrieve@@@');
        var asyncId;
        var isIncludeZip = true;
        
        var action = component.get("c.retrieve_x");
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            console.log("exception"); 
            console.log(event); 
            if (state === "SUCCESS") {
                //  helper.showSuccess(component, event, helper,'The Org has been removed successfully');
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    downloadzip : function(component, event, helper) {
		 var rawdata = document.getElementById("zipvalue").value;
            var covertedfile = btoa(rawdata);
            console.log('covertedfile'+covertedfile),
            console.log('rawdata'+rawdata);
            var fileName = 'example.zip';
            var zipfile = new JSZip();
            zipfile.file("package.xml", covertedfile);
            var content = zipfile.generateAsync({type:"blob"})
             .then(function(content){
             saveAs(content, fileName);
             });
	}
    
})