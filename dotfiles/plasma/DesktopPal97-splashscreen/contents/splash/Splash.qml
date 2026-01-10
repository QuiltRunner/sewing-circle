/*
 * Copyright 2014 Marco Martin <mart@kde.org>
 *
 * GPLv2 or later
 */

import QtQuick 2.15
import QtQuick.Window 2.15

Rectangle {
    id: root
    color: "#ffffff"

    // ksplash provides/sets this when running the splash
    // Keeping it so stage transitions still work.
    property int stage: 0

    onStageChanged: {
        if (stage === 1) {
            introAnimation.running = true
            rotationAnimator.running = true
        } else if (stage === 5) {
            // Fade out the busy indicator when we're done
            outroAnimation.running = true
        }
    }

    Item {
        id: content
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        opacity: 0
        width: 400
        height: 560

        Image {
            id: logo
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            source: "images/desktoppal97.svg"
            width: 400
            height: 400
            fillMode: Image.PreserveAspectFit
            smooth: true
        }

        Image {
            id: busyIndicator
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            source: "images/busywidget.svg"
            width: 128
            height: 128
            smooth: true

            RotationAnimator on rotation {
                id: rotationAnimator
                from: 0
                to: 360
                duration: 2600
                loops: Animation.Infinite
                running: false   // we turn it on at stage 1
            }
        }
    }

    OpacityAnimator {
        id: introAnimation
        target: content
        from: 0
        to: 1
        duration: 2000
        easing.type: Easing.InOutQuad
        running: false
    }

    OpacityAnimator {
        id: outroAnimation
        target: busyIndicator
        from: 1
        to: 0
        duration: 700
        easing.type: Easing.InOutQuad
        running: false
    }
}
