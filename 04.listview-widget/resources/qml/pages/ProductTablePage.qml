import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Page {
    id: root

    readonly property int productCount: productModel.count

    function stockAt(row) {
        return Number(productModel.get(row).stock)
    }

    function lowStockCount() {
        var count = 0
        for (var row = 0; row < productModel.count; ++row) {
            if (Number(productModel.get(row).stock) < 50)
                ++count
        }
        return count
    }

    ListModel {
        id: productModel
        ListElement { product: "笔记本电脑"; category: "电子产品"; price: "¥5,999"; stock: 45 }
        ListElement { product: "无线鼠标"; category: "电子产品"; price: "¥199"; stock: 120 }
        ListElement { product: "机械键盘"; category: "电子产品"; price: "¥699"; stock: 78 }
        ListElement { product: "办公椅"; category: "家具"; price: "¥1,299"; stock: 23 }
        ListElement { product: "显示器"; category: "电子产品"; price: "¥2,499"; stock: 34 }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        Label {
            text: qsTr("产品库存表格（低库存 %1 项）").arg(root.lowStockCount())
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
                id: tableView
                objectName: "productTableView"
                anchors.fill: parent
                anchors.margins: 5
                model: productModel
                clip: true

                headerPositioning: ListView.OverlayHeader
                header: Row {
                    z: 2
                    width: tableView.width
                    height: 50
                    spacing: 1

                    Repeater {
                        model: [qsTr("产品名称"), qsTr("分类"), qsTr("价格"), qsTr("库存")]

                        Rectangle {
                            width: (tableView.width - 3) * [0.35, 0.25, 0.22, 0.18][index]
                            height: 50
                            color: "#34495e"

                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                color: "white"
                                font.bold: true
                            }
                        }
                    }
                }

                delegate: Row {
                    id: productRow
                    width: tableView.width
                    height: 50
                    spacing: 1
                    property int rowIndex: index
                    property var columnData: [model.product, model.category, model.price, model.stock]
                    property var columnRatios: [0.35, 0.25, 0.22, 0.18]

                    Repeater {
                        model: 4

                        Rectangle {
                            width: (tableView.width - 3) * productRow.columnRatios[index]
                            height: 50
                            color: productRow.rowIndex % 2 === 0 ? "#f8f9fa" : "#ffffff"
                            border.color: "#e9ecef"

                            Text {
                                anchors.centerIn: parent
                                text: productRow.columnData[index]
                                color: index === 2
                                       ? "#e74c3c"
                                       : (index === 3
                                          ? (Number(productRow.columnData[index]) < 50
                                             ? "#e67e22" : "#27ae60")
                                          : "#2c3e50")
                            }
                        }
                    }
                }

                ScrollBar.vertical: ScrollBar { }
            }
        }
    }
}
