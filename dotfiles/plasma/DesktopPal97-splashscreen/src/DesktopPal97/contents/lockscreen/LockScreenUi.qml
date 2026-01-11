/*
    SPDX-FileCopyrightText: 2014 Aleix Pol Gonzalez <aleixpol@blue-systems.com>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQml 2.15
import QtQuick 2.8
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.workspace.components 2.0 as PW

import org.kde.plasma.private.sessions 2.0
import "../components"
import "../components/animation"

PlasmaCore.ColorScope {

    id: lockScreenUi
    // If we're using software rendering, draw outlines instead of shadows
    // See https://bugs.kde.org/show_bug.cgi?id=398317
    readonly property bool softwareRendering: GraphicsInfo.api === GraphicsInfo.Software
    property bool hadPrompt: false;

    colorGroup: PlasmaCore.Theme.ComplementaryColorGroup



    Connections {
        target: authenticator
        function onFailed() {
            if (root.notification) {
                root.notification += "\n"
            }
            root.notification += i18nd("plasma_lookandfeel_org.kde.lookandfeel","Unlocking failed");
            graceLockTimer.restart();
            notificationRemoveTimer.restart();
            rejectPasswordAnimation.start();
            lockScreenUi.hadPrompt = false;
        }

        function onSucceeded() {
            if (lockScreenUi.hadPrompt) {
                Qt.quit();
            } else {
                mainStack.forceActiveFocus();
                mainStack.push(Qt.resolvedUrl("NoPasswordUnlock.qml"),
                               {"userListModel": users});

            }
        }

        function onInfoMessage(msg) {
            if (root.notification) {
                root.notification += "\n"
            }
            root.notification += msg;
        }

        function onErrorMessage(msg) {
            if (root.notification) {
                root.notification += "\n"
            }
            root.notification += msg;
        }

        function onPrompt(msg) {
            root.notification = msg;
            mainBlock.mainPasswordBox.forceActiveFocus();
            lockScreenUi.hadPrompt = true;
        }
        function onPromptForSecret(msg) {
            mainBlock.mainPasswordBox.forceActiveFocus();
            lockScreenUi.hadPrompt = true;
        }
    }

    SessionManagement {
        id: sessionManagement
    }

    Connections {
        target: sessionManagement
        function onAboutToSuspend() {
            root.clearPassword();
        }
    }

    SessionsModel {
        id: sessionsModel
        showNewSessionEntry: false
    }

    PlasmaCore.DataSource {
        id: keystateSource
        engine: "keystate"
        connectedSources: "Caps Lock"
    }

    Loader {
        id: changeSessionComponent
        active: false
        source: "ChangeSession.qml"
        visible: false
    }

    RejectPasswordAnimation {
        id: rejectPasswordAnimation
        target: mainBlock
    }

    MouseArea {
        id: lockScreenRoot



        property bool calledUnlock: false
        property bool uiVisible: false
        property bool blockUI: mainStack.depth > 1 || mainBlock.mainPasswordBox.text.length > 0 || inputPanel.keyboardActive

        x: parent.x
        y: parent.y
        width: parent.width
        height: parent.height


        hoverEnabled: true
        drag.filterChildren: true
        onEntered: uiVisible = true
        onPressed: uiVisible = true;
        onPositionChanged: uiVisible = true;
        onUiVisibleChanged: {
            if (blockUI) {
                fadeoutTimer.running = false;
            } else if (uiVisible) {
                fadeoutTimer.restart();
            }
            if (!calledUnlock) {
                calledUnlock = true
                authenticator.tryUnlock();
            }
        }
        onBlockUIChanged: {
            if (blockUI) {
                fadeoutTimer.running = false;
                uiVisible = true;
            } else {
                fadeoutTimer.restart();
            }
        }
        Keys.onEscapePressed: {
            uiVisible = !uiVisible;
            if (inputPanel.keyboardActive) {
                inputPanel.showHide();
            }
            if (!uiVisible) {
                root.clearPassword();
            }
        }
        Keys.onPressed: {
            uiVisible = true;
            event.accepted = false;
        }
        Timer {
            id: fadeoutTimer
            interval: 100
            onTriggered: {
                if (!lockScreenRoot.blockUI) {
                    lockScreenRoot.uiVisible = false;
                }
            }
        }
        Timer {
            id: notificationRemoveTimer
            interval: 3000
            onTriggered: root.notification = ""
        }
        Timer {
            id: graceLockTimer
            interval: 3000
            onTriggered: {
                root.clearPassword();
                authenticator.tryUnlock();
            }
        }

        Component.onCompleted: PropertyAnimation { id: launchAnimation; target: lockScreenRoot; property: "opacity"; from: 0; to: 1; duration: PlasmaCore.Units.veryLongDuration * 2 }

        states: [
            State {
                name: "onOtherSession"
                // for slide out animation
                //PropertyChanges { target: lockScreenRoot; y: lockScreenRoot.height }
                // we also change the opacity just to be sure it's not visible even on unexpected screen dimension changes with possible race conditions
               // PropertyChanges { target: lockScreenRoot; opacity: 0 }
            }
        ]

        transitions:
            Transition {
            // we only animate switchting to another session, because kscreenlocker doesn't get notified when
            // coming from another session back and so we wouldn't know when to trigger the animation exactly
            from: ""
            to: "onOtherSession"

            PropertyAnimation { id: stateChangeAnimation; properties: "y"; duration: PlasmaCore.Units.shortDuration; easing.type: Easing.InQuad}
            PropertyAnimation { properties: "opacity"; duration: PlasmaCore.Units.shortDuration}

            onRunningChanged: {
                // after the animation has finished switch session: since we only animate the transition TO state "onOtherSession"
                // and not the other way around, we don't have to check the state we transitioned into
                if (/* lockScreenRoot.state == "onOtherSession" && */ !running) {
                    mainStack.currentItem.switchSession()
                }
            }
        }

          Image {
                id : backlock
        source : "wallpaper.png"
        fillMode: Image.Tile
        anchors.fill: parent

            }


        ListModel {
            id: users
            Component.onCompleted: {
                users.append({
                    name: kscreenlocker_userName,
                    realName: kscreenlocker_userName,
                    icon: kscreenlocker_userImage,
                })
            }
        }


