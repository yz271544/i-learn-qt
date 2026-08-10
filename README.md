# Qt5 学习项目

这是一个按主题拆分的 Qt5/C++/QML 学习工程。每个编号文件夹都是一个可以独立阅读的示例，并由根目录的 CMake 工程统一构建。

当前环境已验证使用 Qt 5.15.13；工程最低要求 Qt 5.12、CMake 3.16 和支持 C++17 的编译器。

## 构建和运行

```bash
cmake -S . -B build
cmake --build build
./build/01.base/qt5_01_base
```

运行自动化冒烟测试：

```bash
ctest --test-dir build --output-on-failure
```

也可以直接用 Qt Creator 打开根目录的 `CMakeLists.txt`，选择 Qt5 Kit 后构建运行。

## 学习目录

| 模块 | 内容 | 状态 |
| --- | --- | --- |
| `01.base` | Qt Quick 程序入口、QML 声明式界面、自定义组件、C++ 后端通信和动画 | 已完成 |
| `02.project-layout` | 工程组成、qmake/CMake 对照、资源系统、调试与 QML 交互测试 | 已完成 |
| `03.common-widget` | 常用控件、布局容器、多页导航、属性绑定与控件交互测试 | 已完成 |

后续模块可继续按 `02.xxx`、`03.xxx` 的形式添加，并在根 `CMakeLists.txt` 中使用 `add_subdirectory(...)` 接入。

## 参考资料

- [开源 C++ QT QML 开发（一）基本介绍](https://blog.csdn.net/ajassi2000/article/details/152457440?spm=1011.2124.3001.6209)

第一个示例把文章中的蓝色矩形、居中文本和鼠标悬停颜色动画整理成了一个可直接构建的 Qt5 工程。
