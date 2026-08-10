import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Page {
    id: root

    readonly property int employeeCount: employeeModel.count
    property string selectedEmployee: ""
    signal employeeSelected(string name)

    function addEmployee(name, jobTitle) {
        if (name.length === 0)
            return
        employeeModel.append({
            "name": name,
            "jobTitle": jobTitle.length === 0 ? qsTr("新员工") : jobTitle,
            "avatar": "👤"
        })
    }

    function removeLastEmployee() {
        if (employeeModel.count > 0)
            employeeModel.remove(employeeModel.count - 1)
    }

    function employeeNameAt(row) {
        return employeeModel.get(row).name
    }

    function selectEmployee(name) {
        selectedEmployee = name
        employeeSelected(name)
        console.log("查看员工:", name)
    }

    function selectEmployeeAt(row) {
        if (row < 0 || row >= employeeModel.count)
            return
        employeeListView.currentIndex = row
        selectEmployee(employeeModel.get(row).name)
    }

    ListModel {
        id: employeeModel
        ListElement { name: "张三"; jobTitle: "开发工程师"; avatar: "👨‍💻" }
        ListElement { name: "李四"; jobTitle: "UI设计师"; avatar: "👩‍🎨" }
        ListElement { name: "王五"; jobTitle: "产品经理"; avatar: "👨‍💼" }
        ListElement { name: "赵六"; jobTitle: "测试工程师"; avatar: "👩‍🔬" }
        ListElement { name: "钱七"; jobTitle: "运维工程师"; avatar: "👨‍🔧" }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        Label {
            text: qsTr("员工信息列表（%1 人）").arg(employeeModel.count)
            font.pixelSize: 20
            font.bold: true
            color: "#2c3e50"
            Layout.alignment: Qt.AlignHCenter
        }

        RowLayout {
            Layout.fillWidth: true

            TextField {
                id: employeeNameField
                objectName: "employeeNameField"
                Layout.fillWidth: true
                placeholderText: qsTr("新员工姓名")
            }

            TextField {
                id: employeeRoleField
                Layout.fillWidth: true
                placeholderText: qsTr("职位")
            }

            Button {
                text: qsTr("添加")
                onClicked: {
                    root.addEmployee(employeeNameField.text, employeeRoleField.text)
                    employeeNameField.clear()
                    employeeRoleField.clear()
                }
            }

            Button {
                text: qsTr("删除末项")
                enabled: employeeModel.count > 0
                onClicked: root.removeLastEmployee()
            }
        }

        Frame {
            Layout.fillWidth: true
            Layout.fillHeight: true
            background: Rectangle {
                color: "white"
                radius: 8
                border.color: "#bdc3c7"
            }

            ListView {
                id: employeeListView
                objectName: "employeeListView"
                anchors.fill: parent
                anchors.margins: 5
                model: employeeModel
                clip: true
                spacing: 2
                currentIndex: -1

                delegate: Rectangle {
                    width: employeeListView.width
                    height: 70
                    color: index === employeeListView.currentIndex
                           ? "#d6eaf8"
                           : (index % 2 === 0 ? "#f8f9fa" : "#ffffff")
                    radius: 5
                    border.color: "#e9ecef"

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 15

                        Text {
                            text: model.avatar
                            font.pixelSize: 30
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4

                            Text {
                                text: model.name
                                font.pixelSize: 16
                                font.bold: true
                                color: "#2c3e50"
                            }

                            Text {
                                text: model.jobTitle
                                font.pixelSize: 14
                                color: "#7f8c8d"
                            }
                        }

                        Button {
                            objectName: "employeeDetailButton_" + index
                            text: qsTr("查看详情")
                            onClicked: root.selectEmployeeAt(index)
                        }
                    }
                }

                ScrollBar.vertical: ScrollBar { }
            }
        }

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: root.selectedEmployee.length > 0
                  ? qsTr("当前员工：%1").arg(root.selectedEmployee)
                  : qsTr("请选择员工")
            color: "#34495e"
        }
    }
}
