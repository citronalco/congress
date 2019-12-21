import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import "components"

ApplicationWindow
{
    initialPage: Component { DayPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
    property var trackcols

    Component.onCompleted: {
        trackcols = {
            "CCC": "blue",
            "Entertainment": "blue",
            "Security": "red",
            "Hardware & Making": "green",
            "Art & Culture": "orange",
            "Ethics, Society & Politics": "cyan",
            "Science": "blue",
            "Resilience & Sustainability": "cyan"
        }
    }

    CongressHandlerPython {
        id: congresshandler
    }
}
