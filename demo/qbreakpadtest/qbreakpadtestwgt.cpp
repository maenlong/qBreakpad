#include "qbreakpadtestwgt.h"
#include "ui_qbreakpadtestwgt.h"

#include <QLabel>

qBreakpadTestWgt::qBreakpadTestWgt(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::qBreakpadTestWgt)
{
    ui->setupUi(this);
}

qBreakpadTestWgt::~qBreakpadTestWgt()
{
    delete ui;
}

void qBreakpadTestWgt::on_pushButton_clicked()
{
    QLabel *pLbl = nullptr;
    // 执行此句发生异常时，会自动生成dump文件
    pLbl->setText("Beng!");
}

