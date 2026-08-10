import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    id: root

    width: 1100
    height: 760

    property var loader: null
    property alias currentIndex: gridView.currentIndex
    readonly property int imageCount: imageModel.count
    property int selectedCount: 0
    property int previewIndex: -1
    property string previewName: ""
    property url previewSource: ""
    property string currentFolder: qsTr("内置示例")

    function recalculateSelectedCount() {
        var count = 0
        for (var row = 0; row < imageModel.count; ++row) {
            if (imageModel.get(row).selected)
                ++count
        }
        selectedCount = count
    }

    function selectIndex(row) {
        if (row < 0 || row >= imageModel.count)
            return false
        imageModel.setProperty(row, "selected", !imageModel.get(row).selected)
        gridView.currentIndex = row
        recalculateSelectedCount()
        return true
    }

    function setPreviewIndex(row) {
        if (row < 0 || row >= imageModel.count)
            return false
        previewIndex = row
        previewName = imageModel.get(row).name
        previewSource = imageModel.get(row).source
        return true
    }

    function openPreview(row) {
        if (setPreviewIndex(row))
            previewDialog.open()
    }

    function previousImage() {
        if (previewIndex > 0)
            setPreviewIndex(previewIndex - 1)
    }

    function nextImage() {
        if (previewIndex >= 0 && previewIndex < imageModel.count - 1)
            setPreviewIndex(previewIndex + 1)
    }

    function clearImages(folderName) {
        imageModel.clear()
        currentFolder = folderName
        selectedCount = 0
        gridView.currentIndex = -1
        previewIndex = -1
        previewName = ""
        previewSource = ""
    }

    function addImage(name, sourceUrl, size, modified) {
        imageModel.append({
            "name": name,
            "source": sourceUrl,
            "fileSize": size,
            "modified": modified,
            "selected": false
        })
    }

    ListModel {
        id: imageModel
        ListElement { name: "蓝色海湾"; source: "qrc:/assets/blue.svg"; fileSize: "示例"; modified: "SVG"; selected: false }
        ListElement { name: "绿色山丘"; source: "qrc:/assets/green.svg"; fileSize: "示例"; modified: "SVG"; selected: false }
        ListElement { name: "橙色日落"; source: "qrc:/assets/orange.svg"; fileSize: "示例"; modified: "SVG"; selected: false }
        ListElement { name: "紫色星空"; source: "qrc:/assets/purple.svg"; fileSize: "示例"; modified: "SVG"; selected: false }
        ListElement { name: "红色花园"; source: "qrc:/assets/red.svg"; fileSize: "示例"; modified: "SVG"; selected: false }
        ListElement { name: "青色湖面"; source: "qrc:/assets/teal.svg"; fileSize: "示例"; modified: "SVG"; selected: false }
    }

    Connections {
        target: root.loader
        ignoreUnknownSignals: true

        function onCurrentFolderChanged() {
            root.clearImages(root.loader.currentFolder)
        }

        function onImageFound(name, sourceUrl, fileSize, modified) {
            root.addImage(name, sourceUrl, fileSize, modified)
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#ecf0f1"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("GridView 图片浏览器")
            color: "#2c3e50"
            font.pixelSize: 28
            font.bold: true
        }

        RowLayout {
            Layout.fillWidth: true

            TextField {
                id: folderField
                objectName: "folderField"
                Layout.fillWidth: true
                placeholderText: qsTr("输入图片文件夹路径，例如 /home/user/Pictures")
            }

            Button {
                text: qsTr("扫描文件夹")
                enabled: root.loader !== null && folderField.text.length > 0
                onClicked: root.loader.loadImages(folderField.text)
            }
        }

        Label {
            Layout.fillWidth: true
            text: qsTr("位置：%1　图片：%2　已选择：%3")
                .arg(root.currentFolder)
                .arg(imageModel.count)
                .arg(root.selectedCount)
            color: "#34495e"
        }

        GridView {
            id: gridView
            objectName: "imageGridView"
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: imageModel
            cellWidth: 200
            cellHeight: 220
            clip: true
            currentIndex: -1

            delegate: ImageCard {
                imageName: model.name
                imageSource: model.source
                fileSize: model.fileSize
                modified: model.modified
                selected: model.selected
                onClicked: root.selectIndex(index)
                onPreviewRequested: root.openPreview(index)
            }

            ScrollBar.vertical: ScrollBar { }
        }
    }

    Dialog {
        id: previewDialog
        parent: Overlay.overlay
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: Math.min(760, parent.width - 40)
        height: Math.min(580, parent.height - 40)
        modal: true
        title: root.previewName
        standardButtons: Dialog.Close

        contentItem: ColumnLayout {
            spacing: 10

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#2c3e50"
                radius: 6

                Image {
                    anchors.fill: parent
                    anchors.margins: 10
                    source: root.previewSource
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                Button {
                    text: qsTr("上一张")
                    enabled: root.previewIndex > 0
                    onClicked: root.previousImage()
                }
                Label {
                    text: root.previewIndex >= 0
                          ? qsTr("%1 / %2").arg(root.previewIndex + 1).arg(imageModel.count)
                          : ""
                }
                Button {
                    text: qsTr("下一张")
                    enabled: root.previewIndex >= 0 && root.previewIndex < imageModel.count - 1
                    onClicked: root.nextImage()
                }
            }
        }
    }
}
