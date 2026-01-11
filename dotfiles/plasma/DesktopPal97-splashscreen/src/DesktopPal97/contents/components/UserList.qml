/*
    SPDX-FileCopyrightText: 2014 David Edmundson <davidedmundson@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick 2.15

import org.kde.plasma.core 2.0 as PlasmaCore


ListView {
    id: view
    readonly property string selectedUser: currentItem ? currentItem.userName : ""
    readonly property int userItemWidth: 300//parent.width//PlasmaCore.Units.gridUnit * 20
    readonly property int userItemHeight: 40//PlasmaCore.Units.gridUnit * 3
    readonly property bool constrainText: count > 1
    property int fontSize: PlasmaCore.Theme.defaultFont.pointSize + 2

    implicitHeight: userItemHeight

    activeFocusOnTab: false

    highlightMoveDuration: 0

    /*
     * Signals that a user was explicitly selected
     */
    signal userSelected()

    orientation: ListView.Horizontal
    highlightRangeMode: ListView.StrictlyEnforceRange


    //centre align selected item (which implicitly centre aligns the rest
    preferredHighlightBegin: width/2 - userItemWidth/2
    preferredHighlightEnd: preferredHighlightBegin

    // Disable flicking if we only have on user (like on the lockscreen)
    interactive: count > 1

    delegate: UserDelegate {
        avatarPath: model.icon || ""
        iconSource: model.iconName || "user-identity"
        fontSize: view.fontSize
        vtNumber: model.vtNumber
        needsPassword: model.needsPassword

        name: {
            const displayName = model.realName || model.name

            if (model.vtNumber === undefined || model.vtNumber < 0) {
                return displayName
            }

            if (!model.session) {
                return i18ndc("plasma_lookandfeel_org.kde.lookandfeel", "Nobody logged in on that session", "Unused")
            }



            return displayName
        }

        userName: model.name

        width: userItemWidth
        height: userItemHeight

        //if we only have one delegate, we don't need to clip the text as it won't be overlapping with anything
        constrainText: view.constrainText

        isCurrent: ListView.isCurrentItem

      /* onClicked: {
            ListView.view.currentIndex = index;
            ListView.view.userSelected();
        }*/
    }

    Keys.onEscapePressed: view.userSelected()
    Keys.onEnterPressed: view.userSelected()
    Keys.onReturnPressed: view.userSelected()
}
