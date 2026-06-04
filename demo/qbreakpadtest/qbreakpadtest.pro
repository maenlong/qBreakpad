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

# 根据平台 + 架构选择对应的预编译库
# 架构子目录约定：
#   windows : x86 / x64        （内部再分 debug / release）
#   mac     : x86_64 / arm64
#   linux   : x86_64 / arm64

# ---- Windows ----
win32 {
    contains(QT_ARCH, x86_64)|contains(QMAKE_TARGET.arch, x86_64) {
        QBREAKPAD_WIN_ARCH = x64
    } else {
        QBREAKPAD_WIN_ARCH = x86
    }
    CONFIG(release, debug|release) {
        QBREAKPAD_LIB_DIR = $$PWD/qbreakpadlib/lib/windows/$$QBREAKPAD_WIN_ARCH/release
    } else {
        QBREAKPAD_LIB_DIR = $$PWD/qbreakpadlib/lib/windows/$$QBREAKPAD_WIN_ARCH/debug
    }
    LIBS += -L$$QBREAKPAD_LIB_DIR -lqBreakpad
    DEPENDPATH += $$QBREAKPAD_LIB_DIR
}

# ---- macOS ----
macx {
    contains(QT_ARCH, arm64) {
        QBREAKPAD_LIB_DIR = $$PWD/qbreakpadlib/lib/mac/arm64
    } else {
        QBREAKPAD_LIB_DIR = $$PWD/qbreakpadlib/lib/mac/x86_64
    }
    LIBS += -L$$QBREAKPAD_LIB_DIR -lqBreakpad
    PRE_TARGETDEPS += $$QBREAKPAD_LIB_DIR/libqBreakpad.a
}

# ---- Linux ----
unix:!macx {
    contains(QT_ARCH, arm64)|contains(QT_ARCH, aarch64) {
        QBREAKPAD_LIB_DIR = $$PWD/qbreakpadlib/lib/linux/arm64
    } else {
        QBREAKPAD_LIB_DIR = $$PWD/qbreakpadlib/lib/linux/x86_64
    }
    LIBS += -L$$QBREAKPAD_LIB_DIR -lqBreakpad
    PRE_TARGETDEPS += $$QBREAKPAD_LIB_DIR/libqBreakpad.a
}

INCLUDEPATH += $$PWD/qbreakpadlib/include
DEPENDPATH += $$PWD/qbreakpadlib/include

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
