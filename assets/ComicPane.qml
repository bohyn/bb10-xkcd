import bb.cascades 1.2

Container {
    function onLoadStarted() {
        progressbar.setValue(0);
        setLoadingVisibility(true);
    }
    function onLoadCompleted(comic_id, comic_title, comic_alt, comic_img) {
        title.text = comic_id + ": " + comic_title;
        img.image = comic_img;
        alt.text = "\"" + comic_alt + "\"";
        setLoadingVisibility(false);
    }
    function onLoadError() {
        setLoadingVisibility(false);
    }
    function onLoadProgress(received, total) {
        if (total != 0) {
            progressbar.setValue(received / total);
        }
    }
	function setLoadingVisibility(is_load_state) {
        title.setVisible(!is_load_state);
        img.setVisible(!is_load_state);
        alt.setVisible(!is_load_state);
        progressbar.setVisible(is_load_state);
	}

    leftPadding: 20.0
    rightPadding: 20.0
    topPadding: 20.0
    bottomPadding: 20.0
    horizontalAlignment: HorizontalAlignment.Fill

    Label {
        id: title
        visible: false
        horizontalAlignment: HorizontalAlignment.Center
    }
    ImageView {
        id: img
        visible: false
        horizontalAlignment: HorizontalAlignment.Center
        scalingMethod: ScalingMethod.AspectFit
    }
    Label {
        id: alt
        visible: false
        horizontalAlignment: HorizontalAlignment.Center
        multiline: true
        textStyle.fontStyle: FontStyle.Italic
        textStyle.fontSize: FontSize.Small
    }
    ProgressIndicator {
        id: progressbar
        fromValue: 0
        toValue: 1
        visible: false
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center
    }
}
