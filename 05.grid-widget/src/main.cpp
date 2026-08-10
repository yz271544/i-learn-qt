#include <QCommandLineOption>
#include <QCommandLineParser>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTimer>
#include <QUrl>

#include "image_loader.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QGuiApplication::setApplicationName(QStringLiteral("Qt5 05 Grid Widget"));
    QGuiApplication::setApplicationVersion(QStringLiteral("0.1.0"));

    QCommandLineParser parser;
    parser.setApplicationDescription(QStringLiteral("Qt Quick GridView 图片浏览器教学示例"));
    parser.addHelpOption();
    parser.addVersionOption();

    const QCommandLineOption smokeTestOption(
        QStringLiteral("smoke-test"),
        QStringLiteral("加载 GridView 示例后自动退出。"));
    parser.addOption(smokeTestOption);
    parser.process(app);

    ImageLoader imageLoader;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(QStringLiteral("imageLoader"), &imageLoader);

    const QUrl mainQmlUrl(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [mainQmlUrl](QObject *object, const QUrl &objectUrl) {
            if (!object && objectUrl == mainQmlUrl) {
                QCoreApplication::exit(EXIT_FAILURE);
            }
        },
        Qt::QueuedConnection);

    engine.load(mainQmlUrl);
    if (engine.rootObjects().isEmpty()) {
        return EXIT_FAILURE;
    }

    if (parser.isSet(smokeTestOption)) {
        QTimer::singleShot(500, &app, &QCoreApplication::quit);
    }
    return app.exec();
}
