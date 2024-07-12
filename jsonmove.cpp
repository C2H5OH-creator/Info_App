#include "jsonmove.h"
#include <QObject>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>


//Класс для передачи данных из JSON-файла для мини-редактора
JsonMove::JsonMove(QObject *parent) : QObject(parent)
{
}

QString JsonMove::text() const
{
    return m_text;
}

//Запись текста из файла в переменную
void JsonMove::setText(const QString &text)
{
    if (text != m_text) {
        m_text = text;
        emit textChanged();
    }
}

//Сохранение JSON-файла
bool JsonMove::saveJsonToFile(const QString &filePath)
{
    // Парсинг JSON из строки
    QJsonDocument doc = QJsonDocument::fromJson(m_text.toUtf8());

    // Запись JSON в файл
    QFile file(filePath);
    if (!file.open(QFile::WriteOnly | QFile::Text)) {
        qWarning() << "Could not open file for writing:" << filePath;
        return false;
    }

    file.write(doc.toJson());
    file.close();

    qDebug() << "JSON saved to file:" << filePath;
    return true;
}
