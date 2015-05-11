#include <QApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;

    engine.load(QUrl(QStringLiteral("qrc:/splashScreen.qml")));
    engine.addImportPath("/Users/andrey/Project/build_root/qml-libs/");

    return app.exec();
}
