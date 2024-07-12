#include <QCoreApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtWebEngineQuick/QtWebEngineQuick>
#include <QFile>
#include <QJsonDocument>
#include <QDebug>
#include "jsonmove.h"

//Получение данных из json-конфига
QVariantMap jsonParse(QString path){

    //Читаем файл
    QFile jsonFile(path);
    if(!jsonFile.open(QFile::ReadOnly | QFile::Text))
        qWarning("Ошибка при открытии Json файла");
    QString configContent = jsonFile.readAll();

    //Получаем информацию из файла
    QJsonDocument jsonConf = QJsonDocument::fromJson(configContent.toUtf8());
    QJsonObject jsonConfObj = jsonConf.object();
    QVariantMap jsonVariant;

    //Списываем в лист параметры строчек и колонок сетки
    if (jsonConfObj.contains("grid")) {
        QJsonObject gridObj = jsonConfObj["grid"].toObject();
        jsonVariant["rows"] = gridObj["rows"].toInt();
        jsonVariant["columns"] = gridObj["columns"].toInt();
    }

    //Списываем в лист параметры каждого фрейма
    if (jsonConfObj.contains("frames")) {
        QJsonArray framesArray = jsonConfObj["frames"].toArray();
        QVariantList framesList;
    foreach (const QJsonValue &frame, framesArray) {
        QJsonObject frameObj = frame.toObject();
        QVariantMap frameMap;

        frameMap["name"] = frameObj["name"].toString();
        frameMap["url"] = frameObj["url"].toString();
        frameMap["row"] = frameObj["row"].toInt();
        frameMap["column"] = frameObj["column"].toInt();
        framesList.append(frameMap);
        }

    jsonVariant["frames"] = framesList;

    }

    return jsonVariant;
}

int main(int argc, char *argv[])
{
    QtWebEngineQuick::initialize(); //Инициализируем WebEngine
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    JsonMove JsonMove;
    //Функция для своевременного обновления мини-редактора JSON-файлов
    auto reloadJsonData = [&]() {
        QVariantMap jsonData = jsonParse("grid_config.json");
        QJsonObject jsonObj = QJsonObject::fromVariantMap(jsonData);
        QJsonDocument jsonDoc(jsonObj);
        JsonMove.setText(jsonDoc.toJson(QJsonDocument::Indented));
        engine.rootContext()->setContextProperty("jsonData", jsonData); //Передаём данные в QML
    };

    reloadJsonData();

    engine.rootContext()->setContextProperty("JsonMove", &JsonMove);
    engine.load(QUrl(QStringLiteral("qrc:/Main.qml")));
    if (engine.rootObjects().isEmpty()) return -1;

    return app.exec();
}


