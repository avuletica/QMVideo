import QtQuick 2.3
import QtQuick.Window 2.2
import QtMultimedia 5.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Extras 1.4
import QtQuick.Controls.Styles 1.4

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
        }
    }
    // event handler for escape character (exit full screen)
    Item {
        anchors.fill: parent
        focus: true
        Keys.onPressed: {
            if (event.key == Qt.Key_Escape) {
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
        onPositionChanged: {
            progressbarSlider.value = player.position/player.duration
            //  Converting miliseconds to minutes and seconds.
            var currentTime = player.position
            var currentMin = Math.floor(currentTime/1000/60)
            var currentSec = (currentTime/1000) % 60
            currentSec = currentSec.toFixed(0)

            var totalTime = player.duration
            var totalMin =Math.floor(totalTime/1000/60)
            var totalSec = (totalTime/1000) % 60
            totalSec = totalSec.toFixed(0)

            progressText.text = currentMin + ':'+ currentSec + ' / ' + totalMin + ':' + totalSec

            if(player.position === 0) {
                progressText.text = '0:0 / 0:0'
            }
        }
        onPlaybackStateChanged: {
            if(player.playbackState === 0 || player.playbackState === 2) {
                playPauseButton.iconSource="play.png"
                backgroundimage.source=""
            }
            else {
                playPauseButton.iconSource="pause.png"
                backgroundimage.source=""
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
        onClicked: pieMenu.popup(mouseX, mouseY)
    }
    MouseArea {
        id: mouseArea1
        anchors.bottomMargin: 50
        anchors.fill: parent

        hoverEnabled: true
        onEntered: {
            controlArea.opacity = 0
            progressbarSlider.opacity = 0
            progressText.opacity = 0
        }
        onExited: {
            controlArea.opacity = 0.6
            progressbarSlider.opacity = 1
            progressText.opacity = 1
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
        x: 533
        y: 188
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
    Slider {
        id: progressbarSlider
        y: 652
        width: 250
        anchors.horizontalCenterOffset: -50
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50

        style: SliderStyle {
            groove: Rectangle {
                implicitWidth: 200
                implicitHeight: 8
                color: "red"
                radius: 8
            }
            handle: Rectangle {
                anchors.centerIn: parent
                color: control.pressed ? "white" : "lightgray"
                border.color: "gray"
                border.width: 2
                implicitWidth: 18
                implicitHeight: 18
                radius: 12
            }
        }
        onPressedChanged:  player.seek(progressbarSlider.value * player.duration)
        updateValueWhileDragging: true
    }
    Text {
        id: progressText
        x: 681
        y: 654
        color: "red"
        text: qsTr("0:0 / 0:0")
        anchors.bottom: parent.bottom
        anchors.rightMargin: -95
        anchors.right: progressbarSlider.right

        anchors.bottomMargin: 52
        font.bold: true
        font.pixelSize: 12
    }
    Rectangle {
        id: controlArea
        x: 400
        y: 650
        width: 350
        height: 50
        opacity: 0.6
        color: "white"
        radius: 2
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        RowLayout {
            width: 250
            anchors.centerIn: parent
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
