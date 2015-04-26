import QtQuick 2.2
import Material 0.1
import Material.Components 0.1 as Mgui

ApplicationWindow {
    id: demo

    theme {
        accentColor: "#009688"
    }
    Mgui.BlindView {
        flat: true
        iconColor: "black"
        anchors.centerIn: parent
        upperItem: Rectangle {anchors.fill: parent; color:"red"}
        lowerItem: Rectangle {anchors.fill: parent; color:"green"}
    }

}
