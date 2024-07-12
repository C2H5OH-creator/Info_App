#ifndef JSONMOVE_H
#define JSONMOVE_H
#include <QObject>
#include <QString>

class JsonMove : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)

public:
    explicit JsonMove(QObject *parent = nullptr);

    QString text() const;
    void setText(const QString &text);

    Q_INVOKABLE bool saveJsonToFile(const QString &filePath);

signals:
    void textChanged();

private:
    QString m_text;
};

#endif // JSONMOVE_H

