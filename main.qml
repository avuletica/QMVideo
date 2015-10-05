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
    width: 1200
    height: 720
    minimumWidth: 400
    minimumHeight: 300

    onHeightChanged: {
        if(mainArea.visibility === Window.Maximized) {
            mainArea.showFullScreen()
            console.log("Maximize DETECTED")
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
        /* playbackState:
          0 - stopped
          1 - playing
          2 - paused
        */
        onPlaybackStateChanged: {
            if(player.playbackState === 0 || player.playbackState === 2) {
                playPauseButton.iconSource="play.png"
            }
            else {
                playPauseButton.iconSource="pause.png"
            }
        }
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
        id: mouseArea1
        anchors.bottomMargin: 50
        anchors.fill: parent

        hoverEnabled: true
        onEntered: {
            console.log(containsMouse)
            controlArea.opacity = 0.0
        }
        onExited: {
            console.log(containsMouse)
            controlArea.opacity = 0.4
        }

        Image {
            id: backgroundimage
            width: Window.width
            height: Window.height
            source: "logo.png"
        }
    }
    PieMenu {
        id: pieMenu
        MenuItem {

            text: "Open File"
            onTriggered:{
                fileDialog.open()
                player.source=fileDialog.fileUrl
                player.play()
            }
        }
        MenuItem {
            text: "Load subtitle"
            onTriggered: print("Action 2")
        }
        MenuItem {
            text: "Settings"
            onTriggered: loader.source = "options.qml"
        }
    }
    Rectangle {
        id: controlArea
        x: 400
        y: 650
        width: 400
        height: 50
        opacity: 0.4
        color: "white"
        radius: 10
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter

            ToolButton {
                text: "Backward"
                iconSource: "backward.png"
                onClicked: {
                    player.seek(player.position - 10000)
                }
            }
            ToolButton {
                id: playPauseButton
                text: "Play"
                iconName: "aa"
                iconSource: "play.png"
                onClicked: {
                    console.log(player.playbackState)
                    if(player.playbackState === 0 || player.playbackState === 2) {
                        player.play()
                    }
                    else  {
                        player.pause()
                    }
                }
            }
            ToolButton {
                text: "Forward"
                iconSource: "forward.png"
                onClicked: {
                    player.seek(player.position + 10000)
                }
            }

            ToolButton {
                text: "Stop"
                iconSource: "stop.png"
                onClicked: {
                    player.stop()
                    backgroundimage.source="logo.png"
                }
            }
            Slider {
                id: audioSlider
                width: 195
                value: 0.5
                onValueChanged: player.volume = audioSlider.value
            }

        }
        FileDialog {
            id: fileDialog
            title: "Please choose a file"
            onAccepted: {
                player.pause()
                player.source=fileDialog.fileUrl
                backgroundimage.source=""
            }
            Component.onCompleted: visible = false
        }

    }
    //  Loader is used to dynamically load QML components.
    Loader {
        id: loader
    }

}

