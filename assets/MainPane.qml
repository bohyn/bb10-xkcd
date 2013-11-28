import bb.cascades 1.2


Container {
    function init(_provider) {
        _provider.loadStarted.connect(comicPane.onLoadStarted);
        _provider.loadCompleted.connect(comicPane.onLoadCompleted);
        _provider.loadError.connect(comicPane.onLoadError);
        _provider.loadProgress.connect(comicPane.onLoadProgress);
        
        _provider.loadLast();
    }

    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }
    horizontalAlignment: HorizontalAlignment.Fill
    background: Color.White
    
    Label {
        id: appLabel
        text: "xkcd"
        textStyle.base: SystemDefaults.TextStyles.BigText
        horizontalAlignment: HorizontalAlignment.Center
        bottomMargin: 0
    }
    
    ComicPane {
        id: comicPane
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }
    }
}
