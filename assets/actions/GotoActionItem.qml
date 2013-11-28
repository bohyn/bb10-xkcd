import bb.cascades 1.2
import bb.system 1.2

ActionItem {
    title: qsTr("Go to")
    imageSource: "asset:///images/ic_go_to.png"
    enabled: false
    onTriggered: {
        gotoPrompt.inputField.emptyText = "[1 ... " + _provider.getMaxId() + "]";
        gotoPrompt.show(); 
    }
    attachedObjects: [
        SystemPrompt {
            id: gotoPrompt
            title: qsTr("Go to specific comic")
            body: qsTr("Enter comic number you want to go to:")
            inputField.inputMode: SystemUiInputMode.NumericKeypad
            
        },
        SystemToast {
            id: invalidInputMessage
            body: qsTr("Please, enter valid comic number.")
        }
    ]
    function init(_provider) {
        _provider.loadCompleted.connect(function() {
            enabled = true
        });
        gotoPrompt.finished.connect(function(result) {
            var gotoId = parseInt(gotoPrompt.inputFieldTextEntry());
            if (isNaN(gotoId)) {
                invalidInputMessage.show();
            } else {
                _provider.load(gotoId);
            }
        });
    }
}
