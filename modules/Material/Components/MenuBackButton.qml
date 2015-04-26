import QtQuick 2.0
import Material 0.1

Item {
    id: mbButtom
    width: 24
    height: 24

    property Action action
    property bool menu: true
    property int animationDuration: 350

    property color color: "white"
    readonly property real _lineHeight: height / 7
    signal menuClicked()
    signal backClicked()

Column{
    id: _iconLayout
    anchors.fill: parent
    anchors.topMargin: _lineHeight
    anchors.bottomMargin: _lineHeight

    spacing: _lineHeight
    Repeater{
        id: _linesRepeater
        model: 3
        delegate:
            Rectangle {
            property real translateX: 0
            property real translateY: 0
            color: mbButtom.color
            width: mbButtom.width
            height: mbButtom._lineHeight
            antialiasing: true
            transform: Translate{x:translateX;y:translateY}
        }
    }
}

    state: "menu"
    states: [
        State {
            name: "menu"
            when: menu
        },

        State {
            name: "back"
            when: !menu
            PropertyChanges { target: mbButtom; rotation: 180 }
            PropertyChanges { target: _linesRepeater.itemAt(0); rotation: 45; width: ((mbButtom.height / 2)/Math.sin(45)); translateX: (mbButtom.height / 2)-_lineHeight/2; translateY:(mbButtom._lineHeight / 1.41)}
            PropertyChanges { target: _linesRepeater.itemAt(1); translateX: -_lineHeight/2;}
            PropertyChanges { target: _linesRepeater.itemAt(2); rotation: -45; width:((mbButtom.height / 2)/Math.sin(45)); translateX: (mbButtom.height / 2)-_lineHeight/2; translateY:-(mbButtom._lineHeight / 1.41)}
        }
    ]

    transitions: [
        Transition {
            RotationAnimation { target: mbButtom; direction: RotationAnimation.Clockwise; duration: animationDuration; easing.type: Easing.InOutQuad }
            PropertyAnimation { targets: [_linesRepeater.itemAt(0),_linesRepeater.itemAt(1),_linesRepeater.itemAt(2)]; properties: "rotation, width, translateX, translateY"; duration: animationDuration; easing.type: Easing.InOutQuad }
        }
    ]

        Ink {
            id: ink

            anchors.centerIn: parent
            enabled: mbButtom.enabled
            centered: true
            circular: true

            width: parent.width + units.dp(20)
            height: parent.height + units.dp(20)

            z: 0

            onClicked: {
                if (menu) menuClicked()
                else backClicked();

//                menu = !menu
            }
        }

}
