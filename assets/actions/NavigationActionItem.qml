import bb.cascades 1.2

ActionItem {
    id: actionItem
    function init(title, icon) {
        actionItem.title = title;
        actionItem.imageSource = "asset:///images/" + icon;
        return actionItem;
    }
}
