import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Image {
        source: "../../images/logo.png"
        width: parent.width * 2
        height: parent.width * 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        opacity: 0.1
    }

    CoverActionList {
        id: coverAction

    }
}
