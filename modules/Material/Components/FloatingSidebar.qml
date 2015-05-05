import QtQuick 2.0
import Material 0.1
import Material.ListItems 0.1 as ListItem

/*!
    \qmltype FloatingSidebar
    \brief A sidebar component for use in adaptive layouts

    To use, simply add an instance to your code, and anchor other components to it.

    To show or hide, set the expanded property.
    On mobile devices sidebar becomes floating.
    It means that menu will be hidden by default and can be expanded by gestures from screen sides.

    By default, the sidebar has a flickable built in, and whatever contents are added
    will be placed in the flickable. When you want this disabled, or want to fill the
    entire sidebar, set the autoFill property to false.

    Examples:
    \qml
        MouseArea {
            onClicked: fbar.expanded = true;
        }

        FloatingSidebar {
            id: fbar

            // Anchoring is automatic
        }
    \endqml
*/
PopupBase {
    id: menuOverlay

    property bool floating: Device.isMobile
    property bool expanded: floating ? false : true

    property string mode: "left" // or "right"

    property alias slideArea: __slideArea
    property alias slideAreaWidth: __slideArea.width
    property alias menuWidth: menuContainer.width

    overlayColor: Qt.rgba(0, 0.1, 0.2, 0.6)

    visible: opacity > 0

    anchors {
        top: parent.top
        bottom: parent.bottom
        left: parent.left
        right: parent.right
    }

    default property alias contents: contents.data

    signal openned()
    signal closed()

    Keys.onEscapePressed: menuOverlay.hide()

    property bool autoFlick: true

    View {
        id: menuContainer

        anchors {
            left: mode === "left" ? parent.left : undefined
            right: mode === "right" ? parent.right : undefined
            top: parent.top
            bottom: parent.bottom
        }

        elevation: floating ? 4 : 1
        width: units.dp(250)

        Flickable {
            id: flickable

            clip: true

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                rightMargin: mode === "left" ? 1 : 0
                leftMargin: mode === "right" ? 1 : 0
            }

            contentWidth: width
            contentHeight: autoFlick ? contents.height : height

            interactive: contentHeight > height
            boundsBehavior: Flickable.StopAtBounds
            maximumFlickVelocity: 700 //Need to calculate this

            Item {
                id: contents

                width: flickable.width
                height: autoFlick ? childrenRect.height : flickable.height
            }
        }

        Scrollbar {
            flickableItem: flickable
        }
    }

    Translate {
        id: menuTranslate;
        x: __expanded_binding()
        Behavior on x {
            NumberAnimation { easing.type: Easing.OutQuad; duration: 300 }
        }
    }
    transform: menuTranslate

    function startSlideTransform() {

        var startTranslateX = menuTranslate.x;
        menuTranslate.x = Qt.binding(
                    function (){

                        var result = mode === "left" ?
                                    Math.min(startTranslateX + slideArea.mouseX, 0) :
                                    Math.max(startTranslateX + slideArea.mouseX, 0);
                        return result;
                    }
                    )
        open()
    }

    function stopSlideTransform() {

        var condition = mode === "left" ?
                    (menuTranslate.x > (-menuContainer.width / 2)) :
                    (menuTranslate.x < (menuContainer.width / 2))

        if (condition === false) close();

        expanded = condition;
        menuTranslate.x = Qt.binding(
                    __expanded_binding
                    )
    }

    onShowingChanged: { if (showing === false) expanded = false; }
    onExpandedChanged: {
        if (expanded) {
            if (floating) {
                open();
            }
            /*emit*/ openned();
        } else {
            if (floating) {
                close();
            }
            /*emit*/ closed();
        }
    }

    onFloatingChanged: {
        var adjoiningItem = pageStack;

        if (!adjoiningItem ) {
            console.error("[ adjoiningItem ] is empty! Not-floating mode will not work.");
            return;
        }

        if (mode === "left") {
            if (!floating) {
                adjoiningItem.anchors.leftMargin = Qt.binding(
                            function (){ return menuContainer.width + menuTranslate.x; }
                            );
                parent = adjoiningItem.parent;
                menuOverlay.anchors.top = adjoiningItem.top;
            } else {
                adjoiningItem.anchors.leftMargin = 0;
                menuOverlay.anchors.top = parent.top;
            }
        } else { //mode === "right"
            if (!floating) {
                adjoiningItem.anchors.rightMargin = Qt.binding(
                            function (){ return menuContainer.width - menuTranslate.x; }
                            );
                parent = adjoiningItem.parent;
                menuOverlay.anchors.top = adjoiningItem.top;
            } else {
                adjoiningItem.anchors.rightMargin = 0;
                menuOverlay.anchors.top = parent.top;
            }
        }

    }

    function __expanded_binding() {
        return expanded ? 0 : (mode == "left" ? -menuContainer.width : menuContainer.width);
    }

    MouseArea {
        id: __slideArea

        property alias color: __slideAreaRect.color
        width: units.dp(20)
        visible: floating

        anchors {
            left: mode === "left" ? parent.left : undefined
            right: mode === "right" ? parent.right : undefined
            top: parent.top
            bottom: parent.bottom
        }
        propagateComposedEvents: true

        parent: menuOverlay.parent
        //        z: 10 // place upper all slidebar items

        onPressed: startSlideTransform()
        onReleased: stopSlideTransform()

        // Indicates area for a slide.
        Rectangle {
            id: __slideAreaRect
            anchors.fill: parent
            color: "transparent"
            opacity: 0.5
        }
    }
}
