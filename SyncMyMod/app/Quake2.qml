import QtQuick 2.6

Rectangle {
    id: rect
    anchors.fill: parent

    property string version: "";

    FontLoader { id: quakeFont; source: "res/dpquake_.ttf" }

    Image {
        id: background
        source: "./res/background.jpg"
    }

    Text {
        id: textlogo
        x: 234
        y: 97

        color: "#1a9c60"
        font.family: quakeFont.name
        font.pixelSize: 45
        font.bold: true
        style: Text.Outline
        styleColor: "black"

        visible: !startTimer.running

        text: "~"
        anchors.verticalCenterOffset: 0
        anchors.right: startGameText.left
        anchors.rightMargin: 120
        anchors.verticalCenter: startGameText.verticalCenter
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignLeft
    }

    Text {
        id: startGameText
        y: 80

        color: "#1a9c60"
        font.family: quakeFont.name
        font.pixelSize: 45
        font.bold: true
        style: Text.Outline
        styleColor: "black"

        visible: !startTimer.running

        text: "Start Game"
        anchors.horizontalCenter: parent.horizontalCenter
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignHCenter

        MouseArea {
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
            anchors.fill: parent
            anchors.bottomMargin: 0
            onPressed: textlogo.anchors.verticalCenter = startGameText.verticalCenter
            onReleased:	{
                startTimer.start()
                startQuake("vanilla");
            }
        }
    }

    Timer {
        id: startTimer
        running: false
        repeat: false
        triggeredOnStart: true
        interval: 15000
        onTriggered: {}
    }

    Text {
        id: loadingText
        width: 197
        height: 54
        anchors.centerIn: parent

        color: "#1a9c60"
        font.family: quakeFont.name
        font.pixelSize: 45
        font.bold: true
        style: Text.Outline
        styleColor: "black"

        visible: startTimer.running

        text: "Loading..."
        anchors.verticalCenterOffset: 0
        anchors.horizontalCenterOffset: 0

        MouseArea {
            anchors.fill: parent
            anchors.bottomMargin: 0
            onPressed: textlogo.anchors.verticalCenter = startGameText.verticalCenter
            onReleased:	{
                startTimer.start()
                startQuake("vanilla");
            }
        }
    }

    Text {
        id: exitText
        anchors.top: startGameText3.bottom
        anchors.horizontalCenter: startGameText3.horizontalCenter
        anchors.topMargin: 30

        color: "#1a9c60"
        font.family: quakeFont.name
        font.pixelSize: 45
        font.bold: true
        style: Text.Outline
        styleColor: "black"

        visible: !startTimer.running

        text: "Exit"
        anchors.horizontalCenterOffset: 0

        MouseArea {
            anchors.fill: parent
            onClicked: back()
            onPressed: textlogo.anchors.verticalCenter = exitText.verticalCenter
        }
    }

    Text {
        id: versionText
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 5

        color: "#1a9c60"
        font.family: quakeFont.name
        font.pixelSize: 13
        font.bold: true
        style: Text.Outline
        styleColor: "black"
        text: version

        MouseArea {
            anchors.fill: parent
            anchors.bottomMargin: 8
            onClicked: back()
            onPressed: textlogo.anchors.verticalCenter = exitText.verticalCenter
        }
    }

    Text {
        id: startGameText1
        color: "#1a9c60"
        font.family: quakeFont.name
        font.pixelSize: 45
        font.bold: true
        style: Text.Outline
        styleColor: "black"

        visible: !startTimer.running
        x: 199
        width: 437
        height: 53
        text: "Start The Reckoning"
        anchors.horizontalCenter: startGameText.horizontalCenter
        anchors.top: startGameText.bottom
        anchors.topMargin: 30

        MouseArea {
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
            anchors.fill: parent
            anchors.bottomMargin: 0
            onPressed: textlogo.anchors.verticalCenter = startGameText1.verticalCenter
            onReleased:	{
                startTimer.start()
                startQuake("xatrix");
            }
        }
    }

    Text {
        id: startGameText2
        color: "#1a9c60"
        font.family: quakeFont.name
        font.pixelSize: 45
        font.bold: true
        style: Text.Outline
        styleColor: "black"

        visible: !startTimer.running
        x: 199
        width: 414
        height: 55
        text: "Start Ground Zero"
        anchors.horizontalCenter: startGameText1.horizontalCenter
        anchors.top: startGameText1.bottom
        anchors.topMargin: 30

        MouseArea {
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
            anchors.fill: parent
            anchors.bottomMargin: 0
            onPressed: textlogo.anchors.verticalCenter = startGameText2.verticalCenter
            onReleased:	{
                startTimer.start()
                startQuake("rogue");
            }
        }
    }

    Text {
        id: startGameText3
        color: "#1a9c60"
        font.family: quakeFont.name
        font.pixelSize: 45
        font.bold: true
        style: Text.Outline
        styleColor: "black"

        visible: !startTimer.running
        x: 199
        width: 260
        height: 55
        text: "Start Zaero"
        anchors.horizontalCenter: startGameText2.horizontalCenter
        anchors.top: startGameText2.bottom
        anchors.topMargin: 30

        MouseArea {
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
            anchors.fill: parent
            anchors.bottomMargin: 0
            onPressed: textlogo.anchors.verticalCenter = startGameText3.verticalCenter
            onReleased:	{
                startTimer.start()
                startQuake("zaero");
            }
        }
    }

    Timer {
        id: versionTimer
        running: true
        repeat: false
        triggeredOnStart: true
        onTriggered: getVersion()
    }

    function getVersion() {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4) {
                version = "Version: " + xhr.responseText
            }
        }
        xhr.open("GET", "file:///fs/images/fmods_apps_data/Quake2/version.txt");
        xhr.send();
    }

    function startQuake(name) {
        var xhr = new XMLHttpRequest();
        var payload = "launch-" + name;
        xhr.open("PUT", "file:///fs/images/fmods_apps_data/Quake2/launcher");
        xhr.send(payload);
    }
}

