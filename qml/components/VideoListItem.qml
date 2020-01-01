import QtQuick 2.5
import Sailfish.Silica 1.0

ListItem {
    id: viditem
    width: parent.width
    //    height: theelement.height
    contentHeight: trackrow.height + titlerow.height + subtitlerow.height + personsrow.height + durationrow.height + 2 * roomrow.height
    anchors {
        left: parent.left
        right: parent.right
    }
    onClicked: {
        pageStack.push(Qt.resolvedUrl("../pages/EventPage.qml"), { eventid: eventid })
    }
    menu: ContextMenu {
        MenuItem {
            text: qsTr("Play Video")
            visible: vidurl != ""
            onClicked: congresshandler.playVideo(vidurl)
        }

        MenuItem {
            text: qsTr("Delete Video")
            onClicked: Remorse.itemAction(viditem, qsTr("Delete Video"), function () {
                congresshandler.deleteVideo(eventid)
            })
            visible: vidurl[0] === "f"
        }
    }

    Item {
        id: theelement
        width: parent.width
        // height: eventcol.height

        anchors {
            left: parent.left
            right: parent.right
            margins: Theme.paddingMedium
        }


        Column {
            visible: title !== ""
            id: eventcol
            anchors {
                left: parent.left
                right: parent.right
                margins: Theme.paddingLarge
            }
            height: trackrow.height + titlerow.height + subtitlerow.height + personsrow.height + durationrow.height + 2 * roomrow.height
            width: parent.width


            Row {
                id: trackrow
                width: parent.width
                // height: contentHeight
                Label {
                    width: parent.width
                    text: track
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: trackcols[track]
                    Icon {
                        anchors.top: parent.top
                        anchors.right: parent.right
                        source: "image://theme/icon-lock-voicemail"
                        visible: vidurl != ""
                    }
                }
            }

            Row {
                id: titlerow
                width: parent.width
                // height: contentHeight
                Label {
                    width: parent.width
                    text: title
                    font.bold: true
                    wrapMode: Text.WordWrap
                }
            }

            Row {
                id: subtitlerow
                width: parent.width
                Label {
                    width: parent.width
                    text: subtitle ? subtitle : ""
                    font.bold: true
                    wrapMode: Text.WordWrap
                    font.pixelSize: Theme.fontSizeSmall
                    visible: text != ""
                }
            }

            Row {
                id: personsrow
                width: parent.width
                Label {
                    text: persons
                    width: parent.width
                    font.bold: true
                    wrapMode: Text.WordWrap
                    font.pixelSize: Theme.fontSizeExtraSmall
                }
            }

            Row {
                id: durationrow
                width: parent.width
                Label {
                    text: qsTr("Duration: ") + duration
                    font.pixelSize: Theme.fontSizeExtraSmall
                }
            }

            Row {
                id: roomrow
                Label {
                    text: room
                    font.pixelSize: Theme.fontSizeExtraSmall
                }
            }
        }
    }
}
