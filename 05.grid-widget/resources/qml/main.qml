import QtQuick 2.12
import QtQuick.Controls 2.12

ApplicationWindow {
    width: 1100
    height: 760
    minimumWidth: 760
    minimumHeight: 560
    visible: true
    title: qsTr("05.grid-widget - GridView 图片浏览器")

    ImageGridGallery {
        anchors.fill: parent
        loader: imageLoader
    }
}
