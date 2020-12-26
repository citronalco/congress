import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Timer {
        interval: 1000 * 60 * 15
        running:true
        repeat:true
        onTriggered: {
            var oneDay = 24 * 60 * 60 * 1000
            var dnow = Date.now()
            var d37 = new Date('2021-12-27 00:00:00')
            dayscount.text = Math.round(Math.abs((d37 - dnow) / oneDay))
        }
    }

    Image {
        source: "../../images/logo.png"
        width: parent.width * 2
        height: parent.width * 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        opacity: 0.1
    }

    Column {
        anchors.centerIn: parent
        Label {
            id: dayscount
            anchors.horizontalCenter: parent.horizontalCenter
            text: {
                var oneDay = 24 * 60 * 60 * 1000
                var dnow = Date.now()
                var d37 = new Date('2021-12-27 00:00:00')
                return Math.round(Math.abs((d37 - dnow) / oneDay))
            }
            font.pixelSize: Theme.fontSizeExtraLarge * 2
            font.bold: true
            color: Theme.highlightColor
        }

        Label {
            text: qsTr("days until #37c3")
            font.pixelSize: Theme.fontSizeMedium
            color: Theme.highlightColor
            font.bold: true
        }
    }

    CoverActionList {
        id: coverAction

    }
}
