#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QDebug>
#include <iomanip>
#include <QInputDialog>
#include <stack>
#include <QtQml/QQmlEngine>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlContext>
#include <QQuickView>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    countVertex = 1;
    QQuickView *view = new QQuickView();
    QQmlContext *context = view->rootContext();
    QWidget *container = QWidget::createWindowContainer(view, ui->tab_3);
    container->setMinimumSize(677,374);
    container->setMaximumSize(677,374);

    context->setContextProperty("window", this);
    container->setFocusPolicy(Qt::TabFocus);
    view->setSource(QUrl("qrc:/qml/main.qml"));

    emit setSizeMain(677, 374);

    // Темный дизайн =)
    QFile f(":/qdarkstyle/style.qss");
    if (!f.exists())
    {
        qDebug() << "Unable to set stylesheet, file not found\n";
    }
    else
    {
        f.open(QFile::ReadOnly | QFile::Text);
        QTextStream ts(&f);
        qApp->setStyleSheet(ts.readAll());
    }
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_pushButton_2_clicked()                          // Кнопка "Выставить"
{
    int count = ui->lineEdit->text().toInt();

    ui->tableWidget->setColumnCount(count);                     // Выставляем кол. столбцов
    ui->tableWidget->setRowCount(count);                        // Выставляем кол. строк

    graf = new int*[count];
    for(int col= 0; col < count; col++)
        graf[col] = new int[count];

    for(int row = 0; row < count; row++)
        for(int col = 0; col < count; col++)
        {
            graf[col][row] = 0;
            QTableWidgetItem* item = new QTableWidgetItem;
            item->setText(QString::number(0));
            ui->tableWidget->setItem(row, col, item);
        }

    topCount = count;
}

void MainWindow::on_pushButton_3_clicked()
{
    ui->tableWidget->clearContents();
}

void MainWindow::on_pushButton_clicked()
{
    for(int row = 0; row < topCount; row++)
        for(int col = 0; col < topCount; col++)
        {
            QTableWidgetItem* item = new QTableWidgetItem;
            item = ui->tableWidget->item(row, col);
            QString info = item->text();
            graf[col][row] = info.toInt();
        }
}

void MainWindow::on_pushButton_4_clicked()
{
    bool buttStartOk;
    int top = QInputDialog::getInt(0, "Ввод вершины", "Начальная вершина", 1, 1, topCount, 1, &buttStartOk) - 1;
    if(buttStartOk)
        dejkstr(top);
}

void MainWindow::dejkstr(int top)
{
    setMax();
    std::vector<int> visit(topCount), dist(topCount), last(topCount);
    for(int i = 0; i < topCount; i++)
    {
        visit[i] = -1;
        dist[i] = MAX;
        last[i] = top;
    }
    dist[top] = 0;
    int vertex = 0;
    int min = top;
    while(vertex < topCount)
    {
        int vertexIn = 0;
        std::vector<int> visitD(topCount);
        for(int tmp = 0; tmp < topCount; tmp++)
            visitD[tmp] = -1;

        while(vertexIn < topCount)
        {
            if(find_in_array(min, visit))
            {
                int minIn = find_min(graf, visitD, min);
                if(minIn >= 0 && min >= 0)
                {
                    int start =  dist[min];
                    int finish =  start + graf[minIn][min];
                    if(finish < dist[minIn])
                    {
                        dist[minIn] = finish;
                        last[minIn] = min;
                    }
                }
                visitD[vertexIn] = minIn;
            }
            vertexIn++;
        }
        visit[min] = min;
        ++vertex;
        if(vertex < topCount)
            min = find_min(dist, visit);
    }

    for(int i = 0; i < topCount; i++)
    if(i != top)
    {
        std::vector<int> out;
        out.insert(out.begin(), i + 1);
        int j = last[i];
        while(dist[j] != 0 && j != top)
        {
            out.insert(out.begin(), j + 1);
            j = last[j];
        }
        QString str = QString::number(top + 1);
        for(int outV = 0; outV < out.size(); outV++)
            str += " -> " + QString::number(out[outV]);
        str += " = " + QString::number(dist[i]);
        ui->listWidget->addItem(str);
    }
}

