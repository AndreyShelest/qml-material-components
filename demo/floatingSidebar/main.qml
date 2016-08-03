import QtQuick 2.2
import Material 0.1
import Material.Components 0.1 as MGui

ApplicationWindow {
    id: demo

    width: 400
    height: 600
    visible: true

    theme {
        primaryColor: Palette.colors["blue"]["500"]
        primaryDarkColor: Palette.colors["blue"]["700"]
        accentColor: Palette.colors["teal"]["500"]
        tabHighlightColor: "white"
    }
    initialPage: page
    Page {
        id: page
        title: "Floating Sidebar test Page"

        Rectangle {
            width: 200
            height: width
            color: 'red'
        }

        Column {
            anchors.centerIn: parent

            CheckBox {
                id: expanded_box_left
                text: "Expanded [left]"
                onCheckedChanged: sidebar.expanded = checked
            }
            CheckBox {
                id: floating_box_left
                text: "Floating  [left]"
                onCheckedChanged: sidebar.floating = checked
            }
            CheckBox {
                id: expanded_box_right
                text: "Expanded [right]"
                onCheckedChanged: sidebar_right.expanded = checked
            }
            CheckBox {
                id: floating_box_right
                text: "Floating  [right]"
                onCheckedChanged: sidebar_right.floating = checked
            }
        }

    }

    MGui.FloatingSidebar {
        id: sidebar
        floating: menuWidth > demo.width / 2
        onFloatingChanged: floating_box_left.checked = floating
        onExpandedChanged: expanded_box_left.checked = expanded

        ListView {
            id: __list
            anchors.fill: parent
            model: 20
            snapMode: ListView.SnapToItem
            delegate: Rectangle {
                color: "#"+((1<<24)*Math.random()|0).toString(16)
                width:__list.width
                height: __list.height / 4
                Text {
                    text: index
                    anchors.centerIn: parent
                }
            }
        }
    }

//    MGui.FloatingSidebar {
//        id: sidebar_right
//        onFloatingChanged: floating_box_right.checked = floating
//        onExpandedChanged: expanded_box_right.checked = expanded
//        mode: "right" //default is "left"

//        Rectangle{
//            color: "yellow"
//            anchors {left: parent.left; right: parent.right}
//            height: Units.dp(1200)
//        }
//    }
}
