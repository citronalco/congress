import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0

Page {
    id: page
    property string vidurl
    property string event_id
    property int downperc: 0
    property bool doplay: true

    Component.onCompleted: {
        congresshandler.loadVid(event_id, vidurl)
    }

    Connections {
        target: congresshandler
        onVidPercent: {
            console.log("vidPercent: " + percent)
            progCircle.progressValue = percent
        }
        onVidPath: {
            video.source = path
        }
    }

    allowedOrientations: Orientation.Landscape
    Video {
        id: video
        width: parent.width
        height: parent.height
        source: ""

        ProgressCircle {
            id: progCircle
            anchors.centerIn: parent
            z: 5
            borderWidth: 2
            width: parent.width * 0.1
            height: parent.width * 0.1
            progressValue: 100
        }

        Icon {
            anchors.centerIn: parent
            z: 5
            source: "image://theme/icon-l-play"
            visible: doplay && (downperc <= 1 && downperc >= 100)
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                doplay ? video.play() : video.pause()
                doplay = !doplay
            }
        }
    }
}
