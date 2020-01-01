import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4

Python {
    id: congresshandler

    signal conData(var data)
    signal daysData(var data)
    signal dayData(var data)
    signal eventData(var data)
    signal speakersData(var data)
    signal speakerData(var data)
    signal vidPercent(int evid, int percent)
    signal vidPath(string path)
    signal noVidPath()
    signal videoDeleted(int evid)

    Component.onCompleted: {
        setHandler("conData", conData)
        setHandler("daysData", daysData)
        setHandler("dayData", dayData)
        setHandler("eventData", eventData)
        setHandler("speakersData",speakersData)
        setHandler("speakerData", speakerData)
        setHandler("vidPercent", vidPercent)
        setHandler("vidPath", vidPath)
        setHandler("noVidPath", noVidPath)
        setHandler("videoDeleted", videoDeleted)

        addImportPath(Qt.resolvedUrl('.'))
        importModule('CongressHandler', function () {
            console.log('CongressHandler is now imported')
        })

    }

    function getConData() {
        console.log("conData")
        call("CongressHandler.congresshandler.con_data", function() {})
    }

    function getDay(theday) {
        console.log("getDay")
        call("CongressHandler.congresshandler.get_day", [theday], function() {})
    }

    function getDays() {
        console.log("getDays")
        call("CongressHandler.congresshandler.get_days", function() {})
    }

    function getSpeakers() {
        console.log("getSpeakers")
        call("CongressHandler.congresshandler.get_speakers", function() {})
    }

    function getSpeaker(speakerId) {
        console.log("getSpeaker")
        call("CongressHandler.congresshandler.get_speaker", [speakerId], function() {})
    }

    function getEvent(id) {
        console.log("getEvent: " + id)
        call("CongressHandler.congresshandler.get_event", [id], function() {})
    }

    function loadVid(id, url) {
        console.log("load and get Video for event " + id)
        call("CongressHandler.congresshandler.load_vid", [id, url])
    }

    function setVidPath(vidpath) {
        console.log("Set videopath to " + vidpath)
        call("CongressHandler.congresshandler.set_vidpath", [vidpath])
    }

    function getVids() {
        console.log("Get loaded videos")
        call("CongressHandler.congresshandler.get_vids")
    }

    function playVideo(vidurl) {
        console.log("Playing video")
        call("CongressHandler.congresshandler.play_vid", [vidurl])
    }

    function deleteVideo(eventid) {
        console.log("Deleting video")
        call("CongressHandler.congresshandler.delete_video", [eventid])
    }

    onError: {
        console.log('python error: ' + traceback);
    }

    onReceived: {
        console.log('got message from python: ' + data);
    }
}
