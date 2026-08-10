import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ApplicationWindow {
    id: window

    width: 800
    height: 600
    visible: true
    title: qsTr("02.project-layout - Qt 5.15")

    property int clickCount: 0

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 18

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Qt Quick 工程结构")
            font.pixelSize: 28
            font.bold: true
        }

        ToggleCard {
            id: toggleCard

            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                window.clickCount += 1
                console.log("Rectangle clicked! count =", window.clickCount)
            }
        }

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("点击次数：%1").arg(window.clickCount)
            color: "#334155"
            font.pixelSize: 16
        }
    }

    footer: Label {
        text: qsTr("Application is running successfully!")
        padding: 10
        horizontalAlignment: Text.AlignHCenter
        color: "#1e3a8a"

        background: Rectangle {
            color: "#dbeafe"
        }
    }
}
