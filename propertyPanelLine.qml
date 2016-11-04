import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: propertyPanelLine
    color: "#424040"
    border.color: "#afa8a8"
    border.width: 3

    property string type : "Line"
    property int index : -1
    property int vertex1_id : -1
    property int vertex2_id : -1
    property int mass : -1
    property int typeRoute : 0

    property int index_old : index

    Connections {
        target: window

        onPropertyLineToPanel: {
            index = indexLine;
            vertex1_id = vertex1;
            vertex2_id = vertex2;
            mass = massLine;
            typeRoute = typeRouteSi;
            if(typeRoute === 0)
                typeRelationsValue.checked = false;
            else
            {
                typeRelationsValue.checked = true;

                if(typeRoute === 1)
                    first.checked = true;
                else
                    first.checked = false;
                //.........................
                if(typeRoute === 2)
                    second.checked = true;
                else
                    second.checked = false;
            }
        }
    }

    Column {
        id: propertyObject
        anchors.fill: parent
        anchors.margins: 3
        spacing: 5

        Item {                                                      // Объект "Заголовок"
            id: title
            anchors.left: parent.left
            anchors.right: parent.right
            height: 20
            Text {
                id: description
                text: "Свойства"
                color: "white"
                height: parent.height
                width: parent.width - 20
                anchors.left: parent.left
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 12

            }

            ToolButton {
                id: closePanel
                anchors.left: description.right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                iconSource: "qrc:/images/closeButton.png"
                onClicked: window.propertyPanelChangeToClose()
            }
        }

        Item {                                                      // Объект "Тип объекта"
            id: typeObject
            anchors.left: parent.left
            anchors.right: parent.right
            height: 20

            Text {
                id: typeObjectName
                text: "Тип"
                color: "white"
                verticalAlignment: Text.AlignVCenter
                width: parent.width / 2
                height: parent.height
                anchors.left: parent.left
                font.pixelSize: 12
            }

            TextField {
                id: typeObjectValue
                anchors.left: typeObjectName.right
                anchors.right: parent.right
                height: parent.height
                placeholderText: "Тип объекта"
                text: type
                readOnly: true
                font.pointSize: 10
                style: TextFieldStyle {
                    textColor: "white"
                    background: Rectangle {
                        anchors.fill: parent
                        color: "#272222"
                        radius: 5
                    }
                }
            }
        }

        Item {                                                      // Объект "Индекс объекта"
            id: indexObject
            anchors.left: parent.left
            anchors.right: parent.right
            height: 20

            Text {
                id: indexObjectName
                text: "Индекс объекта"
                color: "white"
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
                width: parent.width / 2
                height: parent.height
                anchors.left: parent.left
                font.pixelSize: 12
            }

            TextField {
                id: indexObjectValue
                anchors.left: indexObjectName.right
                anchors.right: parent.right
                height: parent.height
                placeholderText: "Индекс вершины"
                text: index
                font.pointSize: 10
                style: TextFieldStyle {
                    textColor: "white"
                    background: Rectangle {
                        anchors.fill: parent
                        color: "#272222"
                        radius: 5
                    }
                }
            }
        }

        Item {                                                      // Объект "Вершина 1"
            id: indexVertex1
            anchors.left: parent.left
            anchors.right: parent.right
            height: 20

            Text {
                id: indexVertex1Name
                text: "Вершина 1"
                color: "white"
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                width: parent.width / 2
                height: parent.height
                anchors.left: parent.left
                font.pixelSize: 12
            }

            TextField {
                id: indexVertex1Value
                anchors.left: indexVertex1Name.right
                anchors.right: parent.right
                height: parent.height
                placeholderText: "Индекс вершины"
                text: vertex1_id
                font.pointSize: 10
                style: TextFieldStyle {
                    textColor: "white"
                    background: Rectangle {
                        anchors.fill: parent
                        color: "#272222"
                        radius: 5
                    }
                }
            }
        }


        Item {                                                      // Объект "Вершина 2"
            id: indexVertex2
            anchors.left: parent.left
            anchors.right: parent.right
            height: 20

            Text {
                id: indexVertex2Name
                text: "Вершина 2"
                color: "white"
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                width: parent.width / 2
                height: parent.height
                anchors.left: parent.left
                font.pixelSize: 12
            }

            TextField {
                id: indexVertex2Value
                anchors.left: indexVertex2Name.right
                anchors.right: parent.right
                height: parent.height
                placeholderText: "Индекс вершины"
                text: vertex2_id
                font.pointSize: 10
                style: TextFieldStyle {
                    textColor: "white"
                    background: Rectangle {
                        anchors.fill: parent
                        color: "#272222"
                        radius: 5
                    }
                }
            }
        }


        Item {                                                      // Объект "Вес связи"
            id: lengthLineObject
            anchors.left: parent.left
            anchors.right: parent.right
            height: 20

            Text {
                id: lengthLineName
                text: "Вес ребра"
                color: "white"
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                width: parent.width / 2
                height: parent.height
                anchors.left: parent.left
                font.pixelSize: 12
            }

            TextField {
                id: lengthLineValue
                anchors.left: lengthLineName.right
                anchors.right: parent.right
                height: parent.height
                placeholderText: "Индекс вершины"
                text: mass
                font.pointSize: 10
                style: TextFieldStyle {
                    textColor: "white"
                    background: Rectangle {
                        anchors.fill: parent
                        color: "#272222"
                        radius: 5
                    }
                }
            }
        }

        Item {                                                      // Объект "Тип связи"
            id: typeRelations
            anchors.left: parent.left
            anchors.right: parent.right
            height: 20

            Text {
                id: typeRelationsName
                text: "Ориентированный"
                color: "white"
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                width: parent.width / 2
                height: parent.height
                anchors.left: parent.left
                font.pixelSize: 12
            }

            CheckBox {
                id: typeRelationsValue
                anchors.left: typeRelationsName.right
                anchors.right: parent.right
                height: parent.height
                onCheckedChanged: {
                    if(checked === false) typeRoute = 0;
                    first.checked = false
                    second.checked = false
                }
                style: CheckBoxStyle {
                    spacing: 3
                    label: Text {
                        color: "white"
                        text: if(typeRelationsValue.checked === true) "true"; else "false"
                    }
                }
            }
        }

        Item {                                                      // Объект "Тип связи"
            id: routeRelation
            anchors.left: parent.left
            anchors.right: parent.right
            height: 40

            Text {
                id: routeRelationName
                text: "Направление"
                color: "white"
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                width: parent.width / 2
                height: parent.height
                anchors.left: parent.left
                font.pixelSize: 12
            }

            ExclusiveGroup { id: cRoute}

            Column {
                id: chooseRoute
                anchors.left: routeRelationName.right
                anchors.right: parent.right
                height: parent.height
                enabled: typeRelationsValue.checked

                RadioButton {
                    id: first
                    exclusiveGroup: cRoute
                    onCheckedChanged: if(checked === true) typeRoute = 1;
                    style: RadioButtonStyle {
                        spacing: 3
                        label: Text {
                            color: "white"
                            text: vertex1_id + " => " + vertex2_id
                            height: 20
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }

                RadioButton {
                    id: second
                    checked: if(typeRoute === 2) second.checked = true; else second.checked = false
                    exclusiveGroup: cRoute
                    onCheckedChanged: if(checked === true) typeRoute = 2;
                    style: RadioButtonStyle {
                        spacing: 3
                        label: Text {
                            color: "white"
                            text: vertex2_id + " => " + vertex1_id
                            height: 20
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }
        }

        Button {                                                    // Кнопка "Подтвердить"
            id: confirmButton
            width: parent.width / 2
            anchors.right: parent.right
            Text {
                anchors.centerIn: parent
                text: "Применить"
            }

            onClicked: {
                index = indexObjectValue.text
                mass = lengthLineValue.text
                vertex1_id = indexVertex1Value.text
                vertex2_id = indexVertex2Value.text
                window.propertyPanelToLine(index_old, index, vertex1_id, vertex2_id, mass, typeRoute);
            }
        }
    }
}
