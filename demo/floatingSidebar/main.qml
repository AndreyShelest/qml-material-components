import QtQuick 2.2
import Material 0.1
import Material.Components 0.1 as MGui

ApplicationWindow {
    id: demo

    width: 1280
    height: 720
    visible: true

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
                onTriggered: sidebar.expanded = !sidebar.expanded
            }
        ]

        Column {
            anchors.centerIn: parent

            Checkbox {
                id: expanded_box_left
                text: "Expanded [left]"
                onCheckedChanged: sidebar.expanded = checked
            }
            Checkbox {
                id: floating_box_left
                text: "Floating  [left]"
                onCheckedChanged: sidebar.floating = checked
            }
            Checkbox {
                id: expanded_box_right
                text: "Expanded [right]"
                onCheckedChanged: sidebar_right.expanded = checked
            }
            Checkbox {
                id: floating_box_right
                text: "Floating  [right]"
                onCheckedChanged: sidebar_right.floating = checked
            }
        }

    }

    MGui.FloatingSidebar {
        id: sidebar
        onFloatingChanged: floating_box_left.checked = floating
        onExpandedChanged: expanded_box_left.checked = expanded

        MouseArea {
            anchors {
                left: parent.left;
                right: parent.right
            }
            height: units.dp(1200)
            onPressed: console.log("pressed")
            onReleased: console.log("released")
            onPositionChanged: console.log(mouse.x,mouse.y)
        }
    }

    MGui.FloatingSidebar {
        id: sidebar_right
        onFloatingChanged: floating_box_right.checked = floating
        onExpandedChanged: expanded_box_right.checked = expanded
        mode: "right" //default is "left"

        Rectangle{
            color: "yellow"
            anchors {left: parent.left; right: parent.right}
            height: units.dp(1200)
        }
    }
}