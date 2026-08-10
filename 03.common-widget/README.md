# 03.common-widget：Qt Quick 常用控件

本模块参考[开源 C++ QT QML 开发（三）常用控件](https://blog.csdn.net/ajassi2000/article/details/152522153?spm=1011.2124.3001.6209)，用四个标签页集中演示文本、按钮、输入、选择、布局、容器和高级控件。

## 学习目标

1. 区分 `TextInput`/`TextEdit` 与 `TextField`/`TextArea`。
2. 理解控件属性、信号处理器和属性绑定。
3. 使用 `RowLayout`、`ColumnLayout`、`GridLayout` 组织自适应界面。
4. 使用 `TabBar` 与 `SwipeView` 构建多页界面。
5. 用 Qt Test 模拟鼠标操作，验证 QML 控件状态。

## 目录结构

```text
03.common-widget/
├── CMakeLists.txt
├── src/main.cpp
├── resources/
│   ├── qml.qrc
│   └── qml/
│       ├── main.qml
│       ├── CommonWidgetGallery.qml
│       └── pages/
│           ├── BasicControlsPage.qml
│           ├── InputControlsPage.qml
│           ├── SelectionLayoutPage.qml
│           └── AdvancedControlsPage.qml
└── tests/tst_common_widget.cpp
```

`main.qml` 只负责窗口；`CommonWidgetGallery.qml` 负责导航和公共状态；每类控件放在独立页面中。这展示了界面从单文件示例演进为可维护工程的过程。

## 控件速查

| 分类 | 本例控件 | 要点 |
| --- | --- | --- |
| 文本 | `Text`、`TextInput`、`TextEdit` | 轻量显示与编辑元素 |
| 按钮 | `Button`、`RoundButton`、`ToolButton` | 通过 `onClicked` 响应操作 |
| 选择 | `CheckBox`、`RadioButton`、`ComboBox`、`Switch` | 使用 `checked`、`currentIndex` 等状态属性 |
| 输入 | `TextField`、`TextArea`、`SpinBox`、`Slider` | Controls 提供完整交互和样式 |
| 布局 | `RowLayout`、`ColumnLayout`、`GridLayout` | 使用 `Layout.*` 附加属性分配空间 |
| 容器 | `Page`、`GroupBox`、`ScrollView`、`TabBar`、`SwipeView` | 组织内容、滚动和页面导航 |
| 高级 | `Dialog`、`Menu`、`ProgressBar`、`BusyIndicator` | 弹层、菜单和过程反馈 |

## 属性、绑定与信号

以 `Switch` 为例：

```qml
Switch {
    checked: true
    onToggled: root.actionTriggered(checked ? "开关：开启" : "开关：关闭")
}
```

- `checked` 保存控件状态。
- 用户点击后控件发出 `toggled` 信号。
- `onToggled` 是对应的信号处理器。
- 其他控件可以通过 `text: someSwitch.checked` 绑定该状态，并自动刷新。

## 构建、运行和测试

在项目根目录执行：

```bash
cmake -S . -B build
cmake --build build
./build/03.common-widget/qt5_03_common_widget
ctest --test-dir build --output-on-failure
```

本模块提供两层测试：

- `03.common-widget.smoke`：离屏加载完整应用，捕获导入错误、资源遗漏和 QML 语法错误。
- `03.common-widget.interaction`：检查资源，模拟普通按钮、复选框和开关点击，并验证标签页与进度值。

测试通过 `objectName` 查找目标控件。`id` 只在 QML 文件内部有效，而 `objectName` 可以被 C++ 的 QObject 对象树访问。

## 建议练习

1. 给 `TextField` 增加 `IntValidator`，只允许输入数字。
2. 使用 `ButtonGroup` 给单选按钮增加第三个选项，并在底部状态栏显示选择结果。
3. 将 `Slider` 与 `ProgressBar` 绑定，观察一处状态驱动多处界面。
4. 新增一个第五页，练习 `StackView` 页面入栈和返回。
5. 为 `ComboBox` 补充自动化选择测试。
