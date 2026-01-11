/*
    SPDX-FileCopyrightText: 2016 David Edmundson <davidedmundson@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick 2.15

import QtQuick.Layouts 1.15

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3

FocusScope {
    id: root

    /* Rectangle{
            width: parent.width
        height: parent.height
        color: "#ffffff"

        }*/


    /*
     * Any message to be displayed to the user, visible above the text fields
     */
    property alias notificationMessage: notificationsLabel.text

    /*
     * A list of Items (typically ActionButtons) to be shown in a Row beneath the prompts
     */
    property alias actionItems: actionItemsLayout.children

    /*
     * Whether to show or hide the list of action items as a whole.
     */
    property alias actionItemsVisible: actionItemsLayout.visible

    /*
     * A model with a list of users to show in the view
     * The following roles should exist:
     *  - name
     *  - iconSource
     *
     * The following are also handled:
     *  - vtNumber
     *  - displayNumber
     *  - session
     *  - isTty
     */
    property alias userListModel: userListView.model

    /*
     * Self explanatory
     */
    property alias userListCurrentIndex: userListView.currentIndex
    property alias userListCurrentItem: userListView.currentItem
    property bool showUserList: true

    property alias userList: userListView

    property int fontSize: PlasmaCore.Theme.defaultFont.pointSize + 2

    default property alias _children: innerLayout.children

    signal userSelected()

    // FIXME: move this component into a layout, rather than abusing
    // anchors and implicitly relying on other components' built-in
    // whitespace to avoid items being overlapped.




    UserList {
        id: userListView
        visible: showUserList && y > 0

        anchors {
            top: parent.verticalCenter
            // We only need an extra bottom margin when text is constrained,
            // since only in this case can the username label be a multi-line
            // string that would otherwise overflow.
            bottomMargin: 0 //constrainText ? PlasmaCore.Units.gridUnit * 3 : 0
            left: parent.left
            right: parent.right
        }
        fontSize: 12
        // bubble up the signal
        onUserSelected: root.userSelected()
    }

Rectangle{
            width: 350
        height: 44
        x:5
        anchors.top: parent.verticalCenter
        color: "#00000000"
        z:1
        visible: {
            if(userListModel == sessionsModel && sessionsModel.count > 1){
                return true
            }else{
                return false
            }
        }

            Image{
                width: 24
                height: 44
                source: "../lockscreen/back.svg"
                anchors.left:parent.left

                MouseArea {
                anchors.fill : parent
                hoverEnabled : true

                onEntered : {
                    parent.source = "../lockscreen/backhover.svg"
                }
                onExited : {
                    parent.source = "../lockscreen/back.svg"
                }
                onPressed : {
                    parent.source = "../lockscreen/backdown.svg"
                    userList.decrementCurrentIndex()
                    root.userSelected()

                }
                onReleased : {
                    parent.source = "../lockscreen/backhover.svg"
                }
            }

            }

            Image{
                width: 24
                height: 44
                source: "../lockscreen/next.svg"
                anchors.right:parent.right

                MouseArea {
                anchors.fill : parent
                hoverEnabled : true

                onEntered : {
                    parent.source = "../lockscreen/nexthover.svg"
                }
                onExited : {
                    parent.source = "../lockscreen/next.svg"
                }
                onPressed : {
                    parent.source = "../lockscreen/nextdown.svg"
                    userList.incrementCurrentIndex()
                    root.userSelected()

                }
                onReleased : {
                    parent.source = "../lockscreen/nexthover.svg"
                }
            }

            }

        }

    //goal is to show the prompts, in ~16 grid units high, then the action buttons
    //but collapse the space between the prompts and actions if there's no room
    //ui is constrained to 16 grid units wide, or the screen
    ColumnLayout {
        id: prompts

        anchors.topMargin: 0//PlasmaCore.Units.gridUnit * 0.5
       anchors.fill : parent


        PlasmaComponents3.Label {
            id: notificationsLabel
            anchors.fill : parent
            anchors.bottom : parent.bottom
            topPadding:80
            anchors.topMargin:30
            font.pointSize: 10
            Layout.maximumWidth: parent.width//PlasmaCore.Units.gridUnit * 16
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            color: "red"

            //font.italic: true
        }

        ColumnLayout {
            //Layout.minimumHeight: implicitHeight
            //Layout.maximumHeight: 40 //PlasmaCore.Units.gridUnit * 10
            Layout.maximumWidth: parent.width //PlasmaCore.Units.gridUnit * 16
            Layout.alignment: Qt.AlignHCenter
            ColumnLayout {
                id: innerLayout
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
            }
            Item {
                Layout.fillHeight: true
            }
        }
        Item {
            Layout.alignment: Qt.AlignHCenter
            implicitHeight: 32//actionItemsLayout.implicitHeight
            implicitWidth: parent.width//actionItemsLayout.implicitWidth


            Row { //deliberately not rowlayout as I'm not trying to resize child items
                id: actionItemsLayout
                anchors.verticalCenter: parent.top
                spacing: 10//PlasmaCore.Units.largeSpacing / 2
            }
        }
        Item {
            Layout.fillHeight: true
        }
    }





}
