import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Page {
    id: root

    property bool organizationExpanded: true
    property int visibleNodeCount: treeModel.count
    property int revision: 0

    function parentCategoryIndex(row) {
        for (var index = row - 1; index >= 0; --index) {
            if (treeModel.get(index).depth === 1)
                return index
        }
        return -1
    }

    function isNodeVisible(row) {
        var node = treeModel.get(row)
        if (node.depth === 0)
            return true
        if (!treeModel.get(0).isExpanded)
            return false
        if (node.depth === 1)
            return true
        var parentRow = parentCategoryIndex(row)
        return parentRow >= 0 && treeModel.get(parentRow).isExpanded
    }

    function refreshVisibleCount() {
        var count = 0
        for (var row = 0; row < treeModel.count; ++row) {
            if (isNodeVisible(row))
                ++count
        }
        visibleNodeCount = count
    }

    function toggleNode(row) {
        var node = treeModel.get(row)
        if (!node.hasChildren)
            return
        var newExpanded = !node.isExpanded
        treeModel.setProperty(row, "isExpanded", newExpanded)
        if (row === 0)
            organizationExpanded = newExpanded
        revision += 1
        refreshVisibleCount()
    }

    ListModel {
        id: treeModel
        ListElement { name: "公司组织"; depth: 0; isExpanded: true; hasChildren: true; isCategory: true }
        ListElement { name: "技术部"; depth: 1; isExpanded: true; hasChildren: true; isCategory: true }
        ListElement { name: "开发工程师"; depth: 2; isExpanded: false; hasChildren: false; isCategory: false }
        ListElement { name: "测试工程师"; depth: 2; isExpanded: false; hasChildren: false; isCategory: false }
        ListElement { name: "产品部"; depth: 1; isExpanded: true; hasChildren: true; isCategory: true }
        ListElement { name: "产品经理"; depth: 2; isExpanded: false; hasChildren: false; isCategory: false }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        Label {
            text: qsTr("组织架构（当前显示 %1 个节点）").arg(root.visibleNodeCount)
            font.pixelSize: 20
            font.bold: true
            color: "#2c3e50"
            Layout.alignment: Qt.AlignHCenter
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
                id: treeView
                anchors.fill: parent
                anchors.margins: 5
                model: treeModel
                clip: true

                delegate: Rectangle {
                    width: treeView.width
                    height: visible ? 48 : 0
                    visible: root.revision >= 0 && root.isNodeVisible(index)
                    color: index % 2 === 0 ? "#f8f9fa" : "#ffffff"

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 10 + model.depth * 24
                        spacing: 8

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 18
                            text: model.hasChildren
                                  ? (model.isExpanded ? "▼" : "►")
                                  : "•"
                            color: "#3498db"
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: model.name
                            font.bold: model.isCategory
                            color: model.isCategory ? "#2c3e50" : "#5d6d7e"
                        }
                    }

                    MouseArea {
                        objectName: "treeNode_" + index
                        anchors.fill: parent
                        cursorShape: model.hasChildren ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: root.toggleNode(index)
                    }
                }
            }
        }
    }
}
