#include <QFile>
#include <QQuickItem>
#include <QQuickView>
#include <QSignalSpy>
#include <QTemporaryDir>
#include <QTest>
#include <QVariant>

#include "image_loader.h"

namespace {

bool createFile(const QString &path, int byteCount)
{
    QFile file(path);
    if (!file.open(QIODevice::WriteOnly)) {
        return false;
    }
    return file.write(QByteArray(byteCount, 'x')) == byteCount;
}

void prepareGallery(QQuickView &view)
{
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.resize(1000, 700);
    view.setSource(QUrl(QStringLiteral("qrc:/qml/ImageGridGallery.qml")));
    QCOMPARE(view.status(), QQuickView::Ready);
}

bool invokeRowMethod(QObject *object, const char *method, int row)
{
    return QMetaObject::invokeMethod(
        object,
        method,
        Q_ARG(QVariant, QVariant(row)));
}

} // namespace

class GridWidgetTest final : public QObject
{
    Q_OBJECT

private slots:
    void resourcesAreEmbedded();
    void fileSizeFormatting_data();
    void fileSizeFormatting();
    void folderScanFiltersAndPublishesImages();
    void gridSelectionTogglesModelState();
    void previewNavigationStopsAtBounds();
    void gridModelCanClearAndAppend();
};

void GridWidgetTest::resourcesAreEmbedded()
{
    const QStringList resources {
        QStringLiteral(":/qml/main.qml"),
        QStringLiteral(":/qml/ImageGridGallery.qml"),
        QStringLiteral(":/qml/ImageCard.qml"),
        QStringLiteral(":/assets/blue.svg"),
        QStringLiteral(":/assets/teal.svg")
    };
    for (const QString &resource : resources) {
        QVERIFY2(QFile::exists(resource), qPrintable(resource));
    }
}

void GridWidgetTest::fileSizeFormatting_data()
{
    QTest::addColumn<qint64>("bytes");
    QTest::addColumn<QString>("formatted");
    QTest::newRow("bytes") << qint64(512) << QStringLiteral("512 B");
    QTest::newRow("kilobytes") << qint64(1536) << QStringLiteral("1.5 KB");
    QTest::newRow("megabytes") << qint64(1572864) << QStringLiteral("1.5 MB");
    QTest::newRow("negative") << qint64(-10) << QStringLiteral("0 B");
}

void GridWidgetTest::fileSizeFormatting()
{
    QFETCH(qint64, bytes);
    QFETCH(QString, formatted);
    const ImageLoader loader;
    QCOMPARE(loader.formatFileSize(bytes), formatted);
}

void GridWidgetTest::folderScanFiltersAndPublishesImages()
{
    QTemporaryDir directory;
    QVERIFY(directory.isValid());
    QVERIFY(createFile(directory.filePath(QStringLiteral("a.png")), 1024));
    QVERIFY(createFile(directory.filePath(QStringLiteral("B.JPG")), 2048));
    QVERIFY(createFile(directory.filePath(QStringLiteral("ignored.txt")), 64));

    ImageLoader loader;
    QSignalSpy folderSpy(&loader, &ImageLoader::currentFolderChanged);
    QSignalSpy imageSpy(&loader, &ImageLoader::imageFound);

    QVERIFY(loader.loadImages(directory.path()));
    QCOMPARE(folderSpy.count(), 1);
    QCOMPARE(imageSpy.count(), 2);
    QCOMPARE(loader.currentFolder(), QFileInfo(directory.path()).fileName());

    QStringList names;
    for (const QList<QVariant> &arguments : imageSpy) {
        names.append(arguments.at(0).toString());
        QVERIFY(arguments.at(1).toUrl().isLocalFile());
    }
    QVERIFY(names.contains(QStringLiteral("a.png")));
    QVERIFY(names.contains(QStringLiteral("B.JPG")));
    QVERIFY(!loader.loadImages(directory.filePath(QStringLiteral("missing"))));
}

void GridWidgetTest::gridSelectionTogglesModelState()
{
    QQuickView view;
    prepareGallery(view);
    auto *gallery = view.rootObject();
    QCOMPARE(gallery->property("imageCount").toInt(), 6);
    QCOMPARE(gallery->property("selectedCount").toInt(), 0);

    QVERIFY(invokeRowMethod(gallery, "selectIndex", 2));
    QCOMPARE(gallery->property("currentIndex").toInt(), 2);
    QCOMPARE(gallery->property("selectedCount").toInt(), 1);

    QVERIFY(invokeRowMethod(gallery, "selectIndex", 2));
    QCOMPARE(gallery->property("selectedCount").toInt(), 0);
}

void GridWidgetTest::previewNavigationStopsAtBounds()
{
    QQuickView view;
    prepareGallery(view);
    auto *gallery = view.rootObject();

    QVERIFY(invokeRowMethod(gallery, "setPreviewIndex", 2));
    QCOMPARE(gallery->property("previewIndex").toInt(), 2);
    QCOMPARE(gallery->property("previewName").toString(), QStringLiteral("橙色日落"));

    QVERIFY(QMetaObject::invokeMethod(gallery, "nextImage"));
    QCOMPARE(gallery->property("previewIndex").toInt(), 3);
    QVERIFY(QMetaObject::invokeMethod(gallery, "previousImage"));
    QCOMPARE(gallery->property("previewIndex").toInt(), 2);

    QVERIFY(invokeRowMethod(gallery, "setPreviewIndex", 0));
    QVERIFY(QMetaObject::invokeMethod(gallery, "previousImage"));
    QCOMPARE(gallery->property("previewIndex").toInt(), 0);

    QVERIFY(invokeRowMethod(gallery, "setPreviewIndex", 5));
    QVERIFY(QMetaObject::invokeMethod(gallery, "nextImage"));
    QCOMPARE(gallery->property("previewIndex").toInt(), 5);
}

void GridWidgetTest::gridModelCanClearAndAppend()
{
    QQuickView view;
    prepareGallery(view);
    auto *gallery = view.rootObject();

    QVERIFY(QMetaObject::invokeMethod(
        gallery,
        "clearImages",
        Q_ARG(QVariant, QVariant(QStringLiteral("测试目录")))));
    QCOMPARE(gallery->property("imageCount").toInt(), 0);
    QCOMPARE(gallery->property("currentFolder").toString(), QStringLiteral("测试目录"));

    QVERIFY(QMetaObject::invokeMethod(
        gallery,
        "addImage",
        Q_ARG(QVariant, QVariant(QStringLiteral("sample.png"))),
        Q_ARG(QVariant, QVariant(QUrl(QStringLiteral("qrc:/assets/blue.svg")))),
        Q_ARG(QVariant, QVariant(QStringLiteral("1.0 KB"))),
        Q_ARG(QVariant, QVariant(QStringLiteral("2026-08-10")))));
    QCOMPARE(gallery->property("imageCount").toInt(), 1);
}

QTEST_MAIN(GridWidgetTest)

#include "tst_grid_widget.moc"
