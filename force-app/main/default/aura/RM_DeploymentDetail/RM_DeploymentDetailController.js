({
	doInit : function(component) {
        
        
        var action = component.get("c.getDeploymentDetailSuccess");
        var action1 = component.get("c.getDeploymentDetailFailure");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.deployDetailListsuccess", response.getReturnValue());
                  var deploylist=component.get("v.deployDetailListsuccess");
                   console.log('deploylist ',deploylist);

                var pagesize=component.get("v.pageSizeSuccess");
             component.set("v.endSuccess",pagesize );
                component.set("v.startSuccess",0 );
                 console.log('pagesize ',pagesize);
            component.set("v.totalSizeSuccess", response.getReturnValue().length);
                 var totalsize=component.get("v.totalSizeSuccess");
                console.log('totalsize ',totalsize);
              var  pagelist=[];
                for(var i=0;i<pagesize;i++){
                    if(i<=(totalsize-1)){
                    pagelist.push(deploylist[i]);
                    }
                    else{
                        break;
                        }
                 }
 component.set("v.paginationListSuccess",pagelist );
                 var page=component.get("v.paginationListSuccess");
                console.log('page ',page);



            }
            else {
                console.log("Failed with state: " + state);
            }
        });
            action1.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.deployDetailListfailure", response.getReturnValue());
                                  var deploylist=component.get("v.deployDetailListfailure");
                   console.log('deploylist ',deploylist);

                var pagesize=component.get("v.pageSizeFailure");
             component.set("v.endFailure",pagesize );
                component.set("v.startFailure",0 );
                 console.log('pagesize ',pagesize);
            component.set("v.totalSizeFailure", response.getReturnValue().length);
                 var totalsize=component.get("v.totalSizeFailure");
                console.log('totalsize ',totalsize);
              var  pagelist=[];
                for(var i=0;i<pagesize;i++){
                    if(i<=(totalsize-1)){
                    pagelist.push(deploylist[i]);
                    }
                    else{
                        break;
                        }
                 }
 component.set("v.paginationListFailure",pagelist );
                 var page=component.get("v.paginationListFailure");
                console.log('page ',page);




            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
        $A.enqueueAction(action1);
    } ,
        viewDetails : function(component, event, helper) {
        
               component.set('v.DeployPopup',true);

        var div = event.currentTarget;
        var dataDeploy = div.getAttribute('data-id');
         console.log("dataDeploy " + dataDeploy);

       component.set('v.selectedRecord',dataDeploy);
        var action2 = component.get("c.getDeploymentDetail");
        action2.setParams({deploymentid:dataDeploy});
        action2.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res =  response.getReturnValue();
               console.log("res " + res);

              component.set('v.deployDetail',res);

             }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action2);
        
        
    },
    closeModal : function(component, event, helper) {
        component.set('v.DeployPopup',false);
    },
    firstSuccess : function(component, event, helper)
{
var deployList = component.get("v.deployDetailListsuccess");
var pageSize = component.get("v.pageSizeSuccess");
var paginationList = [];
for(var i=0; i< pageSize; i++)
{
paginationList.push(deployList[i]);
}
component.set('v.paginationListSuccess', paginationList);
},
lastSuccess : function(component, event, helper)
{
var DetailList = component.get("v.deployDetailListsuccess");
var pageSize = component.get("v.pageSizeSuccess");
var totalSize = component.get("v.totalSizeSuccess");
var paginationList = [];
for(var i=totalSize-pageSize; i< totalSize; i++)
{
paginationList.push(DetailList[i]);
}
component.set('v.paginationListSuccess', paginationList);
},
nextSuccess : function(component, event, helper)
{
var deployList = component.get("v.deployDetailListsuccess");
var end = component.get("v.endSuccess");
var start = component.get("v.startSuccess");
var pageSize = component.get("v.pageSizeSuccess");
var paginationList = [];
var counter = 0;
for(var i=end+1; i<end+pageSize+1; i++)
{
if(deployList.length > end)
{
paginationList.push(deployList[i]);
counter++ ;
}
}
start = start + counter;
end = end + counter;
component.set("v.startSuccess",start);
component.set("v.endSuccess",end);
component.set("v.paginationListSuccess", paginationList);
},
previousSuccess : function(component, event, helper)
{
var deployList = component.get("v.deployDetailListsuccess");
var end = component.get("v.endSuccess");
var start = component.get("v.startSuccess");
var pageSize = component.get("v.pageSizeSuccess");
var paginationList = [];
var counter = 0;
for(var i= start-pageSize; i < start ; i++)
{
if(i > -1)
{
paginationList.push(deployList[i]);
counter++;
}
else {
start++;
}
}
start = start - counter;
end = end - counter;
component.set("v.startSuccess",start);
component.set("v.endSuccess",end);
component.set("v.paginationListSuccess", paginationList);
},
     firstFailure : function(component, event, helper)
{
var deployList = component.get("v.deployDetailListfailure");
var pageSize = component.get("v.pageSizeFailure");
var paginationList = [];
for(var i=0; i< pageSize; i++)
{
paginationList.push(deployList[i]);
}
component.set('v.paginationListFailure', paginationList);
},
lastFailure : function(component, event, helper)
{
var DetailList = component.get("v.deployDetailListfailure");
var pageSize = component.get("v.pageSizeFailure");
var totalSize = component.get("v.totalSizeFailure");
var paginationList = [];
for(var i=totalSize-pageSize; i< totalSize; i++)
{
paginationList.push(DetailList[i]);
}
component.set('v.paginationListFailure', paginationList);
},
nextFailure : function(component, event, helper)
{
var deployList = component.get("v.deployDetailListfailure");
var end = component.get("v.endFailure");
var start = component.get("v.startFailure");
var pageSize = component.get("v.pageSizeFailure");
var paginationList = [];
var counter = 0;
for(var i=end+1; i<end+pageSize+1; i++)
{
if(deployList.length > end)
{
paginationList.push(deployList[i]);
counter++ ;
}
}
start = start + counter;
end = end + counter;
component.set("v.startFailure",start);
component.set("v.endFailure",end);
component.set("v.paginationListFailure", paginationList);
},
previousFailure : function(component, event, helper)
{
var deployList = component.get("v.deployDetailListfailure");
var end = component.get("v.endFailure");
var start = component.get("v.startFailure");
var pageSize = component.get("v.pageSizeFailure");
var paginationList = [];
var counter = 0;
for(var i= start-pageSize; i < start ; i++)
{
if(i > -1)
{
paginationList.push(deployList[i]);
counter++;
}
else {
start++;
}
}
start = start - counter;
end = end - counter;
component.set("v.startFailure",start);
component.set("v.endFailure",end);
component.set("v.paginationListFailure", paginationList);
}

})