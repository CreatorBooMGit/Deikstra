import QtQuick 2.5
import QtQuick.Controls 1.4

Rectangle {
    id: line

    property int x1
    property int y1

    property int x2
    property int y2

    property int left_id
    property int right_id

    property int index

    property int relation : 0

    property int length: 1

    Connections {
        target: window

        onNewPosition: {
            if(index === left_id) { x1 = newX; y1 = newY; }
            else if(index === right_id) { x2 = newX; y2 = newY; }
//            else console.log("vertex " + left_id + " ; " + right_id);
        }

        onChangeColor: {
            if(relation === 0)
            {
                if(index === left_id || index === right_id) {
                    color = "#00353D";
                    if(relation === 0) arrow.source = "";
                    else
                        arrow.source = "qrc:/images/arrow_left_for_clicked_line.png";
                } else {
                    color = "#52161D";
                    if(relation === 0) arrow.source = "";
                    else
                        arrow.source = "qrc:/images/arrow_left_for_line.png";
                }
            }
            else
                if(relation === 1)
                {
                    if(index === left_id) {
                        color = "#00353D";
                        if(relation === 0) arrow.source = "";
                        else
                            arrow.source = "qrc:/images/arrow_left_for_clicked_line.png";
                    } else {
                        color = "#52161D";
                        if(relation === 0) arrow.source = "";
                        else
                            arrow.source = "qrc:/images/arrow_left_for_line.png";
                    }
                }
            else
                    if(relation === 2)
                    {
                        if(index === right_id) {
                            color = "#00353D";
                            if(relation === 0) arrow.source = "";
                            else
                                arrow.source = "qrc:/images/arrow_left_for_clicked_line.png";
                        } else {
                            color = "#52161D";
                            if(relation === 0) arrow.source = "";
                            else
                                arrow.source = "qrc:/images/arrow_left_for_line.png";
                        }
                    }

        }

        onDeleteRelationShips: {
            if(index === left_id || index === right_id) { window.deleteRelation(left_id, right_id); line.destroy(); }
        }

        onChooseLine: {
            if(index === indexLine)
            {
                border.width = 2
                border.color = "#D45742"
                if(relation === 0) arrow.source = "";
                else arrow.source = "qrc:/images/arrow_border_left_for_clicked_line.png";
            } else
            {
                border.width = 0
                border.color = "#52161D"
                if(relation === 0) arrow.source = "";
                else arrow.source = "qrc:/images/arrow_left_for_line.png";
            }
        }

        onPropertyFromPanelToLine: {
            if(index === index_old) {
                line.index = index_new;
                line.left_id = vertex1;
                line.right_id = vertex2;
                line.length = length_new;
                line.relation = typeRoute;
                if(relation === 0)
                {
                    if(index === left_id || index === right_id) {
                        color = "#00353D";
                        if(relation === 0) arrow.source = "";
                        else
                            arrow.source = "qrc:/images/arrow_left_for_clicked_line.png";
                    } else {
                        color = "#52161D";
                        if(relation === 0) arrow.source = "";
                        else
                            arrow.source = "qrc:/images/arrow_left_for_line.png";
                    }
                }
                else
                    if(relation === 1)
                    {
                        if(index === left_id) {
                            color = "#00353D";
                            if(relation === 0) arrow.source = "";
                            else
                                arrow.source = "qrc:/images/arrow_left_for_clicked_line.png";
                        } else {
                            color = "#52161D";
                            if(relation === 0) arrow.source = "";
                            else
                                arrow.source = "qrc:/images/arrow_left_for_line.png";
                        }
                    }
                else
                        if(relation === 2)
                        {
                            if(index === right_id) {
                                color = "#00353D";
                                if(relation === 0) arrow.source = "";
                                else
                                    arrow.source = "qrc:/images/arrow_left_for_clicked_line.png";
                            } else {
                                color = "#52161D";
                                if(relation === 0) arrow.source = "";
                                else
                                    arrow.source = "qrc:/images/arrow_left_for_line.png";
                            }
                        }
            }
        }
    }

    onX1Changed: window.length(line.left_id, line.right_id, line.length, line.relation);
    onX2Changed: window.length(line.left_id, line.right_id, line.length, line.relation);
    onY1Changed: window.length(line.left_id, line.right_id, line.length, line.relation);
    onY2Changed: window.length(line.left_id, line.right_id, line.length, line.relation);

    onLengthChanged: window.length(line.left_id, line.right_id, line.length, line.relation);
    onRelationChanged: window.length(line.left_id, line.right_id, line.length, line.relation);

    onLeft_idChanged: window.getPositionVertex(left_id);
    onRight_idChanged: window.getPositionVertex(right_id);

    width: Math.sqrt(Math.pow(x2-x1, 2) + Math.pow(y2-y1, 2))
    rotation: getAngle(x1, y1, x2, y2);
    height: 5

    x: x1
    y: y1
    z: 1

    transformOrigin: Item.Left

    color: "#52161D"
    border.color: "#52161D"
    border.width: 0

    Image {
        id: arrow
        source: {
            if(relation === 0) "";
            else
                "qrc:/images/arrow_left_for_line.png"
        }
        height: 25
        width: 50
        y: -10
        x: (relation === 2 ? 25 : line.width - 75)
        rotation: (relation === 2 ? 0 : 180);
    }

    MouseArea {
        id: lineArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.AllButtons
        onClicked: {
            if(mouse.button & Qt.RightButton)
            {
                contextLine.popup();
                window.clickedLine(line.index);
            }
            if(mouse.button & Qt.LeftButton)
            {
                window.clickedLine(line.index);
                window.propertyFromLine(line.index, line.left_id, line.right_id, line.length, line.relation);
                window.propertyFromLine(line.index, line.left_id, line.right_id, line.length, line.relation);
            }
        }
    }

    Text {
        id: textLine

        anchors.horizontalCenter: line.horizontalCenter
        anchors.bottom: line.top

        font.pixelSize: 14
        color: "#E8B03A"
        text: length
    }

    Menu {
        id: contextLine

        MenuItem {
            text: "Удалить"
            onTriggered: { window.deleteRelation(left_id, right_id); line.destroy(); }
        }
        MenuSeparator { }
        MenuItem {
            text: "Свойства"
            onTriggered:  window.propertyPanelChangeToOpen()
        }
    }

    function getAngle(x1, y1, x2, y2) {
        var angle = (y2-y1) / (x2-x1);

        angle = Math.atan(angle) * 180/3.14;

        if(x1 > x2 && y1 < y2) angle = 180 + angle;
        if(x1 > x2 && y1 > y2) angle = 180 + angle;
        if(x1 > x2 && y1 === y2) angle = 180;

        return angle;
    }
}
