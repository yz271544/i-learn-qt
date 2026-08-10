import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Page {
    id: root

    signal actionTriggered(string description)

    ScrollView {
        anchors.fill: parent
        clip: true

        ColumnLayout {
            width: root.width - 28
            spacing: 12

            Text {
                text: qsTr("彩色 Text：用于只读文本显示")
                color: "#d32f2f"
                font.pixelSize: 18
                font.bold: true
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 42
                radius: 4
                color: "#f1f8e9"
                border.color: "#c5e1a5"

                TextInput {
                    anchors.fill: parent
                    anchors.margins: 8
                    text: qsTr("TextInput：轻量单行输入")
                    verticalAlignment: TextInput.AlignVCenter
                    color: "#2e7d32"
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 72
                radius: 4
                color: "#fff3e0"
                border.color: "#ffcc80"

                TextEdit {
                    anchors.fill: parent
                    anchors.margins: 8
                    text: qsTr("TextEdit：轻量多行编辑\n支持自动换行。")
                    wrapMode: TextEdit.Wrap
                    color: "#5d4037"
                }
            }

            GroupBox {
                title: qsTr("按钮控件")
                Layout.fillWidth: true

                RowLayout {
                    width: parent.width

                    Button {
                        objectName: "basicButton"
                        text: qsTr("普通按钮")
                        onClicked: root.actionTriggered(text)
                    }

                    RoundButton {
                        text: qsTr("圆形")
                        onClicked: root.actionTriggered(text)
                    }

                    ToolButton {
                        text: qsTr("工具")
                        onClicked: root.actionTriggered(text)
                    }

                    Item { Layout.fillWidth: true }
                }
            }

            GroupBox {
                title: qsTr("选择按钮")
                Layout.fillWidth: true

                RowLayout {
                    width: parent.width

                    CheckBox {
                        objectName: "basicCheckBox"
                        text: qsTr("启用提示")
                        checked: true
                        onToggled: root.actionTriggered(
                            checked ? qsTr("复选框：开启") : qsTr("复选框：关闭"))
                    }

                    ButtonGroup { id: choiceGroup }

                    RadioButton {
                        text: qsTr("方案 A")
                        checked: true
                        ButtonGroup.group: choiceGroup
                    }

                    RadioButton {
                        text: qsTr("方案 B")
                        ButtonGroup.group: choiceGroup
                    }

                    Item { Layout.fillWidth: true }
                }
            }
        }
    }
}
