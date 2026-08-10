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

            ComboBox {
                objectName: "fruitComboBox"
                Layout.preferredWidth: 240
                model: [qsTr("苹果"), qsTr("香蕉"), qsTr("橙子")]
                onActivated: root.actionTriggered(qsTr("下拉选择：%1").arg(currentText))
            }

            Switch {
                objectName: "featureSwitch"
                text: qsTr("启用实时预览")
                checked: true
                onToggled: root.actionTriggered(
                    checked ? qsTr("开关：开启") : qsTr("开关：关闭"))
            }

            GroupBox {
                title: qsTr("RowLayout：横向排列")
                Layout.fillWidth: true

                RowLayout {
                    width: parent.width
                    Button { text: "Row 1" }
                    Button { text: "Row 2" }
                    Item { Layout.fillWidth: true }
                }
            }

            GroupBox {
                title: qsTr("GridLayout：网格排列")
                Layout.fillWidth: true

                GridLayout {
                    columns: 2
                    columnSpacing: 10
                    rowSpacing: 8

                    Label { text: qsTr("用户名") }
                    TextField { placeholderText: qsTr("user") }
                    Label { text: qsTr("密码") }
                    TextField { echoMode: TextInput.Password; placeholderText: "******" }
                }
            }
        }
    }
}
