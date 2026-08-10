# 04.listview-widget：ListView 列表、表格与树形结构

本模块参考[开源 C++ QT QML 开发（四）复杂控件——ListView](https://blog.csdn.net/ajassi2000/article/details/152548381?spm=1011.2124.3001.6209)，分别演示普通列表、ListView 模拟表格和扁平模型模拟树形结构。

## 学习目标

1. 理解 QML 的 Model-View-Delegate 分工。
2. 使用 `ListModel`/`ListElement` 定义角色数据。
3. 使用 `append`、`remove` 和 `setProperty` 动态修改模型。
4. 理解委托中的 `index`、`model` 和角色属性。
5. 使用表头、`Repeater` 和统一列宽模拟表格。
6. 使用 `depth`、`hasChildren`、`isExpanded` 构造树形视觉效果。

## 目录结构

```text
04.listview-widget/
├── CMakeLists.txt
├── src/main.cpp
├── resources/
│   ├── qml.qrc
│   └── qml/
│       ├── main.qml
│       ├── ListViewGallery.qml
│       └── pages/
│           ├── EmployeeListPage.qml
│           ├── ProductTablePage.qml
│           └── OrganizationTreePage.qml
└── tests/tst_listview_widget.cpp
```

## Model、View 与 Delegate

```text
ListModel（数据） → ListView（滚动、复用、当前项） → delegate（每一行如何显示）
```

- Model 只描述数据，例如员工的 `name`、`jobTitle`、`avatar`。
- View 决定列表方向、滚动范围、当前索引和裁剪。
- Delegate 是模板；ListView 只为当前可见区域创建必要的委托对象。

委托中的 `index` 是当前行号，`model.name` 是当前数据项的 `name` 角色。不要把业务数据复制进委托局部变量，否则模型更新后界面可能无法自动刷新。

## 三个示例

### 1. 员工普通列表

`EmployeeListPage.qml` 演示：

- 奇偶行交替背景色。
- `currentIndex` 高亮当前员工。
- 运行时 `append` 和 `remove`。
- 委托按钮把模型角色传递给页面。
- 垂直 `ScrollBar`。

### 2. 产品表格

Qt 5 的 ListView 本质仍是一维列表。本例使用：

- `header` 创建固定表头。
- 行委托中的 `Repeater` 创建四列。
- `columnRatios` 让表头和数据使用相同宽度比例。
- 价格列使用红色，库存低于 50 时使用橙色。

这种方式适合列数固定的小表格；复杂排序、编辑或大量二维数据应考虑专门的表格模型与 TableView。

### 3. 组织树

模型仍是扁平列表，额外角色描述层次：

- `depth`：控制左侧缩进。
- `hasChildren`：决定显示箭头还是圆点。
- `isExpanded`：记录展开状态。
- `isCategory`：区分分类和叶子样式。

点击父节点时通过 `treeModel.setProperty(row, "isExpanded", ...)` 修改模型。`isNodeVisible()` 检查根节点和所属分类是否展开。

## 构建、运行和测试

在项目根目录执行：

```bash
cmake -S . -B build
cmake --build build
./build/04.listview-widget/qt5_04_listview_widget
ctest --test-dir build --output-on-failure
```

本模块测试覆盖：

- QML 文件是否全部进入资源系统。
- 员工模型能否新增、读取和删除。
- 按委托按钮使用的同一公开接口选中第一行，并验证模型角色为“张三”。
- 产品数量、首项库存和低库存统计。
- 调用树节点鼠标处理器共用的 `toggleNode()`，验证折叠与再次展开。

## 建议练习

1. 给员工模型增加 `department` 角色，并在委托中显示。
2. 增加“删除当前项”按钮，注意处理 `currentIndex === -1`。
3. 给产品页增加按库存排序；思考为什么大型数据更适合 C++ 模型。
4. 为组织树增加三级部门，并完善父节点查找逻辑。
5. 将员工数据迁移到继承 `QAbstractListModel` 的 C++ 类，为后续真实业务数据做准备。
