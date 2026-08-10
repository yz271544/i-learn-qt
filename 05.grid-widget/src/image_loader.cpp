#include "image_loader.h"

#include <QDateTime>
#include <QDir>
#include <QFileInfo>
#include <QFileInfoList>
#include <QSet>
#include <QtGlobal>

ImageLoader::ImageLoader(QObject *parent)
    : QObject(parent)
{
}

QString ImageLoader::currentFolder() const
{
    return m_currentFolder;
}

bool ImageLoader::loadImages(const QString &folderPath)
{
    const QDir directory(folderPath);
    if (!directory.exists()) {
        qWarning("图片文件夹不存在: %s", qPrintable(folderPath));
        return false;
    }

    setCurrentFolder(directory.dirName());

    const QFileInfoList files = directory.entryInfoList(
        QDir::Files,
        QDir::Name | QDir::IgnoreCase);
    for (const QFileInfo &file : files) {
        if (isSupportedImage(file.absoluteFilePath())) {
            publishImage(file.absoluteFilePath());
        }
    }
    return true;
}

bool ImageLoader::loadSingleImage(const QString &filePath)
{
    const QFileInfo fileInfo(filePath);
    if (!fileInfo.exists() || !fileInfo.isFile() || !isSupportedImage(filePath)) {
        qWarning("图片文件不存在或格式不受支持: %s", qPrintable(filePath));
        return false;
    }

    setCurrentFolder(QStringLiteral("单个文件"));
    publishImage(fileInfo.absoluteFilePath());
    return true;
}

QString ImageLoader::formatFileSize(qint64 bytes) const
{
    const qint64 safeBytes = qMax<qint64>(0, bytes);
    if (safeBytes < 1024) {
        return QStringLiteral("%1 B").arg(safeBytes);
    }
    if (safeBytes < 1024 * 1024) {
        return QStringLiteral("%1 KB").arg(safeBytes / 1024.0, 0, 'f', 1);
    }
    return QStringLiteral("%1 MB").arg(
        safeBytes / (1024.0 * 1024.0), 0, 'f', 1);
}

bool ImageLoader::isSupportedImage(const QString &filePath) const
{
    static const QSet<QString> supportedExtensions {
        QStringLiteral("jpg"),
        QStringLiteral("jpeg"),
        QStringLiteral("png"),
        QStringLiteral("bmp"),
        QStringLiteral("gif"),
        QStringLiteral("webp")
    };
    return supportedExtensions.contains(QFileInfo(filePath).suffix().toLower());
}

void ImageLoader::publishImage(const QString &filePath)
{
    const QFileInfo fileInfo(filePath);
    emit imageFound(
        fileInfo.fileName(),
        QUrl::fromLocalFile(fileInfo.absoluteFilePath()),
        formatFileSize(fileInfo.size()),
        fileInfo.lastModified().toString(QStringLiteral("yyyy-MM-dd hh:mm:ss")));
}

void ImageLoader::setCurrentFolder(const QString &folderName)
{
    if (m_currentFolder == folderName) {
        // Re-loading the same folder must still clear the QML model first.
        emit currentFolderChanged();
        return;
    }
    m_currentFolder = folderName;
    emit currentFolderChanged();
}
