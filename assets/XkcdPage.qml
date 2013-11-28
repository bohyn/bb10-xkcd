import bb.cascades 1.2

Page {
	property Container pane
	
	content: Container {
     	controls: [pane]
 
        leftPadding: 20.0
        rightPadding: 20.0
        topPadding: 20.0
        bottomPadding: 20.0
        
        background: Color.create("#ff96a8c8")
    }
}
