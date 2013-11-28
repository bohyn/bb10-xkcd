import bb.cascades 1.2
import bb.system 1.2

ActionItem {
	title: qsTr("Add to bookmarks")
	imageSource: "asset:///images/ic_add_bookmark.png"
	enabled: false
	
	function init(_provider) {
        _provider.loadCompleted.connect(function() {
            enabled = true
        });
	    triggered.connect(_provider.addToBookmarks);
	    _provider.addedToBookmarks.connect(function(comic_id, comic_title) {
	        addedMessage.body = "\"" + comic_id + ": " + comic_title + "\" added to bookmarks";
	        addedMessage.show();
	    });
	}
	
	attachedObjects: [
	    SystemToast {
        	id: addedMessage
        }
	]
}
