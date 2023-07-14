#include <QApplication>
#include <QDebug>

#include "QBreakpadHandler.h"
#include "qbreakpadtestwgt.h"

//onBreakpadCrash实现如下
void onBreakpadCrash(QString dumpPath)
{
    qInfo()<<"捕获到崩溃，现在准备调用发送dump文件到服务端程序~， dump文件路径是:"<<dumpPath;
    //todo ...
}

int main (int argc, char *argv[])
{
    QApplication app (argc, argv);

     QBreakpadInstance.setDumpPath("./crashes");    // 设置生成dump文件路径

     QBreakpadInstance.setCallbackMethod(&onBreakpadCrash);

    qBreakpadTestWgt *pWgt = new qBreakpadTestWgt;
    pWgt->show();

    return app.exec();
}

