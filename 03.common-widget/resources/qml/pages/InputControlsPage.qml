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
            spacing: 14

            Label {
                text: qsTr("TextField 提供占位文本、焦点和验证等完整输入体验")
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            TextField {
                objectName: "nameField"
                Layout.fillWidth: true
                placeholderText: qsTr("请输入姓名")
                onEditingFinished: root.actionTriggered(qsTr("姓名：%1").arg(text))
            }

            TextArea {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                placeholderText: qsTr("请输入多行备注")
                wrapMode: TextArea.Wrap
                background: Rectangle {
                    radius: 5
                    border.color: "#94a3b8"
                    color: "white"
                }
            }

            RowLayout {
                Layout.fillWidth: true

                Label { text: qsTr("SpinBox 数值：") }
                SpinBox {
                    objectName: "amountSpinBox"
                    from: 0
                    to: 100
                    value: 50
                    onValueModified: root.actionTriggered(qsTr("SpinBox：%1").arg(value))
                }
                Item { Layout.fillWidth: true }
            }

            Label { text: qsTr("Slider 数值：%1").arg(Math.round(valueSlider.value)) }

            Slider {
                id: valueSlider
                objectName: "valueSlider"
                Layout.fillWidth: true
                from: 0
                to: 100
                value: 50
                onMoved: root.actionTriggered(qsTr("Slider：%1").arg(Math.round(value)))
            }
        }
    }
}
