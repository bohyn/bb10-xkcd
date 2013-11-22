import bb.cascades 1.2

Container {
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }
    topMargin: 20.0
    
    signal loadFirst
    signal loadPrevious
    signal loadRandom
    signal loadNext
    signal loadLast
    
    Button {
        imageSource: "asset:///images/first.png"
        onClicked: {
            loadFirst();
        }
    }
    Button {
        imageSource: "asset:///images/previous.png"
        onClicked: {
            loadPrevious();
        }
    }
    Button {
        imageSource: "asset:///images/random.png"
        onClicked: {
            loadRandom();
        }
    }
    Button {
        imageSource: "asset:///images/next.png"
        onClicked: {
            loadNext();
        }
    }
    Button {
        imageSource: "asset:///images/last.png"
        onClicked: {
            loadLast();
        }
    }
}

