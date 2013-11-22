import bb.cascades 1.2

Container {
    function init(_provider) {
        _provider.loadStarted.connect(comicPane.onLoadStarted);
        _provider.loadCompleted.connect(comicPane.onLoadCompleted);
        _provider.loadError.connect(comicPane.onLoadError);
        _provider.loadProgress.connect(comicPane.onLoadProgress);
        
        navControls.loadFirst.connect(_provider.loadFirst);
        navControls.loadPrevious.connect(_provider.loadPrevious);
        navControls.loadRandom.connect(_provider.loadRandom);
        navControls.loadNext.connect(_provider.loadNext);
        navControls.loadLast.connect(_provider.loadLast);

        _provider.loadLast();
    }

    leftPadding: 20.0
    rightPadding: 20.0
    topPadding: 20.0
    bottomPadding: 20.0
    
    background: Color.create("#ff96a8c8")
    
    Container {
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
        }
        
        ComicPane {
            id: comicPane
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
        }
    }
    NavigationControls {
        id: navControls
    }
}
