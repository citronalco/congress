import QtQuick 2.5
import Sailfish.Silica 1.0

ListItem {
    width: parent.width
    height: theelement.height
    anchors {
        left: parent.left
        right: parent.right
    }
//    onClicked: {
//        pageStack.push(Qt.resolvedUrl("../pages/EventPage.qml"), { eventid: eventid })
//    }

    Item {
        id: theelement
        width: parent.width
        height: speakerscol.height
        anchors {
            left: parent.left
            right: parent.right
            margins: Theme.paddingMedium
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                pageStack.push(Qt.resolvedUrl("../pages/SpeakerPage.qml"), {speakerid: id})
            }
        }

        Column {
            id: speakerscol
            anchors {
                left: parent.left
                right: parent.right
                margins: Theme.paddingLarge
            }
            // height: trackrow.height + titlerow.height + subtitlerow.height + personsrow.height + durationrow.height + 2 * roomrow.height
            height: namerow.height
            width: parent.width

            Row {
                id: namerow
                width: parent.width
                height: contentHeight
                Label {
                    width: parent.width
                    text: full_public_name.replace(/^\s+|\s+$/g,'')
                    font.pixelSize: Theme.fontSizeMedium
                    font.bold: true
                }
            }
        }
    }
}
