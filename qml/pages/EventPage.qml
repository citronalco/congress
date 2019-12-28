import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: page
    property int eventid
    property var eventdata
    property string title
    Component.onCompleted: {
        congresshandler.getEvent(eventid)
    }
    allowedOrientations: Orientation.All

    Connections {
        target: congresshandler
        onEventData: {
            console.log("eventData")
            eventdata = data
        }
    }

    SilicaFlickable {
        anchors.fill: parent
        width: parent.width
        contentWidth: eventcol.width
        contentHeight: eventcol.children.spacing + eventcol.children.height
        VerticalScrollDecorator { flickable: flickable }

        Column {
            id: eventcol
            width: parent.width
            anchors.fill: parent
            spacing: Theme.paddingMedium

            Row {
                id: toprow
                height: Theme.itemSizeMedium
                Label {
                    text: " "
                }
            }
            Label {
                id: durlabel
                width: parent.width
                text: eventdata.track
                color: trackcols[eventdata.track]
                font.bold: false
                font.pixelSize: Theme.fontSizeSmall
                padding: Theme.paddingMedium
            }

            Label {
                    width: parent.width
                    padding: Theme.paddingMedium
                    text: eventdata.title
                    font.bold: true
                    font.pixelSize: Theme.fontSizeLarge
                    wrapMode: Text.WordWrap
            }
            Label {
                width: parent.width
                padding: Theme.paddingMedium
                text: eventdata.subtitle
                font.bold: true
                font.pixelSize: Theme.fontSizeMedium
                wrapMode: Text.WordWrap
                visible: eventdata.subtitle !== ""
            }

            Label {
                width: parent.width
                padding: Theme.paddingMedium
                text: eventdata.persons
                font.bold: true
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.WordWrap
            }

            Label {
                width: parent.width
                padding: Theme.paddingMedium
                text: {
                    var thetime = new Date(eventdata.date).toLocaleTimeString()
                    var thedate = new Date(eventdata.date).toLocaleDateString()
                    return thedate + ", " + thetime
                }
                font.bold: false
                font.pixelSize: Theme.fontSizeSmall
            }
            Label {
                padding: Theme.paddingMedium
                width: parent.width
                text: eventdata.room
                font.bold: false
                font.pixelSize: Theme.fontSizeSmall
            }
            Label {
                padding: Theme.paddingMedium
                width: parent.width
                text: {
                    var langs = {
                        "en": qsTr("English"),
                        "de": qsTr("German"),
                        "fr": qsTr("French")
                    }
                    return langs[eventdata.language]
                }
                font.bold: false
                font.pixelSize: Theme.fontSizeSmall
            }
            Label {
                padding: Theme.paddingMedium
                width: parent.width
                visible: eventdata.vidurl !== ""
                text: qsTr("Play video")
                color: Theme.highlightColor
                MouseArea {
                    anchors.fill: parent
//                    onClicked: pageStack.push(Qt.resolvedUrl("VideoPage.qml"), {
//                                                  event_id: eventid,
//                                                  vidurl: eventdata.vidurl
//                                              })
                    onClicked: Qt.openUrlExternally(eventdata.vidurl)
                }
            }

            Label {
                padding: Theme.paddingMedium
                width: parent.width
                text: '<style>a:link { color: ' + Theme.highlightColor + '; }</style>' + eventdata.abstract
                textFormat: "RichText"
                wrapMode: Text.WordWrap
                font.bold: false
                font.pixelSize: Theme.fontSizeMedium
            }
        }
    }
}
