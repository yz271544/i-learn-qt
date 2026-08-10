#include "backend.h"

Backend::Backend(QObject *parent)
    : QObject(parent)
    , m_statusText(QStringLiteral("C++ 后端已就绪"))
{
}

int Backend::clickCount() const
{
    return m_clickCount;
}

QString Backend::statusText() const
{
    return m_statusText;
}

void Backend::recordClick()
{
    ++m_clickCount;
    emit clickCountChanged();
    updateStatusText();
}

void Backend::reset()
{
    if (m_clickCount == 0) {
        return;
    }

    m_clickCount = 0;
    emit clickCountChanged();
    updateStatusText();
}

void Backend::updateStatusText()
{
    m_statusText = m_clickCount == 0
        ? QStringLiteral("计数已由 C++ 后端清零")
        : QStringLiteral("C++ 后端已收到第 %1 次点击").arg(m_clickCount);
    emit statusTextChanged();
}
