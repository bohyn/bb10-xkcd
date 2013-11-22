import bb.cascades 1.2

InvokeActionItem {
    title: qsTr("Share")
    query {
        mimeType: "text/plain"
        invokeActionId: "bb.action.SHARE"
    }
    enabled: false

    function init(_provider) {
        _provider.loadCompleted.connect(function() {
            enabled = true
        });
        triggered.connect(function() {
            console.log("ShareActionItem.triggered()");
        	data = "Hi, check out this Xkcd comic: " + _provider.getCurrentUrl();
        	console.log(data);
        });
    }
}
