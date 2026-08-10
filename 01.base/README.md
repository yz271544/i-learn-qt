# 01.base：Qt5/QML 基础

本模块对应入门阶段，目标是理解一个 Qt Quick 应用最小但完整的组成。

## 文件职责

- `src/main.cpp`：创建应用和 QML 引擎，并通过上下文属性暴露 C++ 后端。
- `src/backend.h/.cpp`：用 `Q_PROPERTY`、信号和 `Q_INVOKABLE` 与 QML 通信。
- `resources/qml/main.qml`：使用声明式语法描述窗口、文本、矩形与交互。
- `resources/qml/MyButton.qml`：封装可复用组件，并向外发出自定义 `clicked` 信号。
- `resources/qml.qrc`：把 QML 文件编译进可执行程序，运行时不依赖外部 QML 文件路径。
- `CMakeLists.txt`：声明模块源码及 Qt5 依赖。

## 这个例子展示了什么

1. `ApplicationWindow` 是顶层窗口。
2. `MouseArea` 接收悬停和点击事件。
3. `Behavior on color` 让颜色属性变化自动产生动画。
4. `MyButton.qml` 展示组件复用、属性别名和自定义信号。
5. `backend.clickCount` 把 QML 文本绑定到 C++ 的 `Q_PROPERTY`；C++ 发出通知信号后界面自动刷新。

## 建议练习

1. 修改窗口、卡片和文字的尺寸与颜色。
2. 把动画时长从 `200` 改为 `800`，观察交互差异。
3. 新增一个“清零”按钮，把 `clickCount` 设回 `0`。
4. 将卡片提取为独立的 `LearningCard.qml` 组件。
