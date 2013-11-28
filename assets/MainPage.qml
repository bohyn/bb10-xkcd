import bb.cascades 1.2
import "navigation.js" as Navigation
import "actions"

XkcdPage {
    id: mainPage
    actions: [
        ShareActionItem {
            id: shareAction
        },
        GotoActionItem {
            id: gotoAction
        },
        BookmarkActionItem {
            id: bookmarkAction
        }
    ]

    pane: MainPane {
        id: mainPane
    }
    
    function init(_provider) {
        gotoAction.init(_provider);
        shareAction.init(_provider);
        bookmarkAction.init(_provider);
        mainPane.init(_provider);
        Navigation.createActions(mainPage, navActionDef, _provider);
    }
    
    attachedObjects: [
        ComponentDefinition {
            id: navActionDef
            source: "actions/NavigationActionItem.qml"
        }
    ]
}
