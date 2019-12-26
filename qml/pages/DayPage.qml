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
        height: parent.height - daypanel.height
    }

    DockedPanel {
        id: daypanel

        width: parent.width
        height: Theme.itemSizeSmall

        dock: Dock.Bottom
        open: true

        Rectangle {
            anchors.fill: parent
            color: Theme.highlightDimmerColor
        }

        IconButton {
            anchors {
                left: parent.left
                //top: parent.top
            }
            z: 5
            opacity: 1.0
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
                //top: parent.top
            }
            z: 5
            opacity: 1.0
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
                //top: parent.top
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
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
}
