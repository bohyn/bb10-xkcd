function createActions(page, nav_action_def, _provider) {
	var first_action = nav_action_def.createObject().init(qsTr("First"), "ic_first.png");
	var previous_action = nav_action_def.createObject().init(qsTr("Previous"), "ic_previous.png");
	var random_action = nav_action_def.createObject().init(qsTr("Random"), "ic_random.png");
	var next_action = nav_action_def.createObject().init(qsTr("Next"), "ic_next.png");
	var last_action = nav_action_def.createObject().init(qsTr("Last"), "ic_last.png");

	first_action.triggered.connect(_provider.loadFirst);
	previous_action.triggered.connect(_provider.loadPrevious);
	random_action.triggered.connect(_provider.loadRandom);
	next_action.triggered.connect(_provider.loadNext);
	last_action.triggered.connect(_provider.loadLast);

	page.addAction(first_action, ActionBarPlacement.InOverflow);
	page.addAction(previous_action, ActionBarPlacement.OnBar);
	page.addAction(random_action, ActionBarPlacement.OnBar);
	page.addAction(next_action, ActionBarPlacement.OnBar);
	page.addAction(last_action, ActionBarPlacement.InOverflow);
}
