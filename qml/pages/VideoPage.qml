import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: page

    Component.onCompleted: {
        congresshandler.getVids()
    }


    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    SilicaListView {
        id: eventlist
        anchors.fill: parent
        width: parent.width

        header: PageHeader {
            id: title
            title: qsTr("Downloaded Videos")
        }

        section {
            property: 'track'
            delegate: SectionHeader {
                text: section
                horizontalAlignment: Text.AlignRight
            }
        }

        Connections {
            target: congresshandler
            onDayData: {
                console.log("dayData")
                eventsModel.clear()
                for(var i=0; i < data.length; i++) {
                    eventsModel.append(data[i])
                    console.log("vidurl: " + data[i].vidurl)
                }
            }
            onVideoDeleted: {
                congresshandler.getVids()
            }
        }

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("../pages/AboutPage.qml"))
            }
            MenuItem {
                text: qsTr("Preferences")
                onClicked: pageStack.push(Qt.resolvedUrl("../pages/Preferences.qml"))
            }

            MenuItem {
                text: qsTr("Speakers")
                onClicked: pageStack.replace(Qt.resolvedUrl("../pages/SpeakersPage.qml"))
            }
            MenuItem {
                text: qsTr("Program")
                onClicked: pageStack.replace(Qt.resolvedUrl("../pages/DayPage.qml"))
            }
        }

        model: ListModel {
            id: eventsModel
        }

        delegate: VideoListItem { }
    }
}
