import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: selectDockedPanel

    width: parent.width
    height: Theme.itemSizeLarge
    anchors.bottom: parent.bottom

    Rectangle {
        anchors.fill: parent
        color: Theme.highlightDimmerColor
        opacity: 0.7
    }
}
