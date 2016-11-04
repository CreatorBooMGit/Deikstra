import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: propertyPanelVertex
    color: "#424040"
    property alias propertyObject: propertyObject
    border.color: "#afa8a8"
    border.width: 3

    property string type : "Vertex"
    property int index : -1;

    property int coordX : 0;
    property int coordY : 0;

    property int max_w : 0;
    property int max_h : 0;

    property int index_old : index

    Connections {
        target: window

        onPropertyVertexToPanel: {
            index = index_i
            coordX = x_i
            coordY = y_i
        }

        onSendMapSize: {
            max_w = width_i
            max_h = height_i
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
                placeholderText: "Тип объкта"
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

        Item {                                                      // Объект "Коорд. Х"
            id: coordinateVertexX
            anchors.left: parent.left
            anchors.right: parent.right
            height: 20

            Text {
                id: coordinateVertexXName
                text: "Коорд. Х"
                color: "white"
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                width: parent.width / 2
                height: parent.height
                anchors.left: parent.left
                font.pixelSize: 12
            }

            SpinBox {
                id: coordinateVertexXValue
                anchors.left: coordinateVertexXName.right
                anchors.right: parent.right
                height: parent.height
                value: coordX
                font.pointSize: 10
                minimumValue: 0
                maximumValue: max_w - 50;
                style: SpinBoxStyle {
                    textColor: "white"
                    background: Rectangle {
                        anchors.fill: parent
                        color: "#272222"
                        radius: 5
                    }
                }
            }
        }


        Item {                                                      // Объект "Коорд. Y"
            id: coordinateVertexY
            anchors.left: parent.left
            anchors.right: parent.right
            height: 20

            Text {
                id: coordinateVertexYName
                text: "Коорд. Y"
                color: "white"
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                width: parent.width / 2
                height: parent.height
                anchors.left: parent.left
                font.pixelSize: 12
            }

            SpinBox {
                id: coordinateVertexYValue
                anchors.left: coordinateVertexYName.right
                anchors.right: parent.right
                height: parent.height
                value: coordY
                font.pointSize: 10
                minimumValue: 0
                maximumValue: max_h - 50;
                style: SpinBoxStyle {
                    textColor: "white"
                    background: Rectangle {
                        anchors.fill: parent
                        color: "#272222"
                        radius: 5
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
                coordX = coordinateVertexXValue.value
                coordY = coordinateVertexYValue.value
                window.propertyPanelToVertex(index_old, index, coordX, coordY);
            }
        }
    }
}
