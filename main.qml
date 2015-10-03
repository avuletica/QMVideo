import QtQuick 2.3
import QtQuick.Window 2.2
import QtMultimedia 5.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Extras 1.4

Window {
    id: mainArea
        visible: true
        minimumWidth: 1200
        minimumHeight: 720
        color: "lightyellow"
    Rectangle {
        id: controlArea
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 0
        width: 371
        height: 34
        color: "lightgray"


    }

}

