({
    doSave: function(component, event, helper) {
        if (component.get("v.fileName") !== 'No File Selected..'){
            component.set('v.message','Deploying..');
            helper.uploadHelper(component, event);
        } else {
            alert('Please Select a Valid File');
        }
    },
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },
})