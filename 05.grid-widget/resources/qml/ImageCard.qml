import QtQuick 2.12

Rectangle {
    id: root

    property string imageName
    property url imageSource
    property string fileSize
    property string modified
    property bool selected: false
    signal clicked
    signal previewRequested

    width: 188
    height: 208
    radius: 10
    color: selected ? "#d6eaf8" : "white"
    border.width: selected ? 3 : 1
    border.color: selected ? "#3498db" : "#d5d8dc"
    scale: mouseArea.containsMouse ? 1.03 : 1.0

    Behavior on scale { NumberAnimation { duration: 120 } }

    Column {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 5

        Rectangle {
            width: parent.width
            height: 138
            radius: 6
            color: "#ecf0f1"
            clip: true

            Image {
                anchors.fill: parent
                anchors.margins: 4
                source: root.imageSource
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                cache: true
            }
        }

        Text {
            width: parent.width
            text: root.imageName
            elide: Text.ElideMiddle
            horizontalAlignment: Text.AlignHCenter
            font.bold: true
            color: "#2c3e50"
        }

        Text {
            width: parent.width
            text: root.fileSize + " · " + root.modified
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 11
            color: "#7f8c8d"
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (mouse.button === Qt.RightButton)
                root.previewRequested()
            else
                root.clicked()
        }
        onDoubleClicked: root.previewRequested()
    }
}
