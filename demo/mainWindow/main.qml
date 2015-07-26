import QtQuick 2.2
import Material 0.1
import Material.Components 0.1 as MGui

MGui.MainWindow {
    id: demo

    title: "DemoWindow"

    initialPage: DemoPage{
        backAction: leftSidebar.backAction
    }
}
