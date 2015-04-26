import QtQuick 2.2
import Material 0.1
import Material.Components 0.1 as MGui

ApplicationWindow {
    id: demo

    theme {
        accentColor: "#009688"
    }

    initialPage: page
    Page {
        id: page
        title: "Test Page"

        actions: [
            Action {
                iconName: "image/color_lens"
                name: "Colors"
            },

            Action {
                iconName: "action/search"
                name: "Search"
            },

            Action {
                iconName: "action/settings"
                name: "Settings"
                onTriggered: sidebar.show()
            }
        ]
        MouseArea {
            anchors.fill: parent
            onPressed: console.log("pressed")
            onReleased: console.log("released")
        }

    }

    MGui.FloatingSidebar {
        id: sidebar

//        mode: "right" //default is "left"

        Column{
            width: parent.width
            height: childrenRect.height
            spacing: units.dp(3)
            Rectangle{
                color: "gray"
                anchors {left: parent.left; right: parent.right}
                height: units.dp(300)
                MouseArea {
                    anchors.fill: parent
                    onPressed: console.log("pressed")
                    onReleased: console.log("released")
                    onPositionChanged: console.log(mouse.x,mouse.y)
                }
            }
            Rectangle{
                color: "green"
                anchors {left: parent.left; right: parent.right}
                height: units.dp(400)
            }
            Rectangle{
                color: "yellow"
                anchors {left: parent.left; right: parent.right}
                height: units.dp(400)
            }
        }
    }
}
