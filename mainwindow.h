#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <iostream>
#include <queue>
#include <string>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

    void dejkstr(int top);                                                  // Алгоритм Дейкстры
    void floyd();                                                           // Алгоритм Флойда
    void BFS(int start_top ,int finish_top);                                 // Поиск в ширину
    void DFS(int start_top ,int finish_top);
//    int* childVertex(int vertex, int (&count));                                           // Поиск дочерних вершин
    bool find_in_array(int j, std::vector<int> array);
    void setMax();
    int find_min(int **array, std::vector<int> visitArray, int row);
    int find_min(std::vector<int> array, std::vector<int> visitArray);

private slots:
    void on_pushButton_2_clicked();
    void on_pushButton_3_clicked();
    void on_pushButton_clicked();
    void on_pushButton_4_clicked();
    void on_pushButton_5_clicked();
    void on_pushButton_6_clicked();
    void on_pushButton_7_clicked();
    void on_pushButton_8_clicked();
    void on_pushButton_9_clicked();

signals:
    void sendToQml(int ind, int corX, int corY);
    void toStandart();
    void newPosition(int index, int newX, int newY);
    void changeColor(int index);
    void indexNewVertex(int newIndex);
    void deleteRelationShips(int index);
    void setSizeMain(int gwidth, int gheight);
    void propertyLineToPanel(int indexLine, int vertex1, int vertex2, int massLine, int typeRouteSi);
    void propertyVertexToPanel(int index_i, double x_i, double y_i);
    void propertyFromPanelToLine(int index_old, int index_new, int vertex1, int vertex2, int length_new, int typeRoute);
    void propertyFromPanelToVertex(int index_old, int index_new, double x_new, double y_new);
    void infoClickedVertex(int vertexIndex, double vertexX, double vertexY);
    void createRelation();
    void chooseLine(int indexLine);
    void propertyPanelOpen();
    void propertyPanelClose();
    void sendMapSize(int width_i, int height_i);
    void sendPositionVertex(int index_i);

public slots:
    void addVertex();
    void receiveFromQml(int id, int x, int y);
    void changeToStandart();
    void changePosition(int index, int newX, int newY);
    void clickRound(int index);
    void deleteVertex(int index);
    void length(int index1, int index2, int length, int relation);
    void propertyFromLine(int index, int vertex1, int vertex2, int length, int typeRoute);
    void propertyFromVertex(int index, double x, double y);
    void propertyPanelToLine(int index_old, int index_new, int vertex1, int vertex2, int length, int typeRoute);
    void propertyPanelToVertex(int index_old, int index_new, double x_new, double y_new);
    void clickVertex(int index, double vertexX, double vertexY);
    void createRelations();
    void clickedLine(int index);
    void propertyPanelChangeToOpen();
    void propertyPanelChangeToClose();
    void deleteRelation(int vertex1, int vertex2);
    void getMapSize(int width, int height);
    void getPositionVertex(int index);

private:
    Ui::MainWindow *ui;
    int **graf;
    std::vector<int> currentVertex, changeVertex;
    int MAX = 0, topCount = 1;
    int countLine, countVertex = 1;
};

#endif // MAINWINDOW_H
