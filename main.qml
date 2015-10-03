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
    color: "white"

    // needs fix only if should be needed here
    onHeightChanged:   {
    if(mainArea.visibility === Window.Maximized) {
        mainArea.showFullScreen()
        console.log("Maximize DETECTED")
    }
    else {
        console.log("Screen change DETECTED")
    }
    }

    // event handler for escape character (exit full screen)
    Item {
        anchors.fill: parent
        focus: true
        Keys.onPressed: {
            if (event.key == Qt.Key_Escape) {
                console.log("Escape detected!");
                mainArea.showNormal()
                event.accepted = true;
            }
        }
    }

    MediaPlayer {
        id: player
        source: ""
        autoPlay: true
    }

    VideoOutput {
        id: videoOutput
        source: player
        anchors.fill: parent
        // fillmode - the video is scaled uniformly to fill, cropping if necessary
        fillMode: VideoOutput.PreserveAspectCrop
    }

    MouseArea {
        id: rightClickEvent
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: pieMenu.popup(mouseX, mouseY), console.log("Right Click DETECTED")
    }

    MouseArea {
        id: doubleLeftClickEvent
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        //onClicked: mainArea.flags.Qt.FramelessWindowHint
    }

    PieMenu {
        id: pieMenu
        MenuItem {
            text: "Open File"
            onTriggered:{
                fileDialog.open()
                player.source=fileDialog.fileUrl
                player.play()
                //  player.metaData.subTitle = "/home/ante/Downloads/test.srt"
            }
        }
        MenuItem {
            text: "Load subtittle"
            onTriggered: print("Action 2")
        }
        MenuItem {
            text: "Settings"
            onTriggered: print("Action 3")
        }
    }
    // Area for controls ( audio/play/stop..)
    Rectangle {
        id: controlArea
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 0
        width: 500
        height: 40
        opacity: 0.70
        color: "lightgray"

        RowLayout {
            anchors.centerIn: parent
            ToolButton {
                text: "Play"
                iconName: "aa"
                //iconSource: "icons/play.png"
                onClicked: {
                    player.play()
                }
            }
            ToolButton {
                text: "Pause"
                //iconSource: "icons/pause.png"
                onClicked: {
                    player.pause()
                }
            }
            ToolButton {
                text: "Stop"
                //iconSource: "icons/stop.png"
                onClicked: {
                    player.stop()
                }
            }
            ToolButton {
                text: "Backward"
                //iconSource: "icons/backward.png"
                onClicked: {
                    player.seek(player.position - 10000)
                }
            }
            ToolButton {
                text: "Forward"
                //iconSource: "icons/forward.png"
                onClicked: {
                    player.seek(player.position + 10000)
                }
            }
            Slider {
                id: audioSlider
                width: 195
                value: 0.5
                onValueChanged: player.volume = audioSlider.value
            }
        }
        MouseArea {
            anchors.fill: parent
            hoverEnabled:true
            onEntered: {
                console.log("ENTERED toolbar mousearea");
                controlArea.opacity = 0.70
            }
            onExited: {
                console.log("EXITED toolbar mousearea");
                controlArea.opacity = 0.0
            }
        }
        //  File opener PROTOTYPE
        FileDialog {
            id: fileDialog
            title: "Please choose a file"
            onAccepted: {
                player.pause()
                player.source=fileDialog.fileUrl
            }
            Component.onCompleted: visible = false
        }

    }

}

