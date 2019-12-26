import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: page
    property int speakerid
    property var speakerdata

    Component.onCompleted: {
        congresshandler.getSpeaker(speakerid)
    }

    allowedOrientations: Orientation.All

    Connections {
        target: congresshandler
        onSpeakerData: {
            console.log("SpeakerData", data)
            speakerdata = data
            eventsModel.clear()
            for(var i=0; i < data.events.length; i++) {
                eventsModel.append(data.events[i])
                console.log(data.events[i].title)
            }
        }
    }

    SilicaFlickable {
        id: speakerinfo
        // anchors.fill: parent
        anchors.top: parent.top
        width: parent.width
        height: parent.height
        contentWidth: parent.width
        contentHeight: aele.height + bele.height + cele.height + dele.height + aele.spacing + bele.spacing + cele.spacing + dele.spacing
                       + eventslist.height + eventslist.spacing

        // VerticalScrollDecorator { flickable: flickable }

        Column {
            id: eventcol
            width: parent.width
            // anchors.fill: parent
            spacing: Theme.paddingMedium

            Row {
                id: aele
                height: Theme.itemSizeMedium
                Label {
                    text: " "
                }
            }
            Label {
                id: bele
                width: parent.width
                text: speakerdata.full_public_name
                font.bold: true
                font.pixelSize: Theme.fontSizeMedium
                padding: Theme.paddingMedium
            }

            Label {
                id: cele
                width: parent.width
                padding: Theme.paddingMedium
                text: speakerdata.abstract
                font.bold: false
                font.pixelSize: Theme.fontSizeMedium
                wrapMode: Text.WordWrap
                visible: typeof(speakerdata.abstract) != undefined && speakerdata.abstract !== null
            }
            Label {
                id: dele
                width: parent.width
                text: qsTr("Events:\n")
                font.bold: true
                font.pixelSize: Theme.fontSizeSmall
                padding: Theme.paddingMedium
            }
            SilicaListView {
                id: eventslist
                anchors.top: dele.bottom
                width: parent.width
                // height: contentHeight
                model: ListModel {
                    id: eventsModel
                }

                delegate: EventListItem { }
            }
        }
    }
}
