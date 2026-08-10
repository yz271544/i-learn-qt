#include <QColor>
#include <QFile>
#include <QQuickItem>
#include <QQuickView>
#include <QSignalSpy>
#include <QTest>

class ProjectLayoutTest final : public QObject
{
    Q_OBJECT

private slots:
    void resourcesAreEmbedded();
    void cardStartsInBlueState();
    void mouseClickTogglesCard();
};

void ProjectLayoutTest::resourcesAreEmbedded()
{
    QVERIFY2(QFile::exists(QStringLiteral(":/qml/main.qml")),
             "main.qml should be compiled into the Qt resource system");
    QVERIFY2(QFile::exists(QStringLiteral(":/qml/ToggleCard.qml")),
             "ToggleCard.qml should be compiled into the Qt resource system");
}

void ProjectLayoutTest::cardStartsInBlueState()
{
    QQuickView view;
    view.setSource(QUrl(QStringLiteral("qrc:/qml/ToggleCard.qml")));

    QCOMPARE(view.status(), QQuickView::Ready);
    QVERIFY(view.rootObject());
    QCOMPARE(view.rootObject()->property("switched").toBool(), false);
    QCOMPARE(view.rootObject()->property("color").value<QColor>(), QColor("lightblue"));
}

void ProjectLayoutTest::mouseClickTogglesCard()
{
    QQuickView view;
    view.setResizeMode(QQuickView::SizeViewToRootObject);
    view.setSource(QUrl(QStringLiteral("qrc:/qml/ToggleCard.qml")));
    QCOMPARE(view.status(), QQuickView::Ready);

    auto *card = view.rootObject();
    QVERIFY(card);

    QSignalSpy clickedSpy(card, SIGNAL(clicked()));
    QVERIFY(clickedSpy.isValid());

    view.show();
    QTest::qWait(50);
    QTest::mouseClick(
        &view,
        Qt::LeftButton,
        Qt::NoModifier,
        QPoint(view.width() / 2, view.height() / 2));

    QTRY_COMPARE(card->property("switched").toBool(), true);
    QCOMPARE(card->property("color").value<QColor>(), QColor("lightgreen"));
    QCOMPARE(clickedSpy.count(), 1);
}

QTEST_MAIN(ProjectLayoutTest)

#include "tst_project_layout.moc"
