import QtQuick 2.2
import Material 0.1
import Material.Components 0.1 as MGui

MGui.MainWindow {
    id: demo

    leftSidebarContent:
        Rectangle {
            width: units.dp(1200)
            height : width
            color: "green"
            MouseArea {
                anchors.fill: parent
                onClicked: rightSidebar.expanded = !rightSidebar.expanded
            }
        }

}
