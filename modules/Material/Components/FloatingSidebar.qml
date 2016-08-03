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
    default property alias contents: __menuContent.data

    property alias menuWidth: __menuContent.width
    property alias menuBackground: __menuContent.backgroundColor
    property alias slideInfo: __slideInfo

    QtObject {
        id: __slideInfo
        property real width: Units.dp(50)
        property bool active: false
        property real startX: 0.0
        property real startTranslateX: 0.0
        property real slideX: 0.0
        property real slideTranslateX: Math.min(0, Math.max( startTranslateX, startTranslateX + slideX))

    }

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

    MouseArea {
        id: menuContainer

        propagateComposedEvents: true
        onPressed: {
            /* Slide functionality active only in floating mode*/
            if (!floating)
                mouse.accepted = false;

            var startPos = mapToItem(null, mouse.x, mouse.y)

            /* Save current trnslate without binding */
            var curMenuTranslate = menuTranslate.x;
            __slideInfo.startX = startPos.x;
            __slideInfo.slideX = startPos.x;
            __slideInfo.startTranslateX = curMenuTranslate;
            __slideInfo.active = true;
        }
        onMouseYChanged: {
            var curPos = mapToItem(null, mouse.x, mouse.y);
            __slideInfo.slideX = (curPos.x - __slideInfo.startX);
        }

        onReleased: {
            if (__slideInfo.slideX > (__menuContent.width / 3))
                expanded = true
            else
                expanded = false

             __slideInfo.active = false;
        }

        Rectangle {
            anchors.fill: parent
            color: "red"
            opacity: 0.6
        }

        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }

        width: __menuContent.width + __slideInfo.width

        transform: Translate { id: menuTranslate }

        states: [
            State {
                when: expanded && !__slideInfo.active
                name: "show"
                PropertyChanges { target: menuTranslate; x: 0 }
            },
            State {
                when: !expanded && !__slideInfo.active
                name: "hide"
                PropertyChanges { target: menuTranslate; x: -__menuContent.width }
            },
            State {
                when: __slideInfo.active
                name: "drag"
                PropertyChanges { target: menuTranslate; x: __slideInfo.slideTranslateX }
            }
        ]

        transitions: [
            Transition {
                from: "*"
                to: "hide"
                NumberAnimation { properties: "x,anchors.leftMargin"; easing.type: Easing.OutQuad; duration: 300 }
            },
            Transition {
                from: "*"
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
                rightMargin: __slideInfo.width + Units.dp(1)
            }
            onDataChanged: console.log("Data!!!")
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
            PropertyChanges { target: pageStack; anchors.leftMargin: __menuContent.width + menuTranslate.x }
            AnchorChanges { target: menuContainer; anchors.top: pageStack.top }
        },
        State {
            when: floating && (expanded || __slideInfo.active)
            name: "overlayOn"
            ParentChange { target: menuContainer; parent: menuOverlay }
            PropertyChanges { target: pageStack; anchors.leftMargin: 0 }
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

    /* Apply state change if overlay closed by click */
    onClosed: {
        if (state !== "overlayOff") {
            state = "overlayOff";
            expanded = false;
        }
    }
}
