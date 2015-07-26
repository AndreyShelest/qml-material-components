import QtQuick 2.2
import Material 0.1
import Material.Components 0.1 as MGui

ApplicationWindow {
    id: mainWindow

    width: 800
    height: 600
    minimumHeight: Units.dp(500)
    minimumWidth: _sidebar.menuWidth + Units.dp(150)

    visible: true

    theme {
        primaryColor: Palette.colors["blue"]["500"]
        primaryDarkColor: Palette.colors["blue"]["700"]
        accentColor: Palette.colors["teal"]["500"]
        tabHighlightColor: "white"
    }

    property alias leftSidebar: _sidebar
    property alias leftSidebarContent: _sidebar.contents

    signal settings()

    MGui.FloatingSidebar {
        id: _sidebar
        menuBackground: Palette.colors["grey"]["200"]
        floating: width < menuWidth * 2

        //menuWidth: Device.isMobile ? Units.dp(250) : Units.dp(300)
        contents: pageStack.currentItem && pageStack.currentItem.leftMenu ?
                    pageStack.currentItem.leftMenu : null
    }

    Snackbar { id: snackbar }

    function notify (text) {
      snackbar.open(text);
    }
}
