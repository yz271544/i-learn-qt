#pragma once

#include <QObject>
#include <QString>
#include <QUrl>

class ImageLoader final : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentFolder READ currentFolder NOTIFY currentFolderChanged)

public:
    explicit ImageLoader(QObject *parent = nullptr);

    QString currentFolder() const;

    Q_INVOKABLE bool loadImages(const QString &folderPath);
    Q_INVOKABLE bool loadSingleImage(const QString &filePath);
    Q_INVOKABLE QString formatFileSize(qint64 bytes) const;

signals:
    void currentFolderChanged();
    void imageFound(
        const QString &name,
        const QUrl &sourceUrl,
        const QString &fileSize,
        const QString &modified);

private:
    bool isSupportedImage(const QString &filePath) const;
    void publishImage(const QString &filePath);
    void setCurrentFolder(const QString &folderName);

    QString m_currentFolder = QStringLiteral("未选择文件夹");
};
