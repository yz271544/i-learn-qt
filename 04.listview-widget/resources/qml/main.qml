import QtQuick 2.12
import QtQuick.Controls 2.12

ApplicationWindow {
    width: 1200
    height: 800
    minimumWidth: 820
    minimumHeight: 600
    visible: true
    title: qsTr("04.listview-widget - ListView 复杂控件")

    ListViewGallery {
        anchors.fill: parent
    }
}
