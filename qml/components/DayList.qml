import QtQuick 2.0
import Sailfish.Silica 1.0
import "../pages"

SilicaListView {
    id: eventlist
    property int daynumber
    width: parent.width
    height: contentHeight

    onDaynumberChanged: {
        console.log("dayNumber changed")
        congresshandler.getDay(daynumber)
        scrollToTop()
    }

    section {
        property: 'start'
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
            }
        }
    }

    header: PageHeader {
        id: title
        title: qsTr("Day ") + daynumber
    }

    // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
    PullDownMenu {
        MenuItem {
            text: qsTr("Favorites")
            onClicked: pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
        }
        MenuItem {
            text: qsTr("Videos")
            onClicked: pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
        }
        MenuItem {
            text: qsTr("Lecturer")
            onClicked: pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
        }
    }

    model: ListModel {
        id: eventsModel
    }

    delegate: EventListItem { }
}
