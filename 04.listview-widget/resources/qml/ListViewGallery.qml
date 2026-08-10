import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "pages"

Item {
    id: root

    width: 1200
    height: 800

    property alias currentTab: tabBar.currentIndex
    readonly property int employeeCount: employeePage.employeeCount
    readonly property string selectedEmployee: employeePage.selectedEmployee

    Rectangle {
        anchors.fill: parent
        color: "#ecf0f1"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("ListView：列表、表格与树形结构")
            color: "#2c3e50"
            font.pixelSize: 28
            font.bold: true
        }

        TabBar {
            id: tabBar
            objectName: "listViewTabBar"
            Layout.fillWidth: true

            TabButton { text: qsTr("员工列表") }
            TabButton { text: qsTr("产品表格") }
            TabButton { text: qsTr("组织架构") }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: tabBar.currentIndex

            EmployeeListPage { id: employeePage }
            ProductTablePage { }
            OrganizationTreePage { }
        }
    }
}
