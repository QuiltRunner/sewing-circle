/*
    SPDX-FileCopyrightText: 2016 David Edmundson <davidedmundson@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick 2.2

import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3

import "../components"

SessionManagementScreen {


    property Item mainPasswordBox: passwordBox
    property bool lockScreenUiVisible: false
    property alias echoMode: passwordBox.echoMode

    //the y position that should be ensured visible when the on screen keyboard is visible
   // property int visibleBoundary: mapFromItem(loginButton, 0, 0).y
   // onHeightChanged: visibleBoundary = mapFromItem(loginButton, 0, 0).y + loginButton.height + PlasmaCore.Units.smallSpacing
    /*
     * Login has been requested with the following username and password
     * If username field is visible, it will be taken from that, otherwise from the "name" property of the currentIndex
     */
    signal passwordResult(string password)

    onUserSelected: {
        const nextControl = (passwordBox.visible ? passwordBox : loginButton);
        // Don't startLogin() here, because the signal is connected to the
        // Escape key as well, for which it wouldn't make sense to trigger
        // login. Using TabFocusReason, so that the loginButton gets the
        // visual highlight.
        nextControl.forceActiveFocus(Qt.TabFocusReason);
    }

    function startLogin() {
        const password = passwordBox.text

        // This is partly because it looks nicer, but more importantly it
        // works round a Qt bug that can trigger if the app is closed with a
        // TextField focused.
        //
        // See https://bugreports.qt.io/browse/QTBUG-55460
        loginButton.forceActiveFocus();
        passwordResult(password);
    }


  Rectangle{
            width:320
        height: parent.height
        color: "#ffffff"
        }


        PlasmaComponents3.TextField {
            id: passwordBox
            font.pointSize: 10 //PlasmaCore.Theme.defaultFont.pointSize + 1
             anchors.left: parent.left
             anchors.top: parent.top
             anchors.leftMargin:52
            implicitWidth : 180
            implicitHeight : 32
            //Layout.fillWidth: true
topPadding: 0
        bottomPadding: 0
        leftPadding: 6
        rightPadding: 6
            placeholderText: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Password")
            background : Image {
                        source : passwordBox.focus ? "inputfocus.svg" : "input.svg"
                    }
            color: "#000000"
            placeholderTextColor:"#000000"
            //focus: true
            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhHiddenText | Qt.ImhSensitiveData | Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
            enabled: !authenticator.graceLocked
            revealPasswordButtonShown: false

            // In Qt this is implicitly active based on focus rather than visibility
            // in any other application having a focussed invisible object would be weird
            // but here we are using to wake out of screensaver mode
            // We need to explicitly disable cursor flashing to avoid unnecessary renders
            //cursorVisible: visible

            onAccepted: {
                if (lockScreenUiVisible) {
                    startLogin();
                }
            }

            //if empty and left or right is pressed change selection in user switch
            //this cannot be in keys.onLeftPressed as then it doesn't reach the password box
            Keys.onPressed: {
                if (event.key == Qt.Key_Left && !text) {
                    userList.decrementCurrentIndex();
                    event.accepted = true
                }
                if (event.key == Qt.Key_Right && !text) {
                    userList.incrementCurrentIndex();
                    event.accepted = true
                }
            }

            Connections {
                target: root
                function onClearPassword() {
                    passwordBox.forceActiveFocus()
                    passwordBox.text = "";
                }
            }
        }


        PlasmaComponents3.Button {
            id: loginButton

           // Layout.preferredHeight: passwordBox.implicitHeight
           // Layout.preferredWidth: loginButton.Layout.preferredHeight
            anchors.right: parent.right
             anchors.top: parent.top
             //anchors.topMargin:1
             anchors.rightMargin:52

            width:32
            height:32

            Image {
    source : "buttonfocus2b.svg"
    anchors.fill : parent
    visible : loginButton.focus
}

            background : Image {
                source : "button2up.svg"

Text {
          //  width: parent.width
           // height: parent.width
             anchors.centerIn : parent
            text: " "//i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Unlock")
            color: "#000000"
            font.pointSize: 16
          }

                        MouseArea {
                anchors.fill : parent
                hoverEnabled : true

                onEntered : {
                    parent.source = "button2hover.svg"
                }
                onExited : {
                    parent.source = "button2up.svg"
                }
                onPressed : {
                    parent.source = "button2down.svg"
                    startLogin()

                }
                onReleased : {
                    parent.source = "button2up.svg"
                }
            }
                    }

            //icon.name: LayoutMirroring.enabled ? "go-previous" : "go-next"

            onClicked: startLogin()
            Keys.onEnterPressed: clicked()
            Keys.onReturnPressed: clicked()
            KeyNavigation.backtab : passwordBox
            KeyNavigation.tab : sleepButton
        }

}
