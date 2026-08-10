# 05.grid-widget：GridView 图片浏览器

本模块参考[开源 C++ QT QML 开发（五）复杂控件——GridView](https://blog.csdn.net/ajassi2000/article/details/152551148?spm=1011.2124.3001.6209)，实现 C++ 文件扫描、QML 图片模型、网格委托、选择状态和预览导航。

## 学习目标

1. 理解 `GridView` 的模型、单元格和委托复用机制。
2. 用 `cellWidth`、`cellHeight` 控制网格密度。
3. 通过 C++ 信号把文件系统数据传给 QML。
4. 使用 `Connections` 更新 `ListModel`。
5. 实现单击选择、右键/双击预览、悬停动画和前后导航。
6. 分别测试 C++ 后端、QML 模型和导航边界。

## 目录结构

```text
05.grid-widget/
├── CMakeLists.txt
├── src/
│   ├── main.cpp
│   └── image_loader.h/.cpp
├── resources/
│   ├── qml.qrc
│   ├── assets/                     # 六张内置 SVG 教学图片
│   └── qml/
│       ├── main.qml
│       ├── ImageGridGallery.qml
│       └── ImageCard.qml
└── tests/tst_grid_widget.cpp
```

## 数据流

```text
文件夹路径
  → ImageLoader::loadImages()
  → imageFound(name, url, size, modified)
  → QML Connections
  → ListModel.append(...)
  → GridView 创建/复用 ImageCard 委托
```

`ImageLoader` 使用 `QDir` 和 `QFileInfo` 扫描 jpg、jpeg、png、bmp、gif、webp 文件。与文章中手工拼接 `file:///` 不同，本例让 C++ 生成 `QUrl::fromLocalFile()`，可以正确处理空格、中文和不同操作系统的路径。

## ImageLoader

- `currentFolder`：通过 `Q_PROPERTY` 暴露给 QML。
- `loadImages()`：扫描目录并按名称排序发布图片。
- `loadSingleImage()`：发布一个受支持的图片文件。
- `formatFileSize()`：将字节转换为 B、KB 或 MB。
- `imageFound`：携带名称、URL、大小和修改时间。

切换或重新加载目录时，后端先发出 `currentFolderChanged`。QML 收到后清空旧模型，再处理后续 `imageFound`，避免不同目录的数据混在一起。

## GridView 与委托

```qml
GridView {
    model: imageModel
    cellWidth: 200
    cellHeight: 220
    clip: true
    delegate: ImageCard { /* 当前模型角色 */ }
}
```

`GridView` 只为可见区域及缓存区域创建委托。不要依赖某个委托对象永远存在；选择状态应保存在模型角色中，本例使用 `selected` 角色。

`ImageCard.qml` 封装了缩略图、文件信息、选择边框和鼠标处理：

- 左键单击切换 `selected`。
- 右键或双击打开预览。
- 悬停时使用 `Behavior` 产生缩放动画。

## 运行

```bash
cmake -S . -B build
cmake --build build
./build/05.grid-widget/qt5_05_grid_widget
```

程序默认显示六张内置 SVG，因此可以立即观察网格效果。要查看本机图片，在顶部输入文件夹绝对路径并点击“扫描文件夹”。

## 测试

```bash
ctest --test-dir build --output-on-failure
```

测试覆盖：

- QML 与 SVG 是否进入资源系统。
- 文件大小格式化边界。
- 临时目录扫描、扩展名过滤和信号参数。
- 网格选择与取消选择。
- 预览上一张/下一张及首尾边界。
- 模型清空与追加。

## 建议练习

1. 增加图片名称搜索，只显示匹配项。
2. 增加 `cellWidth` 滑块，实时改变一行显示的图片数量。
3. 给选择状态增加“全选”和“清空选择”按钮。
4. 使用 `QImageReader` 获取图片宽高并作为新模型角色显示。
5. 把文件扫描放到工作线程，避免大型目录阻塞界面。
