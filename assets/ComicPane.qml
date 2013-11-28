import bb.cascades 1.2

Container {
    function onLoadStarted() {
        progressbar.setValue(0);
        setLoadingVisibility(true);
    }
    function onLoadCompleted(comic_id, comic_title, comic_alt, comic_img) {
        scrollView.content = null;
        scrollView.content = img;
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
    Container {
        layout: StackLayout {
        }
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        Container {
            layoutProperties: StackLayoutProperties {
                spaceQuota: 0.75
            }

            attachedObjects: [
                LayoutUpdateHandler {
                    id: layoutUpdateHandler
                    onLayoutFrameChanged: {
                        img.preferredWidth = layoutFrame.width;
                        img.preferredHeight = layoutFrame.height;
                    }
                }
            ]

			horizontalAlignment: HorizontalAlignment.Fill
			verticalAlignment: VerticalAlignment.Fill

            ScrollView {
		        id: scrollView

				horizontalAlignment: HorizontalAlignment.Center
				verticalAlignment: VerticalAlignment.Top

				scrollViewProperties.scrollMode: ScrollMode.Both
				scrollViewProperties.pinchToZoomEnabled: true

				attachedObjects: [
					ImageView {
					    id: img
					    visible: false
					    scalingMethod: ScalingMethod.AspectFit
					}
				]
			}
		}
	    Label {
            layoutProperties: StackLayoutProperties {
                spaceQuota: 0.25
            }
	        id: alt
	        visible: false
	        horizontalAlignment: HorizontalAlignment.Center
	        multiline: true
	        textStyle.fontStyle: FontStyle.Italic
	        textStyle.fontSize: FontSize.Small
	    }
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
