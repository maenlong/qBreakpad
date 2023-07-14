/*
 *  Copyright (C) 2009 Aleksey Palazhchenko
 *  Copyright (C) 2014 Sergey Shambir
 *  Copyright (C) 2016 Alexander Makarov
 *
 * This file is a part of Breakpad-qt library.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 */

#ifndef QBREAKPAD_HANDLER_H
#define QBREAKPAD_HANDLER_H

#include <QString>
#include <QUrl>
#include "singletone/singleton.h"

namespace google_breakpad {
    class ExceptionHandler;
    class MinidumpDescriptor;
}

class QBreakpadHandlerPrivate;

typedef void (*p_callbackFun)(QString);

class QBreakpadHandler: public QObject
{
    Q_OBJECT
public:
    static QString version();

    QBreakpadHandler();
    ~QBreakpadHandler();

    QString uploadUrl() const;
    QString dumpPath() const;
    QStringList dumpFileList() const;

    void setDumpPath(const QString& path);
    void setUploadUrl(const QUrl& url);

    //! 新增回调指针方法
    void setCallbackMethod(p_callbackFun  func){
        m_callfunc = func;
    };
    p_callbackFun  m_callfunc;
    //!

public slots:
    void sendDumps();

private:
    QBreakpadHandlerPrivate* d;
};
#define QBreakpadInstance Singleton<QBreakpadHandler>::instance()

#endif	// QBREAKPAD_HANDLER_H
