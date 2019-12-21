import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4

Python {
    id: congresshandler

    signal conData(var data)
    signal daysData(var data)
    signal dayData(var data)
    signal eventData(var data)

    Component.onCompleted: {
        setHandler("conData", conData)
        setHandler("daysData", daysData)
        setHandler("dayData", dayData)
        setHandler("eventData", eventData)

        addImportPath(Qt.resolvedUrl('.'));
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

    function getEvent(id) {
        console.log("getEvent: " + id)
        call("CongressHandler.congresshandler.get_event", [id], function() {})
    }

    onError: {
        console.log('python error: ' + traceback);
    }

    onReceived: {
        console.log('got message from python: ' + data);
    }
}
