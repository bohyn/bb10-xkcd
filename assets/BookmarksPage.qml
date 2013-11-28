import bb.cascades 1.2
import bb.system 1.2

XkcdPage {
    id: bookmarksPage
    
    signal loadBookmark(int comic_id)
    
    function init(_provider) {
        bookmarksModel.insertList(_provider.getBookmarks());
        function reloadBookmarks() {
            bookmarksModel.clear();
            bookmarksModel.insertList(_provider.getBookmarks());
        }
        _provider.addedToBookmarks.connect(reloadBookmarks);
        _provider.removedFromBookmarks.connect(reloadBookmarks);
        _provider.removedFromBookmarks.connect(function(comic_id, comic_title) {
            removeBokmarkMessage.body = "\"" + comic_id + ": " + comic_title + "\" removed from bookmarks";
            removeBokmarkMessage.show();
        });
        
        loadBookmark.connect(function(comic_id) {
            _provider.load(comic_id);
        });
        
        bookmarksList.removeBookmark.connect(function(comic_id) {
            _provider.removeFromBookmarks(comic_id);
        });
        
        bookmarksList.gotoBookmark.connect(bookmarksPage.loadBookmark);
    }

    pane: Container {
        background: Color.White

        ListView {
            id: bookmarksList
            dataModel: bookmarksModel
            
            signal gotoBookmark(int comic_id);
            signal removeBookmark(int comic_id);
            
            listItemComponents: [
                ListItemComponent {
                    type: "item"
                    StandardListItem {
                        id: listItem
                        title: ListItemData.comic_id + ": " + ListItemData.comic_title
                        contextActions: [
                            ActionSet {
                                ActionItem {
                                    title: qsTr("Go to bookmark")
                                    imageSource: "asset:///images/ic_go_to.png"
                                    onTriggered: {
                                        var view = listItem.ListItem.view;
                                        var indexPath = view.selected();
                                        var selected_item = view.dataModel.data(indexPath);
                                        view.gotoBookmark(selected_item.comic_id);
                                    }
                                }
                                DeleteActionItem {
                                    onTriggered: {
                                        var view = listItem.ListItem.view;
                                        var indexPath = view.selected();
                                        var selected_item = view.dataModel.data(indexPath);
                                        view.removeBookmark(selected_item.comic_id);
                                    }
                                    
                                }
                            }
                        ]
                    }
                }
            ]
            onTriggered: {
                var selected_item = bookmarksModel.data(indexPath)
                var comic_id = selected_item.comic_id;
                bookmarksPage.loadBookmark(comic_id);
            }
        }
    }
    
    attachedObjects: [
        GroupDataModel {
            id: bookmarksModel
            grouping: ItemGrouping.None
        },
        SystemToast {
            id: removeBokmarkMessage
        }
    ]
}
