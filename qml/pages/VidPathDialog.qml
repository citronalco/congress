import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Dialog {
    onOpened: {
        vidPathConf.text = videoPath.value
    }
    onAccepted: {
        videoPath.value = vidPathConf.text
        congresshandler.setVidPath(videoPath.value)
    }

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: viddowncol.height + viddowncol.spacing + header.height + header.spacing
        DialogHeader {
            id: header
            title: qsTr("Set Videopath")
        }

        Column {
            id: viddowncol
            anchors.top: header.bottom
            width: parent.width
            spacing: Theme.paddingMedium

            Label {
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingMedium
                }

                text: qsTr("Set video path")
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.highlightColor
            }
            Label {
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingMedium
                }

                text: qsTr("Please note that a video may take GBs of space!")
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.highlightColor
                width: parent.width
                wrapMode: Text.WordWrap
            }
            TextField {
                id: vidPathConf
                focus: true
                width: parent.width
                placeholderText: "/home/nemo/Videos/congress"
            }
        }
    }
}
