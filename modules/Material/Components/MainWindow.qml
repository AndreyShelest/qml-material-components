import QtQuick 2.2
import Material 0.1
import Material.Components 0.1 as MGui

ApplicationWindow {
    id: mainWindow

    width: 1280
    height: 720
    minimumHeight: Units.dp(500)
    minimumWidth: (_sidebar.menuWidth + _sidebar_right.menuWidth) + Units.dp(150)

    visible: true

    theme {
        primaryColor: Palette.colors["blue"]["500"]
        primaryDarkColor: Palette.colors["blue"]["700"]
        accentColor: Palette.colors["teal"]["500"]
        tabHighlightColor: "white"
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
        menuWidth: Device.isMobile ? Units.dp(250) : Units.dp(300)
    }

    MGui.FloatingSidebar {
        id: _sidebar_right
        mode: "right" //default is "left"
        expanded: false
        menuWidth: Device.isMobile ? Units.dp(300) : Units.dp(400)
    }

    ThemeChanger { id: themeChanger }
    Snackbar { id: snackbar }

    function notify (text) {
      snackbar.open(text);
    }
}
