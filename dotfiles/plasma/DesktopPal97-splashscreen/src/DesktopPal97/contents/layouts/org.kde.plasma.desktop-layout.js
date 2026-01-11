var panel = new Panel
var panelScreen = panel.screen

panel.location = "right"
panel.height = gridUnit * 3.6
panel.width = panelScreen.height

panel.addWidget("org.kde.plasma.kickoff")
panel.addWidget("org.kde.plasma.icontasks")
panel.addWidget("org.kde.plasma.systemtray")
panel.addWidget("org.kde.plasma.digitalclock")

var desktopsArray = desktopsForActivity(currentActivity());
for( var j = 0; j < desktopsArray.length; j++) {
    desktopsArray[j].wallpaperPlugin = 'org.kde.image';
}


