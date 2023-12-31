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
            title: qsTr("Preferences")
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

                text: qsTr("Please note that a video may take GBs of space! Please prefer sdcard path.")
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.highlightColor
                width: parent.width
                wrapMode: Text.WordWrap
            }
            TextField {
                id: vidPathConf
                focus: false
                width: parent.width
                placeholderText: StandardPaths.videos  + "/congress"
            }
        }
    }
}
