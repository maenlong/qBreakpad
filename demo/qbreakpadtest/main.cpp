#include <QApplication>
#include "QBreakpadHandler.h"
#include "qbreakpadtestwgt.h"

int main (int argc, char *argv[])
{
    QApplication app (argc, argv);

     QBreakpadInstance.setDumpPath("./crashes");    // 设置生成dump文件路径

    qBreakpadTestWgt *pWgt = new qBreakpadTestWgt;
    pWgt->show();

    return app.exec();
}
