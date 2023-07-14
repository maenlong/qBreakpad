TEMPLATE = app
TARGET = qBreakPadTest

QT += core network
greaterThan(QT_MAJOR_VERSION, 4) {
    QT += widgets
}


#CONFIG -= app_bundle
#CONFIG += debug_and_release warn_on
#CONFIG += thread exceptions rtti stl

# without c++11 & AppKit library compiler can't solve address for symbols
CONFIG += c++11
macx: LIBS += -framework AppKit


# 让Release版本生成调试信息
QMAKE_CXXFLAGS_RELEASE = $$QMAKE_CFLAGS_RELEASE_WITH_DEBUGINFO
QMAKE_LFLAGS_RELEASE = $$QMAKE_LFLAGS_RELEASE_WITH_DEBUGINFO


############ for qBreakpad ############
# qBreakpad中需要使用到network模块
QT += network

# 启用多线程、异常、RTTI、STL支持
CONFIG += thread exceptions rtti stl

# without c++11 & AppKit library compiler can't solve address for symbols
CONFIG += c++11
macx: LIBS += -framework AppKit

# 配置头文件搜索路径和链接库路径
win32:CONFIG(release, debug|release): {
LIBS += -L$$PWD/qbreakpadlib/lib/release/ -lqBreakpad
DEPENDPATH += $$PWD/qbreakpadlib/lib/release
}
else:win32:CONFIG(debug, debug|release): {
LIBS += -L$$PWD/qbreakpadlib/lib/debug/ -lqBreakpad
DEPENDPATH += $$PWD/qbreakpadlib/lib/debug
}

INCLUDEPATH += $$PWD/qbreakpadlib/include

############ for qBreakpad ############




# source code
HEADERS += \
    $$PWD/qbreakpadlib/include/QBreakpadHandler.h \
    $$PWD/qbreakpadlib/include/QBreakpadHttpUploader.h \
    $$PWD/qbreakpadlib/include/singletone/call_once.h \
    $$PWD/qbreakpadlib/include/singletone/singleton.h \
    $$PWD/qbreakpadtestwgt.h

SOURCES += \
    $$PWD/main.cpp \
    $$PWD/qbreakpadtestwgt.cpp

FORMS += \
    $$PWD/qbreakpadtestwgt.ui

OBJECTS_DIR = _build/obj
MOC_DIR = _build