void MainWindow::floyd()                                            // Алгоритм Флойда
{
    for(int i = 0; i < topCount; i++)
    {
        dejkstr(i);
        ui->listWidget->addItem("- - - - - - - - -");
    }
}

void MainWindow::BFS(int start_top, int finish_top)                 // Алгоритм поиска в ширину
{
    std::vector<bool> visit(topCount);
    std::queue<int> queueBFS;
    std::vector<int> dist(topCount), last(topCount);

    for(int i = 0; i < topCount; i++)
        visit[i] = false;

    queueBFS.push(start_top);
    visit[start_top] = true;
    last[start_top] = -1;

    while(!queueBFS.empty())
    {
        int node = queueBFS.front();
        queueBFS.pop();
        for(int col = 0; col < topCount; col++)
            if(graf[col][node] != 0)
                if(visit[col] == false)
                {
                    queueBFS.push(col);
                    visit[col] = true;
                    dist[col] = dist[node] + 1;
                    last[col] = node;
                }
    }
    if(visit[finish_top] == false)
        ui->listWidget->addItem("Нет пути к целевой точке!");
    else
    {
        std::vector<int> path;
        for(int vertex = finish_top; vertex != -1; vertex = last[vertex])
            path.push_back(vertex);
        std::reverse(path.begin(), path.end());
        QString Path;
        Path = "Путь: " + QString::number(path.front() + 1);
        for(size_t i = 1; i < path.size(); i++)
            Path += " -> " + QString::number(path[i] + 1);
        ui->listWidget->addItem(Path);
    }
}

void MainWindow::DFS(int start_top, int finish_top)                 // Алгоритм поиска в глубину
{
    std::stack<int> stackDFS;
    std::vector<bool> visit(topCount);

    stackDFS.push(start_top);

    for(int i = 0; i < topCount; i++)
        visit[i] = false;

    visit[start_top] = true;
    bool find = true;

    while(!stackDFS.empty() && find)
    {
        int i = 0;
        while(i < topCount && find)
        {
            if(graf[i][stackDFS.top()] != 0 && visit[i] == false)
            {
                stackDFS.push(i);
                visit[i] = true;
                if(i == finish_top) find = false;
            } else i++;
        }
        stackDFS.pop();
    }

    if(find)
        ui->listWidget->addItem("Нет пути к целевой точке!");
    else
    {
        std::vector<int> path;
        int sizeStack = stackDFS.size();
        for(int i = 0; i < sizeStack; i++)
        {
            path.push_back(stackDFS.top());
            stackDFS.pop();
        }
        std::reverse(path.begin(), path.end());
        path.push_back(finish_top);
        QString Path;
        Path = "Путь: " + QString::number(path.front() + 1);
        for(size_t i = 1; i < path.size(); i++)
            Path += " -> " + QString::number(path[i] + 1);
        ui->listWidget->addItem(Path);
    }
}

bool MainWindow::find_in_array(int j, std::vector<int> array)
{
    bool result = true;
    for(int i = 0;  i < topCount; i++)
        if(array[i] == j)
            result = false;
    return result;
}

void MainWindow::setMax()
{
    int max = 0;
    for(int row = 0; row < topCount; row++)
        for(int col = 0; col < topCount; col++)
            if(graf[col][row] != NULL && graf[col][row] != MAX)
                max = max + graf[col][row];
    max = MAX = max*max;
}

int MainWindow::find_min(int **array, std::vector<int> visitArray, int row)
{
    int min = 0, min_id = -1;
    for(int col = 0; col < topCount; col++)
    {
        if(array[col][row] != 0 && find_in_array(col, visitArray))
        {
            min = array[col][row];
            min_id = col;
            break;
        }
    }

    for(int col = 0; col < topCount; col++)
        if(array[col][row] != 0 && array[col][row] < min && find_in_array(col, visitArray))
        {
            min = array[col][row];
            min_id = col;
        }
    return min_id;
}

