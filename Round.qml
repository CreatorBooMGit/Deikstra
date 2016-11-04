import QtQuick 2.5
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0

Rectangle {
    id: round

    width: 50
    height: 50
    radius: 25
    color: colorStandart
    border.color: "red"
    border.width: 0

    property int x1
    property int y1
    property int x2
    property int y2
    property int index1

    property string colorStandart : "#ADADAD"
    property string colorClicked : "#828282"

    Connections {
        target: window

        onSendToQml: {
            if(ind === index) { change = false; color = colorClicked; round.z = 10; }
            else { change = true; color = colorStandart; round.z = 5; }
            x1 = corX; y1 = corY;
            index1 = ind;
        }

        onToStandart: { change = true; color = colorStandart; }

        onPropertyFromPanelToVertex: {
            if(index === index_old) {
                round.index = index_new
                round.x = x_new
                round.y = y_new
            }
        }

        onSendPositionVertex: {
            if(index === index_i) window.changePosition(index, x + round.width / 2, y + round.height / 2)
        }
    }

    property int index;
    property bool change;

    z: 5;

    onXChanged: window.changePosition(index, x + round.width / 2, y + round.height / 2)
    onYChanged: window.changePosition(index, x + round.width / 2, y + round.height / 2)

/*        gradient: Gradient {
        GradientStop { id: grad0; position: 0.0; color: "blue" }
        GradientStop { id: grad1; position: 1.0; color: "red"  }
    }

    ParallelAnimation {
        id: mouseEnterAnim
        PropertyAnimation {
            target: grad0
            properties: "color"
            to: "red"
            duration: 200
        }
        PropertyAnimation {
            target: grad1
            properties: "color"
            to: "black"
            duration: 200
        }
    }

    ParallelAnimation {
        id: mouseExitAnim
        PropertyAnimation {
            target: grad0
            properties: "color"
            to: "blue"
            duration: 200
        }
        PropertyAnimation {
            target: grad1
            properties: "color"
            to: "red"
            duration: 200
        }
    }

    ParallelAnimation {
        id: mouseClicked
        PropertyAnimation {
            target: grad0
            properties: "color"
            to: "blue"
            duration: 200
        }
        PropertyAnimation {
            target: grad1
            properties: "color"
            to: "black"
            duration: 200
        }
    } */

    Text {
        id: round_text

        anchors.centerIn: parent
        font.pixelSize: 24
        color: "white"
        text: index
    }

    MouseArea {
        id: roundArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.AllButtons
        drag {
            target: round
            minimumX: 0;
            minimumY: 0;
            maximumX: round.parent.width - round.width;
            maximumY: round.parent.height - round.height;
        }
        onClicked: {
            if(mouse.button & Qt.RightButton)
                contextVertex.popup();
            if(mouse.button & Qt.LeftButton)
            {
                window.changeToStandart();
                window.clickRound(round.index);
                window.receiveFromQml(index, round.x, round.y);
                window.clickVertex(index, round.x, round.y);
                window.getMapSize(round.parent.width, round.parent.height);
                window.propertyFromVertex(round.index, round.x, round.y);
                window.propertyFromVertex(round.index, round.x, round.y);
     //           window.createRelations();
                window.clickedLine(0);
            }
        }

//            onEntered: { if(change){ mouseEnterAnim.start() } else { mouseClicked.start() } }
//            onExited: { if(change) { mouseExitAnim.start()  } else { mouseClicked.start() } }
    }

    Menu {
        id: contextVertex

        MenuItem {
            text: "Удалить"
            onTriggered: { console.log(round); window.deleteVertex(index); round.destroy(); }
        }
        MenuSeparator { }
        MenuItem {
            text: "Свойства"
            onTriggered:  window.propertyPanelChangeToOpen()
        }
    }
}

