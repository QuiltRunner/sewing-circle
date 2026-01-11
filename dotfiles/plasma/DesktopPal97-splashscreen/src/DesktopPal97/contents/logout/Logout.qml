/*
    SPDX-FileCopyrightText: 2014 Aleix Pol Gonzalez <aleixpol@blue-systems.com>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.2
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.12 as QQC2

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kcoreaddons 1.0 as KCoreAddons

import "../components"
import "timer.js" as AutoTriggerTimer

import org.kde.plasma.private.sessions 2.0

PlasmaCore.ColorScope {
    id: root
    colorGroup: PlasmaCore.Theme.ComplementaryColorGroup
    height: screenGeometry.height
    width: screenGeometry.width

    signal logoutRequested()
    signal haltRequested()
    signal suspendRequested(int spdMethod)
    signal rebootRequested()
    signal rebootRequested2(int opt)
    signal cancelRequested()
    signal lockScreenRequested()



    function sleepRequested() {
        root.suspendRequested(2);
    }

    function hibernateRequested() {
        root.suspendRequested(4);
    }

    property real timeout: 30
    property real remainingTime: root.timeout
    property var currentAction: {
        switch (sdtype) {
            case ShutdownType.ShutdownTypeReboot:
                return root.rebootRequested;
            case ShutdownType.ShutdownTypeHalt:
                return root.haltRequested;
            default:
                return root.logoutRequested;
        }
    }

    KCoreAddons.KUser {
        id: kuser
    }

    // For showing a "other users are logged in" hint
    SessionsModel {
        id: sessionsModel
        includeUnusedSessions: false
    }

    QQC2.Action {
        onTriggered: root.cancelRequested()
        shortcut: "Escape"
    }

    onRemainingTimeChanged: {
        if (remainingTime <= 0) {
            root.currentAction();
        }
    }

    Timer {
        id: countDownTimer
        running: true
        repeat: true
        interval: 1000
        onTriggered: remainingTime--
        Component.onCompleted: {
            AutoTriggerTimer.addCancelAutoTriggerCallback(function() {
                countDownTimer.running = false;
            });
        }
    }

    function isLightColor(color) {
        return Math.max(color.r, color.g, color.b) > 0.5
    }



    Image {
                id : backlock
        source : "../lockscreen/wallpaper.png"
        fillMode: Image.Tile
        anchors.fill: parent

            }

    MouseArea {
        anchors.fill: parent
        onClicked: root.cancelRequested()
    }

    Image {
        id : promptbox
        source : "../lockscreen/promptbox.svg"
        width : 360
        height : 500
        anchors.centerIn : parent

    Image {
            id: logo
//anchors.fill: parent
anchors.horizontalCenter: parent.horizontalCenter
anchors.top: parent.top
anchors.topMargin:47
            source: "../lockscreen/desktoppal97.svg"
            width: 244
            height: 244

    }


    UserDelegate {
        width: PlasmaCore.Units.gridUnit * 1
        height: PlasmaCore.Units.gridUnit * 1
        anchors {
            horizontalCenter: parent.horizontalCenter

            //bottom: parent.verticalCenter
        }
                    y:302
        constrainText: false
        avatarPath: kuser.faceIconUrl
        iconSource: "user-identity"
        isCurrent: true
        name: kuser.fullName
    }




    ColumnLayout {
        y:356
         anchors {
        //     top: parent.verticalCenter
        //     topMargin: PlasmaCore.Units.gridUnit * 2
             horizontalCenter: parent.horizontalCenter
         }
        //spacing: PlasmaCore.Units.largeSpacing

        //height: Math.max(implicitHeight, PlasmaCore.Units.gridUnit * 10)
        //width: Math.max(implicitWidth, PlasmaCore.Units.gridUnit * 16)



        RowLayout {
            //spacing: PlasmaCore.Units.largeSpacing * 2
            Layout.alignment: Qt.AlignHCenter

        Image {
            id : rebootButton
            source : "../lockscreen/buttonup.svg"
            visible: maysd

            KeyNavigation.backtab : cancelButton
            KeyNavigation.tab : shutdownButton
            Keys.onPressed : {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            root.rebootRequested()
                        }
                    }

            MouseArea {
                anchors.fill : parent
                hoverEnabled : true
                onEntered : {
                    parent.source = "../lockscreen/buttonhover.svg"
                }
                onExited : {
                    parent.source = "../lockscreen/buttonup.svg"
                }
                onPressed : {
                    parent.source = "../lockscreen/buttondown.svg"
                }
                onReleased : {
                    parent.source = "../lockscreen/buttonup.svg"
                    root.rebootRequested()
                }
            }

                        Image {
    source : "../lockscreen/restart.svg"
    anchors.verticalCenter: parent.verticalCenter
    x: 5
}

Image {
    source : "../lockscreen/buttonfocus.svg"
    anchors.fill : parent
    visible : rebootButton.focus
}

Rectangle{
    color: "#00000000"
    width: 132
    height: 30
    anchors.right : parent.right

            Text {
                text : i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Restart")
                anchors.centerIn : parent
                font.pointSize : 10
                color : "#000000"
            }
}
        }

        Image {
            id : shutdownButton
            source : "../lockscreen/buttonup.svg"
            visible: maysd

            KeyNavigation.backtab : rebootButton
            KeyNavigation.tab : sleepButton
            Keys.onPressed : {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            root.haltRequested()
                        }
                    }

            MouseArea {
                anchors.fill : parent
                hoverEnabled : true
                onEntered : {
                    parent.source = "../lockscreen/buttonhover.svg"
                }
                onExited : {
                    parent.source = "../lockscreen/buttonup.svg"
                }
                onPressed : {
                    parent.source = "../lockscreen/buttondown.svg"
                }
                onReleased : {
                    parent.source = "../lockscreen/buttonup.svg"
                    root.haltRequested()
                }
            }

                        Image {
    source : "../lockscreen/shutdown.svg"
    anchors.verticalCenter: parent.verticalCenter
    x: 5
}

Image {
    source : "../lockscreen/buttonfocus.svg"
    anchors.fill : parent
    visible : shutdownButton.focus
}

Rectangle{
    color: "#00000000"
    width: 132
    height: 30
    anchors.right : parent.right

            Text {
                text : i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Shut Down")
                anchors.centerIn : parent
                font.pointSize : 10
                color : "#000000"
            }
}


        }

        }

        RowLayout {
            //spacing: PlasmaCore.Units.largeSpacing * 2
            Layout.alignment: Qt.AlignHCenter

            Image {
            id : sleepButton
            source : "../lockscreen/buttonup.svg"
            visible: spdMethods.SuspendState

            KeyNavigation.backtab : shutdownButton
            KeyNavigation.tab : logoutButton
            Keys.onPressed : {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            root.suspendRequested(2)
                        }
                    }

            MouseArea {
                anchors.fill : parent
                hoverEnabled : true
                onEntered : {
                    parent.source = "../lockscreen/buttonhover.svg"
                }
                onExited : {
                    parent.source = "../lockscreen/buttonup.svg"
                }
                onPressed : {
                    parent.source = "../lockscreen/buttondown.svg"
                }
                onReleased : {
                    parent.source = "../lockscreen/buttonup.svg"
                    root.suspendRequested(2)
                }
            }

            Image {
    source : "../lockscreen/sleep.svg"
    anchors.verticalCenter: parent.verticalCenter
    x: 5
}

Image {
    source : "../lockscreen/buttonfocus.svg"
    anchors.fill : parent
    visible : sleepButton.focus
}

Rectangle{
    color: "#00000000"
    width: 132
    height: 30
    anchors.right : parent.right

            Text {
                text : i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Sleep")
                anchors.centerIn : parent
                font.pointSize : 10
                color : "#000000"
            }
}
        }

        Image {
            id : logoutButton
            source : "../lockscreen/buttonup.svg"
            visible: canLogout
            focus : true

            KeyNavigation.backtab : sleepButton
            KeyNavigation.tab : hibernateButton
            Keys.onPressed : {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            root.logoutRequested()
                        }
                    }

            MouseArea {
                anchors.fill : parent
                hoverEnabled : true
                onEntered : {
                    parent.source = "../lockscreen/buttonhover.svg"
                }
                onExited : {
                    parent.source = "../lockscreen/buttonup.svg"
                }
                onPressed : {
                    parent.source = "../lockscreen/buttondown.svg"
                }
                onReleased : {
                    parent.source = "../lockscreen/buttonup.svg"
                    root.logoutRequested()
                }
            }

            Image {
    source : "../lockscreen/logout.svg"
    anchors.verticalCenter: parent.verticalCenter
    x: 5
}

Image {
    source : "../lockscreen/buttonfocus.svg"
    anchors.fill : parent
    visible : logoutButton.focus
}

Rectangle{
    color: "#00000000"
    width: 132
    height: 30
    anchors.right : parent.right

            Text {
                text : i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Log Out")
                anchors.centerIn : parent
                font.pointSize : 10
                color : "#000000"
            }
}
        }


        }



        RowLayout {
            //spacing: PlasmaCore.Units.largeSpacing * 2
            Layout.alignment: Qt.AlignHCenter


        Image {
            id : hibernateButton
            source : "../lockscreen/buttonup.svg"
            visible: spdMethods.HibernateState

            KeyNavigation.backtab : logoutButton
            KeyNavigation.tab : cancelButton
            Keys.onPressed : {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            root.suspendRequested(4)
                        }
                    }

            MouseArea {
                anchors.fill : parent
                hoverEnabled : true
                onEntered : {
                    parent.source = "../lockscreen/buttonhover.svg"
                }
                onExited : {
                    parent.source = "../lockscreen/buttonup.svg"
                }
                onPressed : {
                    parent.source = "../lockscreen/buttondown.svg"
                }
                onReleased : {
                    parent.source = "../lockscreen/buttonup.svg"
                    root.suspendRequested(4)
                }
            }

            Image {
    source : "../lockscreen/hibernate.svg"
    anchors.verticalCenter: parent.verticalCenter
    x: 5
}

Image {
    source : "../lockscreen/buttonfocus.svg"
    anchors.fill : parent
    visible : hibernateButton.focus
}

Rectangle{
    color: "#00000000"
    width: 132
    height: 30
    anchors.right : parent.right

            Text {
                text : i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Hibernate")
                anchors.centerIn : parent
                font.pointSize : 10
                color : "#000000"
            }
}
        }


        Image {
            id : cancelButton
            source : "../lockscreen/buttonup.svg"
            visible: canLogout

            KeyNavigation.backtab : hibernateButton
            KeyNavigation.tab : rebootButton
            Keys.onPressed : {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            root.cancelRequested()
                        }
                    }

            MouseArea {
                anchors.fill : parent
                hoverEnabled : true
                onEntered : {
                    parent.source = "../lockscreen/buttonhover.svg"
                }
                onExited : {
                    parent.source = "../lockscreen/buttonup.svg"
                }
                onPressed : {
                    parent.source = "../lockscreen/buttondown.svg"
                }
                onReleased : {
                    parent.source = "../lockscreen/buttonup.svg"
                    root.cancelRequested()
                }
            }

            Image {
    source : "../lockscreen/backicon.svg"
    anchors.verticalCenter: parent.verticalCenter
    x: 5
}

Image {
    source : "../lockscreen/buttonfocus.svg"
    anchors.fill : parent
    visible : cancelButton.focus
}

Rectangle{
    color: "#00000000"
    width: 132
    height: 30
    anchors.right : parent.right

            Text {
                text : i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Cancel")
                anchors.centerIn : parent
                font.pointSize : 10
                color : "#000000"
            }
}
        }



        }


    }




     PlasmaComponents.Label {
            font.pointSize: 10
            color : "#000000"
            anchors.horizontalCenter: parent.horizontalCenter



            anchors.bottom:parent.bottom
            anchors.bottomMargin:16

            Layout.alignment: Qt.AlignHCenter
            //opacity, as visible would re-layout
            opacity: countDownTimer.running ? 1 : 0
            Behavior on opacity {
                OpacityAnimator {
                    duration: PlasmaCore.Units.longDuration
                    easing.type: Easing.InOutQuad
                }
            }
            text: {
                switch (sdtype) {
                    case ShutdownType.ShutdownTypeReboot:
                        return i18ndp("plasma_lookandfeel_org.kde.lookandfeel", "Restarting in 1 second", "Restarting in %1 seconds", root.remainingTime);
                    case ShutdownType.ShutdownTypeHalt:
                        return i18ndp("plasma_lookandfeel_org.kde.lookandfeel", "Shutting down in 1 second", "Shutting down in %1 seconds", root.remainingTime);
                    default:
                        return i18ndp("plasma_lookandfeel_org.kde.lookandfeel", "Logging out in 1 second", "Logging out in %1 seconds", root.remainingTime);
                }
            }
        }


            }




              ColumnLayout {
                  width:parent.width
                  anchors.bottom:parent.bottom
                  anchors.bottomMargin:20


         PlasmaComponents.Label {
            font.pointSize: 10
            color: "red"
            //Layout.maximumWidth: 340
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            font.italic: true
            text: i18ndp("plasma_lookandfeel_org.kde.lookandfeel",
                         "One other user is currently logged in. If the computer is shut down or restarted, that user may lose work.",
                         "%1 other users are currently logged in. If the computer is shut down or restarted, those users may lose work.",
                         sessionsModel.count)
            visible: sessionsModel.count > 0
        }

        PlasmaComponents.Label {
            font.pointSize: 10
            color: "red"
            //Layout.maximumWidth: 340
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            font.italic: true
            text: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "When restarted, the computer will enter the firmware setup screen.")
            visible: rebootToFirmwareSetup
        }

}

Component.onCompleted: {
    if(sdtype == ShutdownType.ShutdownTypeReboot){
        rebootButton.focus = true;
    }else if(sdtype == ShutdownType.ShutdownTypeHalt){
        shutdownButton.focus = true;
    }

            }

}
