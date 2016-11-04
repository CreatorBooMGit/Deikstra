import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.0

Rectangle {
    id: main

    color: "white"
    rotation: 0

    property int indexRound : 1
    property int indexLine: 1
    property int choose : 0

    property int indexVertex1 : -1
    property int x1 : 0
    property int y1 : 0

    property int indexVertex2 : -1
    property int x2 : 0
    property int y2 : 0

    property int fileToLoader : 0

    Action {                                                            // Горячая клавиша "Свойства"
        id: openPropertyPanel
        shortcut: "Ctrl+O"
        onTriggered: if(propertyLoader.width === 0) propertyLoader.width = 150; else propertyLoader.width = 0;
    }

    Action {                                                            // Горячая клавиша "Отмена"
        id: allToStandart
        shortcut: "Esc"
        onTriggered: {
            window.changeToStandart()
            window.clickedLine(0)
            window.clickRound(0)
            fileToLoader = 0
            indexVertex1 = -1
            x1 = 0
            y1 = 0
        }
    }

    Action {                                                            // Горячая клавиша "Выбор "Курсор""
        id: cursorAction
        shortcut: "Ctrl+1"
        onTriggered: choose = 0
    }

    Action {                                                            // Горячая клавиша "Выбор "Вершина""
        id: vertexAction
        shortcut: "Ctrl+2"
        onTriggered: choose = 1
    }

    Action {                                                            // Горячая клавиша "Выбор "Связь""
        id: relationAction
        shortcut: "Ctrl+3"
        onTriggered: choose = 2
    }

    Action {                                                            // Горячая клавиша "ToolBar"
        id: openToolBar
        shortcut: "Ctrl+I"
        onTriggered: {
            if(chooseList.width === 25) chooseList.width = 0;
            else chooseList.width = 25;
        }
    }

    Connections {
        target: window

        onSetSizeMain: {                                                // Получение размера объекта
            main.width = gwidth;
            main.height = gheight;
        }

        onInfoClickedVertex: {
            if(choose === 2)
            {
                if(indexVertex1 === -1)
                {
                    indexVertex1 = vertexIndex;
                    x1 = vertexX;
                    y1 = vertexY;
                }
                else if(indexVertex2 === -1)
                {
                    indexVertex2 = vertexIndex;
                    x2 = vertexX;
                    y2 = vertexY;
                    var component2 = Qt.createComponent("qrc:/qml/Line.qml");
                    if (component2.status === Component.Ready) {
                        var line = component2.createObject(map);
                        line.x1 = x1 + 25;
                        line.x2 = x2 + 25;
                        line.y1 = y1 + 25;
                        line.y2 = y2 + 25;
                        line.left_id = main.indexVertex1;
                        line.right_id = main.indexVertex2;
                        line.index = indexLine;
                        indexLine++;
                        window.length(main.indexVertex1, main.indexVertex2, line.length, 0);
                        indexVertex1 = -1;
                        indexVertex2 = -1;
                    }
                }
            }
        }

        onCreateRelation: {
            if(choose === 2)
                if(indexVertex1 != -1 && indexVertex2 != -1)
                {
                    console.log("after: ");
                    console.log(indexVertex1);
                    console.log(indexVertex2);
                    var component2 = Qt.createComponent("qrc:/qml/Line.qml");
                    if (component2.status === Component.Ready) {
                        var line = component2.createObject(map);
                        line.x1 = x1 + 25;
                        line.x2 = x2 + 25;
                        line.y1 = y1 + 25;
                        line.y2 = y2 + 25;
                        line.left_id = main.indexVertex1;
                        line.right_id = main.indexVertex2;
                        line.index = indexLine;
                        indexLine++;
                        window.length(main.indexVertex1, main.indexVertex2, line.length, 0);
                        indexVertex1 = -1;
                        indexVertex2 = -1;
                    }
                }
        }

        onPropertyPanelOpen: {
            propertyLoader.width = 150
        }

        onPropertyPanelClose: {
            propertyLoader.width = 0
        }

        onPropertyVertexToPanel: {
            propertyLoader.source = "qrc:/qml/propertyPanelVertex.qml"
            fileToLoader = 1
        }

        onPropertyLineToPanel: {
            propertyLoader.source = "qrc:/qml/propertyPanelLine.qml"
            fileToLoader = 2
        }
    }


    Rectangle {                                                         // Меню выбора объекта
        id: chooseList
        color: "#424040"
        width: 25
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.top: parent.top

        Column {
            id: chooseColumn
            anchors.fill: parent
            spacing: 0

            ToolButton {
                id: chooseCursor
                anchors.right: parent.right
                anchors.left: parent.left
                height: 25
                tooltip: "Рука"
                checked: true
                checkable: if(choose === 0) true; else false;
                onClicked: choose = 0
                iconSource: "qrc:/images/cursor_arrow.png"
            }
            ToolButton {
                id: chooseVertex
                anchors.right: parent.right
                anchors.left: parent.left
                height: 25
                tooltip: "Вершина"
                checked: true
                checkable: if(choose === 1) true; else false;
                onClicked: choose = 1
                iconSource: "qrc:/images/vertexImage.png"
            }
            ToolButton {
                id: chooseRelation
                anchors.right: parent.right
                anchors.left: parent.left
                height: 25
                tooltip: "Связь"
                checked: true
                checkable: if(choose === 2) true; else false;
                onClicked: choose = 2
                iconSource: "qrc:/images/LineImage.png"
            }
        }

    }

    Loader {                                                            // Свойства
        id: propertyLoader
        width: 0
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        source: fileToLoader === 0 ? "qrc:/qml/propertyPanelNothing.qml" : ""
    }

    Rectangle {                                                         // Область графа
        id: map
        anchors.left: chooseList.right
        anchors.right: propertyLoader.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: "Black"
        clip: false

        Connections {
        target: window

        onIndexNewVertex: {
            indexRound = newIndex;
            }

        }

        onWidthChanged: window.getMapSize(map.width, map.height)
        onHeightChanged: window.getMapSize(map.width, map.height)

        border.width: 3
        border.color: "#004E5B"

        MouseArea {
            id: mainArea
            z: 0
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.AllButtons;
            cursorShape: {
                if(choose == 0) 0;
                else if(choose == 1 || choose == 2) 2;
            }
            onClicked:
            {
                if(choose === 1)
                {
                    if(mouse.button & Qt.LeftButton) window.changeToStandart();
                    var component = Qt.createComponent("qrc:/qml/Round.qml");
                    if (component.status === Component.Ready) {
                       var round = component.createObject(map);
                       round.x = mainArea.mouseX - (round.width / 2);
                       round.y = mainArea.mouseY - (round.height / 2);
                       round.index = indexRound;
                       window.addVertex();
                       window.changeToStandart();
                    }
                }
            }
        }
    }

/*    Rectangle {
        id: propertyPanel
        anchors.left: map.right
        anchors.right: parent.right
        anchors.top: parenttop
        anchors.bottom: parent.bottom
        color: "#424040"

        Column {
            id: propertyObject
            anchors.fill: parent
            spacing: 5

            Text {
                id: description
                text: "Свойства"
                color: "white"
                width: parent.width
                height: 20
                anchors.left: parent.left
                font.pixelSize: 12
            }

            Item {
                id: typeObject
                anchors.left: parent.left
                anchors.right: parent.right
                height: 20

                Text {
                    id: typeObjectName
                    text: "Тип"
                    color: "white"
                    width: parent.width / 2
                    height: parent.height
                    anchors.left: parent.left
                    font.pixelSize: 12
                }

                Text {
                    id: typeObjectValue
                    text: "ValueType"
                    color: "white"
                    anchors.left: typeObjectName.right
                    anchors.right: parent.right
                    height: parent.height
                    font.pixelSize: 12
                }
            }

            Item {
                id: indexObject
                anchors.left: parent.left
                anchors.right: parent.right
                height: 20

                Text {
                    id: indexObjectName
                    text: "Индекс объекта"
                    color: "white"
                    elide: Text.ElideRight
                    width: parent.width / 2
                    height: parent.height
                    anchors.left: parent.left
                    font.pixelSize: 12
                }

                Rectangle {
                    color: "#272222"
                    anchors.left: indexObjectName.right
                    anchors.right: parent.right
                    height: parent.height

                    TextEdit {
                        id: indexObjectValue
                        text: "indexValue"
                        color: "white"
                        anchors.fill: parent
                        height: parent.height
                        font.pixelSize: 12
                    }
                }
            }

            Item {
                id: lengthLine
                anchors.left: parent.left
                anchors.right: parent.right
                height: 20

                Text {
                    id: lengthLineName
                    text: "Вес ребра"
                    color: "white"
                    elide: Text.ElideRight
                    width: parent.width / 2
                    height: parent.height
                    anchors.left: parent.left
                    font.pixelSize: 12
                }

                Rectangle {
                    color: "#272222"
                    anchors.left: lengthLineName.right
                    anchors.right: parent.right
                    height: parent.height

                    TextEdit {
                        id: lengthLineValue
                        text: "Value"
                        color: "white"
                        anchors.fill: parent
                        height: parent.height
                        font.pixelSize: 12
                    }
                }
            }

            Item {
                id: typeRelations
                anchors.left: parent.left
                anchors.right: parent.right
                height: 20

                Text {
                    id: typeRelationsName
                    text: "Ориентированный"
                    color: "white"
                    elide: Text.ElideRight
                    width: parent.width / 2
                    height: parent.height
                    anchors.left: parent.left
                    font.pixelSize: 12
                }

                Rectangle {
                    color: "#272222"
                    anchors.left: typeRelationsName.right
                    anchors.right: parent.right
                    height: parent.height

                    CheckBox {
                        id: typeRelationsValue
                        anchors.fill: parent
                    }
                }
            }

            Button {
                id: confirmButton
                width: parent.width / 2
                anchors.right: parent.right
                Text {
                    anchors.centerIn: parent
                    text: "Применить"
                }
            }
        }
    } */

}
