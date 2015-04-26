import QtQuick 2.3
import Material 0.1

View {
    id: __blindView
    width: units.dp(300)
    height: units.dp(250)
    elevation: flat ? 0 : 1

    property bool flat: false
    property bool blindOpen: true
    property Item upperItem: undefined
    property Item lowerItem: undefined
    property alias iconColor: __expandButton.color // black/white

    border.color: flat ? Qt.rgba(0,0,0,0.2) : "transparent"
    radius: fullWidth || fullHeight ? 0 : units.dp(2)

    Item {
        id: __lowerArea
        anchors.fill: parent
    }

    Flickable {
        id: __blindArea

        anchors.fill: parent
        contentWidth: __blind.width
        contentHeight: __blind.height*2
        visible: blindOpen

        boundsBehavior: Flickable.StopAtBounds

        Behavior on contentY { NumberAnimation { duration: 300; easing.type: Easing.InOutQuad } }

        onMovementEnded: {
            var _state = (contentY > (height * 0.6) && blindOpen);
            __hideBlind(_state);
        }

        Item {
            id: __blind
            width: __blindView.width
            height: __blindView.height
            opacity: 1 - (__blindArea.contentY / height)
        }
    }

    IconButton {
        id: __expandButton
        anchors {
            top: parent.top
            right: parent.right
            margins: units.dp(8)
        }

        height: units.dp(32)
        width: height
        visible: !blindOpen
        name: "navigation/expand_more"
        onClicked: __hideBlind( false )
    }

    onUpperItemChanged: upperItem.parent = __blind
    onLowerItemChanged: lowerItem.parent = __lowerArea


    function __hideBlind(_state) {
        if (_state === true) {
            blindOpen = false;
        } else {
            __blindArea.contentY = 0;
            blindOpen = true;
        }
    }
}
