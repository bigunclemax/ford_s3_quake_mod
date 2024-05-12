import QtQuick 2.6

Rectangle {
    id: rect
    anchors.fill: parent

    FontLoader { id: quakeFont; source: "res/dpquake_.ttf" }

    Image {
        id: background
        source: "./res/background.jpg"
    }

    Text {
        id: textlogo
        anchors.verticalCenter: startGameText.verticalCenter
        anchors.right: startGameText.left
        anchors.rightMargin: 20

        color: "#1a9c60"
        font.family: quakeFont.name
        font.pixelSize: 45
        font.bold: true
        style: Text.Outline
        styleColor: "black"

        visible: !startTimer.running

        text: "Q"
    }

    Text {
        id: startGameText
        anchors.centerIn: parent

        color: "#1a9c60"
        font.family: quakeFont.name
        font.pixelSize: 45
        font.bold: true
        style: Text.Outline
        styleColor: "black"

        visible: !startTimer.running

        text: "Start Game"

        MouseArea {
            anchors.fill: parent
            anchors.bottomMargin: 8
            onPressed: textlogo.anchors.verticalCenter = startGameText.verticalCenter
            onReleased:	{
                startTimer.start()
                startQuake();
            }
        }
    }

    Timer {
        id: startTimer
        running: false
        repeat: false
        triggeredOnStart: true
        interval: 7000
        onTriggered: {}
    }

    Text {
        id: loadingText
        anchors.centerIn: parent

        color: "#1a9c60"
        font.family: quakeFont.name
        font.pixelSize: 45
        font.bold: true
        style: Text.Outline
        styleColor: "black"

        visible: startTimer.running

        text: "Loading..."

        MouseArea {
            anchors.fill: parent
            anchors.bottomMargin: 8
            onPressed: textlogo.anchors.verticalCenter = startGameText.verticalCenter
            onReleased:	{
                startTimer.start()
                startQuake();
            }
        }
    }

    Text {
        id: exitText
        anchors.top: startGameText.bottom
        anchors.horizontalCenter: startGameText.horizontalCenter
        anchors.topMargin: 30

        color: "#1a9c60"
        font.family: quakeFont.name
        font.pixelSize: 45
        font.bold: true
        style: Text.Outline
        styleColor: "black"

        visible: !startTimer.running

        text: "Exit"

        MouseArea {
            anchors.fill: parent
            anchors.bottomMargin: 8
            onClicked: back()
            onPressed: textlogo.anchors.verticalCenter = exitText.verticalCenter
        }
    }

    function startQuake() {
        var xhr = new XMLHttpRequest();
        var payload = "launch";
        xhr.open("PUT", "file:///fs/images/fmods_apps_data/Quake2/launcher");
        xhr.send(payload);
    }
}
