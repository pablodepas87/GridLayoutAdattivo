#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QList>
#include <QQmlContext>

class DataObject : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int cellSpan READ cellSpan WRITE setCellSpan NOTIFY cellSpanChanged)


};


int main(int argc, char *argv[])
{
#if defined(Q_OS_WIN)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QVariantList list;

    list.append(3);
    list.append(0);
    list.append(0);
    list.append(1);
    list.append(1);
    list.append(1);
    list.append(1);
    list.append(1);
    list.append(1);


    QQmlApplicationEngine engine;

   // engine.rootContext()->setContextProperty("lista",list);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
