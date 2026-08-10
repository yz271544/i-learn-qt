#include <QCommandLineOption>
#include <QCommandLineParser>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QTimer>
#include <QUrl>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QGuiApplication::setApplicationName(QStringLiteral("Qt5 02 Project Layout"));
    QGuiApplication::setApplicationVersion(QStringLiteral("0.1.0"));

    QCommandLineParser parser;
    parser.setApplicationDescription(QStringLiteral("Qt Quick 工程结构教学示例"));
    parser.addHelpOption();
    parser.addVersionOption();

    const QCommandLineOption smokeTestOption(
        QStringLiteral("smoke-test"),
        QStringLiteral("加载主 QML 后自动退出。"));
    parser.addOption(smokeTestOption);
    parser.process(app);

    QQmlApplicationEngine engine;
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
