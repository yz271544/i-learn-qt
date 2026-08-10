#include <QCommandLineOption>
#include <QCommandLineParser>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QTimer>
#include <QUrl>

#include <QQmlContext>

#include "backend.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QGuiApplication::setApplicationName(QStringLiteral("Qt5 01 Base"));
    QGuiApplication::setApplicationVersion(QStringLiteral("0.1.0"));

    QCommandLineParser parser;
    parser.setApplicationDescription(QStringLiteral("Qt5/QML 基础学习示例"));
    parser.addHelpOption();
    parser.addVersionOption();

    const QCommandLineOption smokeTestOption(
        QStringLiteral("smoke-test"),
        QStringLiteral("启动界面后自动退出，用于检查 QML 是否能正确加载。"));
    parser.addOption(smokeTestOption);
    parser.process(app);

    Backend backend;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(QStringLiteral("backend"), &backend);
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
