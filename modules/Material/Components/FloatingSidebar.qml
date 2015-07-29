import QtQuick 2.3
import Material 0.1
import Material.ListItems 0.1 as ListItem

/*!
    \qmltype FloatingSidebar
    \brief A sidebar component for use in adaptive layouts

    To use, simply add an instance to your code, and anchor other components to it.

    To show or hide, set the expanded property.
    On mobile devices sidebar becomes floating.
    It means that menu will be hidden by default and can be expanded by gestures from screen sides.

    Examples:
    \qml
        MouseArea {
            onClicked: fbar.expanded = true;
        }

        FloatingSidebar {
            id: fbar

            // Anchoring is not automatic
        }
    \endqml
*/
PopupBase {
    id: menuOverlay

    overlayLayer: "dialogOverlayLayer"

    property bool floating: Device.isMobile !== undefined ? Device.isMobile : false
    property bool expanded: Device.isMobile !== undefined ? !Device.isMobile : true
    property Action backAction: action

    property alias menuWidth: __menuContent.width
    property alias menuBackground: __menuContent.backgroundColor

    default property alias contents: __menuContent.data

    overlayColor: Qt.rgba(0, 0.1, 0.2, 0.6)

    visible: opacity > 0

    anchors {
        top: parent.top
        bottom: parent.bottom
        left: parent.left
        right: parent.right
    }

    Keys.onEscapePressed: expanded = false

    Action {
        id: action
        iconName: "navigation/menu"
        name: "Floating Sidebar"
        visible: floating
        onTriggered: expanded = true
    }

    Item {
        id: menuContainer

        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }

        width: childrenRect.width

        Translate {
            id: menuTranslate;
        }
        transform: menuTranslate

        states: [
            State {
                when: expanded
                name: "show"
                PropertyChanges { target: menuTranslate; x: 0 }
                PropertyChanges { target: pageStack; anchors.leftMargin: floating ? 0 : __menuContent.width + menuTranslate.x }
            },
            State {
                when: !expanded
                name: "hide"
                PropertyChanges { target: menuTranslate; x: -__menuContent.width }
            }
        ]

        transitions: [
            Transition {
                from: "show"
                to: "hide"
                NumberAnimation { properties: "x,anchors.leftMargin"; easing.type: Easing.OutQuad; duration: 300 }
            },
            Transition {
                from: "hide"
                to: "show"
                NumberAnimation { properties: "x,anchors.leftMargin"; easing.type: Easing.OutQuad; duration: 300 }
            }
        ]

        View {
            id: __menuContent

            elevation: floating ? 4 : 1
            width: Units.dp(250)
            clip: true

            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
                rightMargin: Units.dp(1)
            }
        }
    }
    onFloatingChanged: {
        if(!floating) {
            expanded = true;
        }
    }

    states: [
        State {
            when: !floating
            name: "overlayOff"
            ParentChange { target: menuContainer; parent: pageStack.parent }
            AnchorChanges { target: menuContainer; anchors.top: pageStack.top }
        },
        State {
            when: floating && expanded
            name: "overlayOn"
            ParentChange { target: menuContainer; parent: menuOverlay }
        }
    ]

    transitions: [
        Transition {
            from: "*"
            to: "overlayOn"
            ScriptAction { script: open() }
        },
        Transition {
            from: "overlayOn"
            to: "*"
            SequentialAnimation {
                ScriptAction { script: close() }
                ParentAnimation {}
               // AnchorAnimation { }
            }
        }
    ]

    //Apply state change if overlay closed by click
    onClosed: {
        if (state !== "overlayOff") {
            state = "overlayOff";
            expanded = false;
        }
    }
}