ColumnLayout{
id:colMain
    width : 360
    height : 500
    anchors.centerIn : parent

     Image {

        id : promptbox

        source : "promptbox.svg"
        width : 360
        height : 500



            Clock {
            id: clock
            anchors.horizontalCenter: parent.horizontalCenter
            y : 8
            Layout.alignment: Qt.AlignBaseline
        }

Image {
            id: logo
//anchors.fill: parent
anchors.horizontalCenter: parent.horizontalCenter
anchors.top: parent.top
anchors.topMargin:47
            source: "desktoppal97.svg"
            width: 244
            height: 244


            }

            }


        StackView {
            id: mainStack
            anchors.fill: parent
            anchors.topMargin:270
            anchors.bottomMargin:160



            focus: true //StackView is an implicit focus scope, so we need to give this focus so the item inside will have it

            // this isn't implicit, otherwise items still get processed for the scenegraph
            visible: opacity > 0



            initialItem: MainBlock {
                id: mainBlock

                lockScreenUiVisible: lockScreenRoot.uiVisible

                // This is a focus scope and QQC1 StackView (unlike QQC2) does not set focus to the current item
                focus: true

                showUserList: userList.y + mainStack.y > 0

                enabled: !graceLockTimer.running

                Stack.onStatusChanged: {
                    // prepare for presenting again to the user
                    if (Stack.status === Stack.Activating) {
                        mainPasswordBox.remove(0, mainPasswordBox.length)
                        mainStack.forceActiveFocus();
                        root.notification = ""
                        //mainPasswordBox.forceActiveFocus();
                    }
                }

                 userListModel: users


                notificationMessage: {
                    const parts = [];
                    if (keystateSource.data["Caps Lock"]["Locked"]) {
                        parts.push(i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Caps Lock is on"));
                    }
                    if (root.notification) {
                        parts.push(root.notification);
                    }
                    return parts.join(" • ");
                }



                onPasswordResult: {
                    authenticator.respond(password)
                }

                Image {
            id : sleepButton
            source : "buttonup.svg"
            visible: root.suspendToRamSupported

            anchors.top: parent.top
            anchors.topMargin:44

            KeyNavigation.backtab : loginButton
            KeyNavigation.tab : hibernateButton
            Keys.onEnterPressed: root.suspendToRam()
            Keys.onReturnPressed: root.suspendToRam()

anchors{
    left : root.suspendToDiskSupported ?  parent.left : undefined
    leftMargin : root.suspendToDiskSupported ? 18 : 0
    horizontalCenter : root.suspendToDiskSupported ? undefined : parent.horizontalCenter
}

 Image {
    source : "buttonfocus.svg"
    anchors.fill : parent
    visible : sleepButton.focus
}


            MouseArea {
                anchors.fill : parent
                hoverEnabled : true

                onEntered : {
                    parent.source = "buttonhover.svg"
                }
                onExited : {
                    parent.source = "buttonup.svg"
                }
                onPressed : {
                    parent.source = "buttondown.svg"

                }
                onReleased : {
                    parent.source = "buttonup.svg"
                    root.suspendToRam()
                }
            }

            Image {
    source : "sleep.svg"
    anchors.verticalCenter: parent.verticalCenter
    x: 5
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
            id : hibernateButton
            source : "buttonup.svg"
            visible: root.suspendToDiskSupported
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin:44
            anchors.rightMargin : 18

            KeyNavigation.backtab : sleepButton
            KeyNavigation.tab : switchuserButton
            Keys.onEnterPressed: root.suspendToDisk()
            Keys.onReturnPressed: root.suspendToDisk()

            MouseArea {
                anchors.fill : parent
                hoverEnabled : true

                onEntered : {
                    parent.source = "buttonhover.svg"
                }
                onExited : {
                    parent.source = "buttonup.svg"
                }
                onPressed : {
                    parent.source = "buttondown.svg"

                }
                onReleased : {
                    parent.source = "buttonup.svg"
                    root.suspendToDisk()
                }
            }

            Image {
    source : "hibernate.svg"
    anchors.verticalCenter: parent.verticalCenter
    x: 5
}

 Image {
    source : "buttonfocus.svg"
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
            id : switchuserButton
            source : "buttonup.svg"
           visible: sessionsModel.canStartNewSession && sessionsModel.canSwitchUser
           anchors.horizontalCenter: parent.horizontalCenter
           anchors.top: parent.top
            anchors.topMargin:78
            anchors.rightMargin:18

            KeyNavigation.backtab : hibernateButton
            KeyNavigation.tab : mainPasswordBox
            Keys.onPressed : {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {

                     if (((sessionsModel.showNewSessionEntry && sessionsModel.count === 1) ||
                               (!sessionsModel.showNewSessionEntry && sessionsModel.count === 0)) &&
                               sessionsModel.canSwitchUser) {
                                mainStack.pop({immediate:true})
                                sessionsModel.startNewSession(true /* lock the screen too */)
                                lockScreenRoot.state = ''
                            } else {
                                mainStack.push({
                            item: switchSessionPage,
                            immediate: true
                        })
                            }


                        }
                    }

            MouseArea {
                anchors.fill : parent
                hoverEnabled : true

                onEntered : {
                    parent.source = "buttonhover.svg"
                }
                onExited : {
                    parent.source = "buttonup.svg"
                }
                onPressed : {
                    parent.source = "buttondown.svg"

                }
                onReleased : {
                    parent.source = "buttonup.svg"
                     if (((sessionsModel.showNewSessionEntry && sessionsModel.count === 1) ||
                               (!sessionsModel.showNewSessionEntry && sessionsModel.count === 0)) &&
                               sessionsModel.canSwitchUser) {
                                mainStack.pop({immediate:true})
                                sessionsModel.startNewSession(true /* lock the screen too */)
                                lockScreenRoot.state = ''
                            } else {
                                mainStack.push({
                            item: switchSessionPage,
                            immediate: true
                        })
                            }
                }
            }

            Image {
    source : "switchuser.svg"
    anchors.verticalCenter: parent.verticalCenter
    x: 5
}

 Image {
    source : "buttonfocus.svg"
    anchors.fill : parent
    visible : switchuserButton.focus
}

Rectangle{
    color: "#00000000"
    width: 132
    height: 30
    anchors.right : parent.right

            Text {
                text : i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Switch User")
                anchors.centerIn : parent
                    font.pointSize : 10
                    color : "#000000"
            }
}
        }




            }

            Component.onCompleted: {
                if (defaultToSwitchUser) { //context property
                    // If we are in the only session, then going to the session switcher is
                    // a pointless extra step; instead create a new session immediately
                    if (((sessionsModel.showNewSessionEntry && sessionsModel.count === 1)  ||
                       (!sessionsModel.showNewSessionEntry && sessionsModel.count === 0)) &&
                       sessionsModel.canStartNewSession) {
                        sessionsModel.startNewSession(true /* lock the screen too */)
                    } else {
                        mainStack.push({
                            item: switchSessionPage,
                            immediate: true,
                        });
                        //mainPasswordBox.forceActiveFocus()


                    }
                }
            }
        }

    }

Loader {
            id: inputPanel
            state: "hidden"
            readonly property bool keyboardActive: item ? item.active : false
            anchors {
                left: parent.left
                right: parent.right
            }
            function showHide() {
                state = "hidden";
            }
            Component.onCompleted: {
                inputPanel.source = Qt.platform.pluginName.includes("wayland") ? "../components/VirtualKeyboard_wayland.qml" : "../components/VirtualKeyboard.qml"
            }

            onKeyboardActiveChanged: {
                if (keyboardActive) {
                    state = "visible";
                } else {
                    state = "hidden";
                }
            }

            states: [
                State {
                    name: "visible"
                    PropertyChanges {
                        target: mainStack
                        y: Math.min(0, lockScreenRoot.height - inputPanel.height - mainBlock.visibleBoundary)
                    }
                    PropertyChanges {
                        target: inputPanel
                        y: lockScreenRoot.height - inputPanel.height
                    }
                },
                State {
                    name: "hidden"
                    PropertyChanges {
                        target: mainStack
                        y: 0
                    }
                    PropertyChanges {
                        target: inputPanel
                        y: lockScreenRoot.height - lockScreenRoot.height/4
                    }
                }
            ]
            transitions: [
                Transition {
                    from: "hidden"
                    to: "visible"
                    SequentialAnimation {
                        ScriptAction {
                            script: {
                                inputPanel.item.activated = true;
                                Qt.inputMethod.show();
                            }
                        }
                        ParallelAnimation {
                            NumberAnimation {
                                target: mainStack
                                property: "y"
                                duration: PlasmaCore.Units.shortDuration
                                easing.type: Easing.InOutQuad
                            }
                            NumberAnimation {
                                target: inputPanel
                                property: "y"
                                duration: PlasmaCore.Units.shortDuration
                                easing.type: Easing.OutQuad
                            }
                        }
                    }
                },
                Transition {
                    from: "visible"
                    to: "hidden"
                    SequentialAnimation {
                        ParallelAnimation {
                            NumberAnimation {
                                target: mainStack
                                property: "y"
                                duration: PlasmaCore.Units.shortDuration
                                easing.type: Easing.InOutQuad
                            }
                            NumberAnimation {
                                target: inputPanel
                                property: "y"
                                duration: PlasmaCore.Units.shortDuration
                                easing.type: Easing.InQuad
                            }
                            OpacityAnimator {
                                target: inputPanel
                                duration: PlasmaCore.Units.shortDuration
                                easing.type: Easing.InQuad
                            }
                        }
                        ScriptAction {
                            script: {
                                inputPanel.item.activated = false;
                                Qt.inputMethod.hide();
                            }
                        }
                    }
                }
            ]
        }

        Component {
            id: switchSessionPage
            SessionManagementScreen {



                property var switchSession: finalSwitchSession

                Stack.onStatusChanged: {
                    if (Stack.status == Stack.Activating) {
                        focus = true
                        switchToThisButton.forceActiveFocus()


                    }
                }



                userListModel: sessionsModel

                // initiating animation of lockscreen for session switch
                function initSwitchSession() {
                    lockScreenRoot.state = 'onOtherSession'
                }

                // initiating session switch and preparing lockscreen for possible return of user
                function finalSwitchSession() {
                    mainStack.pop({immediate:true})
                    if (userListCurrentItem === null) {
                        console.warn("Switching to an undefined user")
                    } else if (userListCurrentItem.vtNumber === undefined) {
                        console.warn("Switching to an undefined VT")
                    }
                    sessionsModel.switchUser(userListCurrentItem.vtNumber)
                    lockScreenRoot.state = ''
                }

                Keys.onLeftPressed: userList.decrementCurrentIndex()
                Keys.onRightPressed: userList.incrementCurrentIndex()
                Keys.onEscapePressed: mainStack.pop({immediate:true})


                ColumnLayout {
                    Layout.fillWidth: true
                    anchors.fill: parent
                    //focus:true


                    //spacing: PlasmaCore.Units.largeSpacing

                /*      Rectangle{
          y:parent.bottom
        width: 360
        height: 100
        //color: "#555577"
        }*/

            Image {
                id: switchToThisButton
            source : "buttonup2.svg"
            visible: sessionsModel.count > 0
            //focus : true
            KeyNavigation.backtab : backButton
            KeyNavigation.tab : newSessionButton
            Keys.onEnterPressed: initSwitchSession()
            Keys.onReturnPressed: initSwitchSession()

            MouseArea {
                anchors.fill : parent
                hoverEnabled : true

                onEntered : {
                    parent.source = "buttonhover2.svg"
                }
                onExited : {
                    parent.source = "buttonup2.svg"
                }
                onPressed : {
                    parent.source = "buttondown2.svg"

                }
                onReleased : {
                    parent.source = "buttonup2.svg"
                    initSwitchSession()
                }
            }


            Image {
    source : "switchuser.svg"
    anchors.verticalCenter: parent.verticalCenter
    x: 5
}

Image {
    source : "buttonfocus2.svg"
    anchors.fill : parent
    visible : switchToThisButton.focus
}

Rectangle{
    color: "#00000000"
    width: 202
    height: 30
    anchors.right : parent.right

            Text {
                text : i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Switch to This Session")
                anchors.centerIn : parent
                    font.pointSize : 10
                    color : "#000000"
            }
}
        }


        Image {
            id: newSessionButton
            source : "buttonup2.svg"
            visible: sessionsModel.count > 0
            KeyNavigation.backtab : switchToThisButton
            KeyNavigation.tab : backButton

            Keys.onPressed : {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            parent.source = "buttonup2.svg"
                            mainStack.pop({immediate:true})
                            sessionsModel.startNewSession(true /* lock the screen too */)
                            lockScreenRoot.state = ''

                        }
                    }


            MouseArea {
                anchors.fill : parent
                hoverEnabled : true

                onEntered : {
                    parent.source = "buttonhover2.svg"
                }
                onExited : {
                    parent.source = "buttonup2.svg"
                }
                onPressed : {
                    parent.source = "buttondown2.svg"

                }
                onReleased : {
                    parent.source = "buttonup2.svg"
                    mainStack.pop({immediate:true})
                    sessionsModel.startNewSession(true /* lock the screen too */)
                    lockScreenRoot.state = ''

                }
            }


            Image {
    source : "newuser.svg"
    anchors.verticalCenter: parent.verticalCenter
    x: 5
}

Image {
    source : "buttonfocus2.svg"
    anchors.fill : parent
    visible : newSessionButton.focus
}

Rectangle{
    color: "#00000000"
    width: 202
    height: 30
    anchors.right : parent.right

            Text {
                text : i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Start New Session")
                anchors.centerIn : parent
                    font.pointSize : 10
                    color : "#000000"
            }

}

        }


         Image {
             id:backButton
            source : "buttonup.svg"
            visible: sessionsModel.count > 0
             anchors.horizontalCenter: parent.horizontalCenter
             KeyNavigation.backtab : newSessionButton
            KeyNavigation.tab : switchToThisButton

            Keys.onPressed : {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                             mainStack.pop({immediate:true})

                        }
                    }

            MouseArea {
                anchors.fill : parent
                hoverEnabled : true

                onEntered : {
                    parent.source = "buttonhover.svg"
                }
                onExited : {
                    parent.source = "buttonup.svg"
                }
                onPressed : {
                    parent.source = "buttondown.svg"

                }
                onReleased : {
                    parent.source = "buttonup.svg"
                   mainStack.pop({immediate:true})



                }
            }

             Image {
    source : "backicon.svg"
    anchors.verticalCenter: parent.verticalCenter
    x: 5
}

Image {
    source : "buttonfocus2.svg"
    anchors.fill : parent
    visible : backButton.focus
}

Rectangle{
    color: "#00000000"
    width: 132
    height: 30
    anchors.right : parent.right

            Text {
                text : i18nd("plasma_lookandfeel_org.kde.lookandfeel","Back")
                anchors.centerIn : parent
                    font.pointSize : 10
                    color : "#000000"
            }
}
        }


                }




            }
        }



        RowLayout {
            id: footer
            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                margins: PlasmaCore.Units.smallSpacing
            }



            Loader {

                    Layout.fillWidth: true
                    Layout.preferredHeight: item ? item.implicitHeight : 0
                    active: config.showMediaControls
                    source: "MediaControls.qml"
                }


            Item {
                Layout.fillWidth: true
            }

          /*  Battery {} */
        }
    }
}
