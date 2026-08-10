import QtQuick 2.12

Rectangle {
    id: root

    property bool switched: false
    signal clicked

    width: 200
    height: 100
    radius: 10
    color: switched ? "lightgreen" : "lightblue"
    border.color: switched ? "green" : "blue"

    Text {
        anchors.centerIn: parent
        text: root.switched
              ? qsTr("Hello, light green!")
              : qsTr("Hello, Qt 5.15!")
        font.pixelSize: 16
        color: "darkblue"
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root.switched = !root.switched
            root.clicked()
        }
    }
}
