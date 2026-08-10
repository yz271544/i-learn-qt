import QtQuick 2.12
import QtQuick.Controls 2.12

ApplicationWindow {
    width: 960
    height: 700
    minimumWidth: 760
    minimumHeight: 560
    visible: true
    title: qsTr("03.common-widget - Qt Quick 常用控件")

    CommonWidgetGallery {
        anchors.fill: parent
    }
}
