#ifndef QBREAKPADTESTWGT_H
#define QBREAKPADTESTWGT_H

#include <QWidget>

namespace Ui {
class qBreakpadTestWgt;
}

class qBreakpadTestWgt : public QWidget
{
    Q_OBJECT

public:
    explicit qBreakpadTestWgt(QWidget *parent = nullptr);
    ~qBreakpadTestWgt();

private slots:
    void on_pushButton_clicked();

private:
    Ui::qBreakpadTestWgt *ui;
};

#endif // QBREAKPADTESTWGT_H
