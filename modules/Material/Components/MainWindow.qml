import QtQuick 2.2
import QtQuick.Window 2.0
import Material 0.1
import Material.Components 0.1 as MGui

ApplicationWindow {
    id: mainWindow

    width: 1280
    height: 720
    minimumHeight: units.dp(500)
    minimumWidth: (_sidebar.menuWidth + _sidebar_right.menuWidth) + units.dp(150)

    visible: true

    Component.onCompleted: {
        x = Screen.width / 2 - width / 2;
        y = Screen.height / 2 - height / 2;
    }

    theme {
        accentColor: "#009688"
    }

    property alias leftSidebar: _sidebar
    property alias leftSidebarContent: _sidebar.contents
    property alias rightSidebar: _sidebar_right
    property alias rightSidebarContent: _sidebar_right.contents
    default property alias contents: page.data

    signal settings()

    initialPage: page
    Page {
        id: page
        title: "Test Page"

        actions: [
            Action {
                iconName: "image/color_lens"
                name: "Colors"
                onTriggered: themeChanger.open()
            },

            Action {
                iconName: "action/search"
                name: "Search"
            },

            Action {
                iconName: "action/settings"
                name: "Settings"
                onTriggered: settings()
            }
        ]

    }

    MGui.FloatingSidebar {
        id: _sidebar
        menuWidth: Device.isMobile ? units.dp(250) : units.dp(300)
    }

    MGui.FloatingSidebar {
        id: _sidebar_right
        mode: "right" //default is "left"
        expanded: false
        menuWidth: Device.isMobile ? units.dp(300) : units.dp(400)
    }

    ThemeChanger { id: themeChanger }
    Snackbar { id: snackbar }

    function notify (text) {
      snackbar.open(text);
    }
}
