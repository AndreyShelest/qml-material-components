import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 1.2

Window {

    visible: true
    flags: Qt.SplashScreen
    Component.onCompleted: loader.source = Qt.resolvedUrl("qrc:/main.qml")

Rectangle {
    anchors.fill: parent
    color: "green"
}
BusyIndicator {
    anchors.centerIn: parent
}

Loader {
    id: loader
    asynchronous: true
    onLoaded: close();
}
}

