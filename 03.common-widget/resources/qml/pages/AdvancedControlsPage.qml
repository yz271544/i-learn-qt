import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Page {
    id: root

    signal actionTriggered(string description)

    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        GroupBox {
            title: qsTr("进度指示")
            Layout.fillWidth: true

            ColumnLayout {
                width: parent.width

                ProgressBar {
                    objectName: "demoProgressBar"
                    Layout.fillWidth: true
                    from: 0
                    to: 1
                    value: progressSlider.value
                }

                Slider {
                    id: progressSlider
                    Layout.fillWidth: true
                    from: 0
                    to: 1
                    value: 0.65
                }

                BusyIndicator {
                    running: runningSwitch.checked
                    Layout.alignment: Qt.AlignHCenter
                }

                Switch {
                    id: runningSwitch
                    text: qsTr("BusyIndicator 运行")
                    checked: true
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter

            Button {
                text: qsTr("打开 Dialog")
                onClicked: demoDialog.open()
            }

            Button {
                text: qsTr("打开 Menu")
                onClicked: demoMenu.open()

                Menu {
                    id: demoMenu
                    y: parent.height
                    MenuItem {
                        text: qsTr("选项 1")
                        onTriggered: root.actionTriggered(text)
                    }
                    MenuItem {
                        text: qsTr("选项 2")
                        onTriggered: root.actionTriggered(text)
                    }
                }
            }
        }

        Item { Layout.fillHeight: true }
    }

    Dialog {
        id: demoDialog
        anchors.centerIn: parent
        title: qsTr("提示")
        modal: true
        standardButtons: Dialog.Ok | Dialog.Cancel
        onAccepted: root.actionTriggered(qsTr("对话框：确认"))
        onRejected: root.actionTriggered(qsTr("对话框：取消"))

        Label { text: qsTr("Dialog 用于需要用户明确响应的操作。") }
    }
}
