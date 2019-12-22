import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    function get_about() {
        var xhr = new XMLHttpRequest
        xhr.open("GET", qsTr("../data/about.txt"))
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                page.abouttext = xhr.responseText;
                // use file contents as required
            }
        };
        xhr.send();
    }

    Component.onCompleted: get_about()

    property string abouttext
    property int margin: Theme.paddingMedium

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.Portrait

    SilicaFlickable {
        anchors.fill: parent
        VerticalScrollDecorator { }

        // contentWidth: aboutlabel.width
        contentHeight: bannercolumn.height + bannercolumn.spacing + aboutcolumn.height + aboutcolumn.spacing
        Column {
            id: bannercolumn
            width: parent.width
            height: parent.width / 2
            Image {
                source: "../../images/banner.png"
                width: parent.width
                height: parent.height
            }
        }

        Column {
            id: aboutcolumn
            anchors.top: bannercolumn.bottom
            width: parent.width
            spacing: Theme.paddingMedium

            Label {
                id: aboutlabel
                text: page.abouttext
                font.pixelSize: Theme.fontSizeSmall
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: margin
                }
                wrapMode: Text.WordWrap
                textFormat: Text.AutoText
                linkColor: Theme.highlightColor
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }
    }
}
