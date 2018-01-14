import VPlay 2.0
import QtQuick 2.0

Item {
    property real playerVelocityMultiplier: 3.5
    property int playerMaxVelocity: 500
    property bool enableSlowingOnTurn: false
    property real playerOnTurnDamping: 1
    property real playerDamping: 1
    property int playerTouchMargin: 20
    property real playerMoveVelocity: 0.4 // grid pixel per second
    property bool enableSlowingOnIdle: true
}
