import QtQuick 2.2
import Material 0.1

Dialog {
    id: colorPicker
    title: "Pick color"

    positiveButtonText: "Done"

    MenuField {
        id: selection
        model: ["Primary color", "Accent color", "Background color"]
        width: Units.dp(160)
    }

    Grid {
        columns: 7
        spacing: Units.dp(8)

        Repeater {
            model: [
                "red", "pink", "purple", "deepPurple", "indigo",
                "blue", "lightBlue", "cyan", "teal", "green",
                "lightGreen", "lime", "yellow", "amber", "orange",
                "deepOrange", "grey", "blueGrey", "brown", "black",
                "white"
            ]

            Rectangle {
                width: Units.dp(30)
                height: Units.dp(30)
                radius: Units.dp(2)
                color: Palette.colors[modelData]["500"]
                border.width: modelData === "white" ? Units.dp(2) : 0
                border.color: Theme.alpha("#000", 0.26)

                Ink {
                    anchors.fill: parent

                    onPressed: {
                        switch(selection.selectedIndex) {
                        case 0:
                            theme.primaryColor = parent.color
                            break;
                        case 1:
                            theme.accentColor = parent.color
                            break;
                        case 2:
                            theme.backgroundColor = parent.color
                            break;
                        }
                    }
                }
            }
        }
    }

    onRejected: {
        // TODO set default colors again but we currently don't know what that is
    }
}
