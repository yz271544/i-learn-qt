# 文章使用 qmake 的 .pro 文件；本仓库默认用根目录 CMakeLists.txt 构建。
QT += core gui qml quick

CONFIG += c++17 warnings
TEMPLATE = app
TARGET = qt5_02_project_layout

SOURCES += \
    src/main.cpp

RESOURCES += \
    resources/qml.qrc

DEFINES += QT_DEPRECATED_WARNINGS
