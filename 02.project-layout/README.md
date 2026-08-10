# 02.project-layout：认识 Qt Quick 工程结构

本模块参考[开源 C++ QT QML 开发（二）工程结构](https://blog.csdn.net/ajassi2000/article/details/152506055?spm=1011.2124.3001.6209)，复现文章中“点击矩形切换颜色”的程序，并增加组件拆分与自动化交互测试。

## 学习目标

完成本节后，你应该能回答：

1. 构建文件、C++ 入口、资源清单和 QML 界面分别负责什么？
2. 为什么 `qrc:/qml/main.qml` 不依赖当前工作目录？
3. QML 加载失败时，程序如何返回失败状态？
4. 怎样为 QML 的点击行为编写自动化测试？

## 目录结构

```text
02.project-layout/
├── CMakeLists.txt                     # 本仓库实际使用的 CMake 构建文件
├── qt5_02_project_layout.pro          # 对照文章保留的 qmake 构建文件
├── src/
│   └── main.cpp                       # C++ 程序入口
├── resources/
│   ├── qml.qrc                        # Qt 资源清单
│   └── qml/
│       ├── main.qml                   # 顶层窗口
│       └── ToggleCard.qml             # 可测试的颜色切换组件
└── tests/
    └── tst_project_layout.cpp         # Qt Test 资源与鼠标交互测试
```

文章展示了最小工程的四类文件。本模块将 `main.qml` 中的矩形拆为 `ToggleCard.qml`，这是工程变大后常见的组织方式，也让测试可以只加载目标组件。

## 四类核心文件

### 1. 构建文件

文章使用 `.pro` 和 qmake：`QT += quick` 声明 Qt 模块，`SOURCES` 与 `RESOURCES` 声明参与构建的文件。本仓库使用 CMake，对应关系如下：

| qmake | CMake |
| --- | --- |
| `QT += quick` | `target_link_libraries(... Qt5::Quick)` |
| `SOURCES += src/main.cpp` | `add_executable(... src/main.cpp)` |
| `RESOURCES += resources/qml.qrc` | 将 `resources/qml.qrc` 加入 `add_executable` |

### 2. `main.cpp`

入口按顺序创建 `QGuiApplication`、创建 `QQmlApplicationEngine`、连接加载失败处理、加载 `qrc:/qml/main.qml`，最后进入事件循环。

适合练习断点的位置：

- `engine.load(mainQmlUrl)` 前：观察 URL 与引擎状态。
- `objectCreated` 回调内：把 QML 路径故意写错，观察失败分支。
- `return app.exec()` 前：理解 GUI 事件循环从这里开始。

### 3. `qml.qrc`

`.qrc` 是 XML 资源清单。构建时 QML 被编译进可执行文件，运行时通过 `qrc:/...` URL 读取，因此不需要把零散 QML 文件复制到程序旁边。

### 4. QML 文件

`main.qml` 创建顶层窗口和状态栏；`ToggleCard.qml` 封装矩形、文本与鼠标事件。点击时 `switched` 属性取反，QML 属性绑定会自动更新颜色和文字。

## 构建、运行和测试

在项目根目录执行：

```bash
cmake -S . -B build
cmake --build build
./build/02.project-layout/qt5_02_project_layout
ctest --test-dir build --output-on-failure
```

测试分为两层：

- `02.project-layout.smoke`：离屏启动完整应用，确认主 QML 可以加载。
- `02.project-layout.qml-interaction`：检查资源已嵌入，加载 `ToggleCard`，模拟一次鼠标点击，并验证颜色、状态与 `clicked` 信号。

## 建议练习

1. 临时把 `mainQmlUrl` 改成不存在的路径，运行冒烟测试并阅读错误输出，然后恢复。
2. 在 `.qrc` 中删除 `ToggleCard.qml`，观察构建或运行阶段的报错位置，然后恢复。
3. 给 `ToggleCard` 增加第三种颜色，并修改测试覆盖三次点击。
4. 在 Qt Creator 中给 `onClicked` 和 `engine.load` 附近加断点，分别练习 QML 与 C++ 调试。
