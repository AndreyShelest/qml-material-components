import QtQuick 2.2
import Material 0.1
import Material.ListItems 0.1 as ListItem

Page {
    id: page

    property alias leftMenu: menuList
    property alias model: menuList.model

    title: "Demo Page"

    actions: [
        Action {
            iconName: "action/build"
            name: "Preferences"
            hoverAnimation: true
            enabled: false
            //onTriggered: //TODO: push App settings page
        },
        Action {
            iconName: "action/settings"
            name: "Page Settings"
            hoverAnimation: true
            onTriggered: rightSidebar.expanded = !rightSidebar.expanded
        }
    ]
    rightSidebar: Sidebar {
        property alias actionBar: _actionBar
        expanded: false
        ActionBar {
            id: _actionBar
            title: "Page Settings"
            backgroundColor: Qt.darker(theme.primaryColor)

            actions: [
                Action {
                    iconName: "action/info"
                    name: "Info"
                    onTriggered: notify("Info Action")
                },
                Action {
                    iconName: "content/clear"
                    name: "Close page settings"
                    onTriggered: rightSidebar.expanded = false
                }
            ]
        }
    }

    /*Left side menu*/
    ListView {
        id: menuList

        anchors.fill: parent

        highlight: Item {
            Rectangle {
                color: theme.accentColor
                opacity: 0.7
                width: Units.dp(6)
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                    topMargin: Units.dp(10)
                    bottomMargin: Units.dp(10)
                    leftMargin: Units.dp(2)
                }
            }
        }

        clip: true
        highlightFollowsCurrentItem: true
        boundsBehavior: Flickable.StopAtBounds

        model: ["test", "test2", "test3"]
        delegate: ListItem.Standard {

            height: Units.dp(72)
            text: modelData
            valueText: "connected"

            selected: ListView.isCurrentItem
            iconName: "maps/flight"
            interactive: true

            onClicked: ListView.view.currentIndex = index
        }
    }

}
