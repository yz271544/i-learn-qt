#include <QFile>
#include <QPointF>
#include <QQuickItem>
#include <QQuickView>
#include <QTest>

namespace {

void clickItem(QQuickView &view, QQuickItem *item)
{
    QVERIFY(item);
    const QPointF center = item->mapToScene(
        QPointF(item->width() / 2.0, item->height() / 2.0));
    QTest::mouseClick(
        &view,
        Qt::LeftButton,
        Qt::NoModifier,
        center.toPoint());
}

} // namespace

class CommonWidgetTest final : public QObject
{
    Q_OBJECT

private slots:
    void resourcesAreEmbedded();
    void ordinaryButtonReportsAction();
    void checkBoxAndSwitchToggle();
    void tabSelectionControlsSwipeView();
};

void CommonWidgetTest::resourcesAreEmbedded()
{
    const QStringList resources {
        QStringLiteral(":/qml/main.qml"),
        QStringLiteral(":/qml/CommonWidgetGallery.qml"),
        QStringLiteral(":/qml/pages/BasicControlsPage.qml"),
        QStringLiteral(":/qml/pages/InputControlsPage.qml"),
        QStringLiteral(":/qml/pages/SelectionLayoutPage.qml"),
        QStringLiteral(":/qml/pages/AdvancedControlsPage.qml")
    };

    for (const QString &resource : resources) {
        QVERIFY2(QFile::exists(resource), qPrintable(resource));
    }
}

void CommonWidgetTest::ordinaryButtonReportsAction()
{
    QQuickView view;
    view.setResizeMode(QQuickView::SizeViewToRootObject);
    view.setSource(QUrl(QStringLiteral("qrc:/qml/CommonWidgetGallery.qml")));
    QCOMPARE(view.status(), QQuickView::Ready);

    view.show();
    QTest::qWait(50);

    auto *root = view.rootObject();
    auto *button = root->findChild<QQuickItem *>(QStringLiteral("basicButton"));
    clickItem(view, button);

    QTRY_COMPARE(root->property("actionCount").toInt(), 1);
    QCOMPARE(root->property("lastAction").toString(), QStringLiteral("普通按钮"));
}

void CommonWidgetTest::checkBoxAndSwitchToggle()
{
    QQuickView galleryView;
    galleryView.setResizeMode(QQuickView::SizeViewToRootObject);
    galleryView.setSource(QUrl(QStringLiteral("qrc:/qml/CommonWidgetGallery.qml")));
    QCOMPARE(galleryView.status(), QQuickView::Ready);

    galleryView.show();
    QTest::qWait(50);

    auto *root = galleryView.rootObject();
    auto *checkBox = root->findChild<QQuickItem *>(QStringLiteral("basicCheckBox"));
    QVERIFY(checkBox->property("checked").toBool());
    clickItem(galleryView, checkBox);
    QTRY_VERIFY(!checkBox->property("checked").toBool());

    QQuickView selectionView;
    selectionView.resize(900, 520);
    selectionView.setSource(QUrl(QStringLiteral("qrc:/qml/pages/SelectionLayoutPage.qml")));
    QCOMPARE(selectionView.status(), QQuickView::Ready);
    selectionView.show();
    QTest::qWait(50);

    auto *selectionPage = selectionView.rootObject();
    auto *featureSwitch = selectionPage->findChild<QQuickItem *>(
        QStringLiteral("featureSwitch"));
    QVERIFY(featureSwitch->property("checked").toBool());
    clickItem(selectionView, featureSwitch);
    QTRY_VERIFY(!featureSwitch->property("checked").toBool());
}

void CommonWidgetTest::tabSelectionControlsSwipeView()
{
    QQuickView view;
    view.setSource(QUrl(QStringLiteral("qrc:/qml/CommonWidgetGallery.qml")));
    QCOMPARE(view.status(), QQuickView::Ready);

    auto *root = view.rootObject();
    QCOMPARE(root->property("currentTab").toInt(), 0);

    root->setProperty("currentTab", 3);
    QTRY_COMPARE(root->property("currentTab").toInt(), 3);

    auto *progressBar = root->findChild<QQuickItem *>(QStringLiteral("demoProgressBar"));
    QVERIFY(progressBar);
    QCOMPARE(progressBar->property("value").toDouble(), 0.65);
}

QTEST_MAIN(CommonWidgetTest)

#include "tst_common_widget.moc"
