import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: page

    SilicaListView {
        id: speakerlist
        width: parent.width
        height: page.height

        Component.onCompleted: {
            congresshandler.getSpeakers()
        }

        Connections {
            target: congresshandler
            onSpeakersData: {
                console.log("speakersData: " + data.length + " elements")
                speakersModel.clear()
                for(var i=0; i < data.length; i++) {
                    speakersModel.append(data[i])
                }
            }
        }

        header: PageHeader {
            id: title
            title: qsTr("Speakers")
        }

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
//            MenuItem {
//                text: qsTr("Favorites")
//                onClicked: pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
//            }
//            MenuItem {
//                text: qsTr("Videos")
//                onClicked: pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
//            }
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("../pages/AboutPage.qml"))
            }
            MenuItem {
                text: qsTr("Program")
                onClicked: pageStack.replace(Qt.resolvedUrl("DayPage.qml"))
            }
        }

        model: ListModel {
            id: speakersModel
        }

        delegate: SpeakerListItem { }
    }
}
