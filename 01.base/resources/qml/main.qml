import QtQuick 2.12
import QtQuick.Controls 2.12

ApplicationWindow {
    id: root

    width: 720
    height: 480
    visible: true
    title: qsTr("01.base - Qt5/QML 基础")
    color: "#f3f6fb"

    Column {
        anchors.centerIn: parent
        spacing: 24

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Hello, Qt5 + QML!")
            color: "#172033"
            font.pixelSize: 30
            font.bold: true
        }

        Rectangle {
            id: learningCard

            width: 360
            height: 180
            radius: 16
            color: mouseArea.containsMouse ? "#e5484d" : "#2563eb"

            Behavior on color {
                ColorAnimation { duration: 200 }
            }

            Column {
                anchors.centerIn: parent
                spacing: 12

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: mouseArea.containsMouse
                          ? qsTr("这是 Behavior 颜色动画")
                          : qsTr("把鼠标移到这里")
                    color: "white"
                    font.pixelSize: 22
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("已点击 %1 次").arg(backend.clickCount)
                    color: "#eaf2ff"
                    font.pixelSize: 16
                }
            }

            MouseArea {
                id: mouseArea

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: backend.recordClick()
            }
        }

        MyButton {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("由 C++ 后端清零")
            onClicked: backend.reset()
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: backend.statusText
            color: "#5f6b7a"
            font.pixelSize: 16
        }
    }
}
