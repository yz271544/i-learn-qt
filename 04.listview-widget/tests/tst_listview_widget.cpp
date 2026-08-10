#include <QFile>
#include <QQuickItem>
#include <QQuickView>
#include <QTest>
#include <QVariant>

namespace {

void prepareView(QQuickView &view, const QString &source)
{
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.resize(1000, 650);
    view.setSource(QUrl(source));
    QCOMPARE(view.status(), QQuickView::Ready);
}

} // namespace

class ListViewWidgetTest final : public QObject
{
    Q_OBJECT

private slots:
    void resourcesAreEmbedded();
    void employeeModelCanAppendAndRemove();
    void employeeSelectionUsesModelRole();
    void productTableReportsInventory();
    void treeRootCanCollapseAndExpand();
};

void ListViewWidgetTest::resourcesAreEmbedded()
{
    const QStringList resources {
        QStringLiteral(":/qml/main.qml"),
        QStringLiteral(":/qml/ListViewGallery.qml"),
        QStringLiteral(":/qml/pages/EmployeeListPage.qml"),
        QStringLiteral(":/qml/pages/ProductTablePage.qml"),
        QStringLiteral(":/qml/pages/OrganizationTreePage.qml")
    };
    for (const QString &resource : resources) {
        QVERIFY2(QFile::exists(resource), qPrintable(resource));
    }
}

void ListViewWidgetTest::employeeModelCanAppendAndRemove()
{
    QQuickView view;
    prepareView(view, QStringLiteral("qrc:/qml/pages/EmployeeListPage.qml"));
    auto *page = view.rootObject();
    QCOMPARE(page->property("employeeCount").toInt(), 5);

    QVERIFY(QMetaObject::invokeMethod(
        page,
        "addEmployee",
        Q_ARG(QVariant, QVariant(QStringLiteral("孙八"))),
        Q_ARG(QVariant, QVariant(QStringLiteral("架构师")))));
    QTRY_COMPARE(page->property("employeeCount").toInt(), 6);

    QVariant lastName;
    QVERIFY(QMetaObject::invokeMethod(
        page,
        "employeeNameAt",
        Q_RETURN_ARG(QVariant, lastName),
        Q_ARG(QVariant, QVariant(5))));
    QCOMPARE(lastName.toString(), QStringLiteral("孙八"));

    QVERIFY(QMetaObject::invokeMethod(page, "removeLastEmployee"));
    QTRY_COMPARE(page->property("employeeCount").toInt(), 5);
}

void ListViewWidgetTest::employeeSelectionUsesModelRole()
{
    QQuickView view;
    prepareView(view, QStringLiteral("qrc:/qml/pages/EmployeeListPage.qml"));
    auto *page = view.rootObject();

    QVERIFY(QMetaObject::invokeMethod(
        page,
        "selectEmployeeAt",
        Q_ARG(QVariant, QVariant(0))));

    QCOMPARE(
        page->property("selectedEmployee").toString(),
        QStringLiteral("张三"));
}

void ListViewWidgetTest::productTableReportsInventory()
{
    QQuickView view;
    prepareView(view, QStringLiteral("qrc:/qml/pages/ProductTablePage.qml"));
    auto *page = view.rootObject();
    QCOMPARE(page->property("productCount").toInt(), 5);

    QVariant lowStockCount;
    QVERIFY(QMetaObject::invokeMethod(
        page,
        "lowStockCount",
        Q_RETURN_ARG(QVariant, lowStockCount)));
    QCOMPARE(lowStockCount.toInt(), 3);

    QVariant firstStock;
    QVERIFY(QMetaObject::invokeMethod(
        page,
        "stockAt",
        Q_RETURN_ARG(QVariant, firstStock),
        Q_ARG(QVariant, QVariant(0))));
    QCOMPARE(firstStock.toInt(), 45);
}

void ListViewWidgetTest::treeRootCanCollapseAndExpand()
{
    QQuickView view;
    prepareView(view, QStringLiteral("qrc:/qml/pages/OrganizationTreePage.qml"));
    auto *page = view.rootObject();
    QCOMPARE(page->property("visibleNodeCount").toInt(), 6);
    QVERIFY(page->property("organizationExpanded").toBool());

    QVERIFY(QMetaObject::invokeMethod(
        page,
        "toggleNode",
        Q_ARG(QVariant, QVariant(0))));
    QVERIFY(!page->property("organizationExpanded").toBool());
    QCOMPARE(page->property("visibleNodeCount").toInt(), 1);

    QVERIFY(QMetaObject::invokeMethod(
        page,
        "toggleNode",
        Q_ARG(QVariant, QVariant(0))));
    QVERIFY(page->property("organizationExpanded").toBool());
    QCOMPARE(page->property("visibleNodeCount").toInt(), 6);
}

QTEST_MAIN(ListViewWidgetTest)

#include "tst_listview_widget.moc"
