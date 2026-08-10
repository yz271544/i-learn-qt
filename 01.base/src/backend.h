#pragma once

#include <QObject>
#include <QString>

class Backend final : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int clickCount READ clickCount NOTIFY clickCountChanged)
    Q_PROPERTY(QString statusText READ statusText NOTIFY statusTextChanged)

public:
    explicit Backend(QObject *parent = nullptr);

    int clickCount() const;
    QString statusText() const;

    Q_INVOKABLE void recordClick();
    Q_INVOKABLE void reset();

signals:
    void clickCountChanged();
    void statusTextChanged();

private:
    void updateStatusText();

    int m_clickCount = 0;
    QString m_statusText;
};
