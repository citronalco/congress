import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: page
    property int daynum: 1
    property var daysdata
    property int daymax

    Component.onCompleted: {
        congresshandler.getDays()
    }

    Connections {
        target: congresshandler
        onDaysData: {
            daysdata = data
            daymax = daysdata.length
        }
    }

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    DayList {
        id: daylist
        daynumber: daynum
        height: parent.height
    }

    IconButton {
        anchors {
            left: parent.left
            bottom: parent.bottom
        }
        z: 5
        opacity: 0.9
        icon.source: "image://theme/icon-m-left"
        visible: daynum !== 1
        onClicked: {
            if (daynum != 1) {
                daynum -= 1
            }
        }
    }
    IconButton {
        anchors {
            right: parent.right
            bottom: parent.bottom
        }
        z: 5
        opacity: 0.9
        icon.source: "image://theme/icon-m-right"
        visible: daynum !== daymax
        onClicked: {
            if (daynum != daymax) {
                daynum += 1
            }
        }
    }
    Button {
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        opacity: 1.0
        z: 5
        text: {
            var thedate = new Date(daysdata[daynum -1 ].date).toLocaleDateString()
            return (qsTr("Day ") + daynum + ": " + thedate)
        }
        onClicked: daylist.scrollToTop()
    }
}
