import QtQuick 2.12

Rectangle {
    id: root

    property alias text: label.text
    signal clicked

    implicitWidth: 160
    implicitHeight: 44
    radius: 8
    color: buttonMouseArea.pressed ? "#c7d2fe" : "#e0e7ff"
    border.color: "#818cf8"

    Text {
        id: label

        anchors.centerIn: parent
        color: "#3730a3"
        font.pixelSize: 16
    }

    MouseArea {
        id: buttonMouseArea

        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