int MainWindow::find_min(std::vector<int> array, std::vector<int> visitArray)
{
    int min = 0, min_id = -1;
    for(int col = 0; col < topCount; col++)
    {
        if(array[col] != MAX && array[col] != 0 && find_in_array(col, visitArray))
        {
            min = array[col];
            min_id = col;
            break;
        }
    }

    for(int col = 0; col < topCount; col++)
        if(array[col] != MAX && array[col] != 0 && array[col] < min && find_in_array(col, visitArray))
        {
            min = array[col];
            min_id = col;
        }
    return min_id;
}

void MainWindow::on_pushButton_5_clicked()
{
    QTableWidgetItem* item1 = new QTableWidgetItem;
    item1->setText("10"); ui->tableWidget->setItem(0,1,item1);
    QTableWidgetItem* item2 = new QTableWidgetItem;
    item2->setText("30"); ui->tableWidget->setItem(0,2,item2);
    QTableWidgetItem* item3 = new QTableWidgetItem;
    item3->setText("100"); ui->tableWidget->setItem(0,5,item3);
    QTableWidgetItem* item4 = new QTableWidgetItem;
    item4->setText("10"); ui->tableWidget->setItem(1,0,item4);
    QTableWidgetItem* item5 = new QTableWidgetItem;
    item5->setText("80"); ui->tableWidget->setItem(1,2,item5);
    QTableWidgetItem* item6 = new QTableWidgetItem;
    item6->setText("50"); ui->tableWidget->setItem(1,4,item6);
    QTableWidgetItem* item7 = new QTableWidgetItem;
    item7->setText("40"); ui->tableWidget->setItem(2,3,item7);
    QTableWidgetItem* item8 = new QTableWidgetItem;
    item8->setText("10"); ui->tableWidget->setItem(2,5,item8);
    QTableWidgetItem* item9 = new QTableWidgetItem;
    item9->setText("30"); ui->tableWidget->setItem(3,0,item9);
    QTableWidgetItem* item10 = new QTableWidgetItem;
    item10->setText("60"); ui->tableWidget->setItem(3,5,item10);
    QTableWidgetItem* item11 = new QTableWidgetItem;
    item11->setText("70"); ui->tableWidget->setItem(4,2,item11);
    QTableWidgetItem* item12 = new QTableWidgetItem;
    item12->setText("20"); ui->tableWidget->setItem(5,4,item12);
}

void MainWindow::on_pushButton_6_clicked()
{
    floyd();
}

void MainWindow::on_pushButton_7_clicked()
{
    ui->listWidget->clear();
}

void MainWindow::on_pushButton_8_clicked()
{
    bool buttStartOk, buttFinishOk;
    int startVertex = QInputDialog::getInt(0, "Ввод вершины", "Начальная вершина", 1, 1, topCount, 1, &buttStartOk) - 1;
    int finishVertex = QInputDialog::getInt(0, "Ввод вершины", "Целевая вершина", 1, 1, topCount, 1, &buttFinishOk) - 1;
    if(buttStartOk && buttFinishOk)
    {
        BFS(startVertex, finishVertex);
    }
}

void MainWindow::on_pushButton_9_clicked()
{
    bool buttStartOk, buttFinishOk;
    int startVertex = QInputDialog::getInt(0, "Ввод вершины", "Начальная вершина", 1, 1, topCount, 1, &buttStartOk) - 1;
    int finishVertex = QInputDialog::getInt(0, "Ввод вершины", "Целевая вершина", 1, 1, topCount, 1, &buttFinishOk) - 1;
    if(buttStartOk && buttFinishOk)
    {
        DFS(startVertex, finishVertex);
    }
}

void MainWindow::receiveFromQml(int id, int x, int y)
{
    emit sendToQml(id, x, y);
}

void MainWindow::changeToStandart()
{
    emit toStandart();
}

void MainWindow::changePosition(int index, int newX, int newY)
{
    emit newPosition(index, newX, newY);
}

