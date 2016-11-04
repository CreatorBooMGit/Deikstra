import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: propertyPanelNothing
    color: "#424040"
    border.color: "#afa8a8"
    border.width: 3

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
                text: "  Объект не выбран"
                color: "white"
                width: parent.width / 2
                height: parent.height
                anchors.left: parent.left
                font.pixelSize: 12
            }
        }
    }
}
