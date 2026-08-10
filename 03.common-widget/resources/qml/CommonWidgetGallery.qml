import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "pages"

Item {
    id: root

    width: 960
    height: 700

    property alias currentTab: tabBar.currentIndex
    property int actionCount: 0
    property string lastAction: qsTr("等待操作")

    function recordAction(description) {
        actionCount += 1
        lastAction = description
    }

    Rectangle {
        anchors.fill: parent
        color: "#f8fafc"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Qt Quick 常用控件实验室")
            color: "#0f172a"
            font.pixelSize: 26
            font.bold: true
        }

        TabBar {
            id: tabBar
            objectName: "tabBar"

            Layout.fillWidth: true

            TabButton { text: qsTr("基础控件") }
            TabButton { text: qsTr("输入控件") }
            TabButton { text: qsTr("选择与布局") }
            TabButton { text: qsTr("高级控件") }
        }

        SwipeView {
            id: swipeView

            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: tabBar.currentIndex
            clip: true

            BasicControlsPage {
                onActionTriggered: root.recordAction(description)
            }

            InputControlsPage {
                onActionTriggered: root.recordAction(description)
            }

            SelectionLayoutPage {
                onActionTriggered: root.recordAction(description)
            }

            AdvancedControlsPage {
                onActionTriggered: root.recordAction(description)
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 42
            radius: 6
            color: "#dbeafe"

            Label {
                anchors.centerIn: parent
                text: qsTr("状态：%1（累计 %2 次操作）")
                    .arg(root.lastAction)
                    .arg(root.actionCount)
                color: "#1e3a8a"
            }
        }
    }
}