void MainWindow::clickRound(int index)
{
    emit changeColor(index);
}

void MainWindow::addVertex()
{
    changeVertex.push_back(countVertex);
    currentVertex.push_back(countVertex);
    ui->tableWidget->setColumnCount(currentVertex.size());
    ui->tableWidget->setRowCount(currentVertex.size());

    for(int row = 0; row < countVertex; row++)
    {
        QTableWidgetItem* item = new QTableWidgetItem;
        item->setText(QString::number(0));
        ui->tableWidget->setItem(row, countVertex - 1, item);
    }

    for(int col = 0; col < countVertex; col++)
    {
        QTableWidgetItem* item = new QTableWidgetItem;
        item->setText(QString::number(0));
        ui->tableWidget->setItem(countVertex - 1, col, item);
    }

    topCount = currentVertex.size();
    countVertex++;
    emit indexNewVertex(countVertex);
}

void MainWindow::deleteVertex(int index)
{

    emit deleteRelationShips(index);
}

void MainWindow::length(int index1, int index2, int length, int relation)
{
    QTableWidgetItem* zero1 = new QTableWidgetItem;
    zero1->setText(QString::number(0));
    QTableWidgetItem* zero2 = new QTableWidgetItem;
    zero2->setText(QString::number(0));
    ui->tableWidget->setItem(index1 - 1, index2 - 1, zero1);
    ui->tableWidget->setItem(index2 - 1, index1 - 1, zero2);
    //......................................................
    QTableWidgetItem* item1 = new QTableWidgetItem;
    item1->setText(QString::number(length));
    if(relation == 0)
    {
        ui->tableWidget->setItem(index1 - 1, index2 - 1, item1);
        QTableWidgetItem* item2 = new QTableWidgetItem;
        item2->setText(QString::number(length));
        ui->tableWidget->setItem(index2 - 1, index1 - 1, item2);
    }
    else
        if(relation == 1)
            ui->tableWidget->setItem(index1 - 1, index2 - 1, item1);
    else
            if(relation == 2)
                ui->tableWidget->setItem(index2 - 1, index1 - 1, item1);
}

void MainWindow::propertyFromLine(int index, int vertex1, int vertex2, int length, int typeRoute)
{
    emit propertyLineToPanel(index, vertex1, vertex2, length, typeRoute);
}

void MainWindow::clickVertex(int index, double vertexX, double vertexY)
{
    emit infoClickedVertex(index, vertexX, vertexY);
}

void MainWindow::createRelations()
{
    emit createRelation();
}

void MainWindow::clickedLine(int index)
{
    emit chooseLine(index);
}

void MainWindow::propertyPanelToLine(int index_old, int index_new, int vertex1, int vertex2, int length, int typeRoute)
{
    // Для связей
    emit propertyFromPanelToLine(index_old, index_new, vertex1, vertex2, length, typeRoute);
}

void MainWindow::propertyPanelToVertex(int index_old, int index_new, double x_new, double y_new)
{
    emit propertyFromPanelToVertex(index_old, index_new, x_new, y_new);
}

void MainWindow::propertyPanelChangeToOpen()
{
    emit propertyPanelOpen();
}

void MainWindow::propertyPanelChangeToClose()
{
    emit propertyPanelClose();
}

void MainWindow::deleteRelation(int vertex1, int vertex2)
{
    QTableWidgetItem* zero1 = new QTableWidgetItem;
    zero1->setText(QString::number(0));
    QTableWidgetItem* zero2 = new QTableWidgetItem;
    zero2->setText(QString::number(0));
    ui->tableWidget->setItem(vertex1 - 1, vertex2 - 1, zero1);
    ui->tableWidget->setItem(vertex2 - 1, vertex1 - 1, zero2);
}

void MainWindow::propertyFromVertex(int index, double x, double y)
{
    emit propertyVertexToPanel(index, x, y);
}

void MainWindow::getMapSize(int width, int height)
{
    emit sendMapSize(width, height);
}

void MainWindow::getPositionVertex(int index)
{
    emit sendPositionVertex(index);
}
