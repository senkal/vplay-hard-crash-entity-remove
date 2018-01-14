import QtQuick 2.0
import VPlay 2.0

EntityBase {
    id: entity
    entityType: 'PLAYER'
    x: 210
    y:  210
    width: itemWidth
    height: itemHeight

    Rectangle {
        anchors.fill: parent
        color: 'red'
    }

    function updatePlayerVelocity() {
        var maxVelocity = balance.playerMaxVelocity
        var maxVectorsVelocity = maxVelocity * 0.8

        if (moveCollider.linearVelocity.x > maxVelocity) {
            moveCollider.linearVelocity.x = maxVelocity
        }
        if (moveCollider.linearVelocity.y > maxVelocity) {
            moveCollider.linearVelocity.y = maxVelocity
        }
        if (moveCollider.linearVelocity.x > maxVectorsVelocity
                && moveCollider.linearVelocity.y > maxVectorsVelocity) {
            moveCollider.linearVelocity = Qt.point(maxVectorsVelocity, maxVectorsVelocity)
        }
    }

    function updatePlayerDamping() {
        function isGoingOppositeDirection() {
            return  moveCollider.linearVelocity.x > 0 && gameScene.playerMoveVectorX < 0
                    ||
                    moveCollider.linearVelocity.x < 0 && gameScene.playerMoveVectorX > 0
                    ||
                    moveCollider.linearVelocity.y < 0 && gameScene.playerMoveVectorY > 0
                    ||
                    moveCollider.linearVelocity.y > 0 && gameScene.playerMoveVectorY < 0
        }

        if (balance.enableSlowingOnTurn && isGoingOppositeDirection())  {
            moveCollider.linearDamping = balance.playerOnTurnDamping
        } else {
            moveCollider.linearDamping = balance.playerDamping
        }
    }

    function getUnixTime() {
        var nowDate = new Date()

        return nowDate.getTime()
    }

    readonly property int itemWidth: 115
    readonly property int itemHeight: 115 // 90

    property real halfWidth: itemWidth/2
    property real halfHeight: itemHeight/2
    property real centerX: x + halfWidth
    property real centerY: y + halfHeight
    property real touchMargin: balance.playerTouchMargin
    property real touchY: y + height + touchMargin
    property real moveVelocity: balance.playerMoveVelocity

    property alias hitDetectionCollider: hitDetectionCollider
    property alias moveCollider: moveCollider
    property alias xVelocity: hitDetectionCollider.linearVelocity.x

    onXChanged: {
        if (x <= dp(-10)) {
            x = dp(-10)
        } else if (x >= (gameScene.width - itemWidth + dp(5))) {
            x = gameScene.width - itemWidth + dp(5)
        }
    }

    onYChanged: {
        if (y <= dp(25)) {
            y = dp(25)
        } else if (y >= (gameScene.height - itemHeight + dp(5))) {
            y = gameScene.height - itemHeight + dp(5)
        }
    }

    function getCenter() {
        return hitDetectionCollider.getCenter()
    }

    Item {
        id: physicsHandler
        function reset() {
            moveCollider.force = Qt.point(0, 0)
            moveCollider.linearVelocity = Qt.point(0, 0)
        }
    }

    CircleCollider {
        id: moveCollider
        active: true
        bodyType: Body.Dynamic
        collidesWith: 0
        radius: 5
        x: absoluteX - gameViewport.x
        y: 49
        gravityScale: 0
        linearDamping: 1
        collisionTestingOnlyMode: false

        readonly property int absoluteX: 49
        property bool slowing: false

        function slowDown() {
            if (!balance.enableSlowingOnIdle) {
                return
            }
            var xVelocityAbs = Math.abs(linearVelocity.x)

            slowing = true
            force = Qt.point(0, 0)
            linearVelocity.x *= 0.9

            linearVelocity.y *= 0.9
        }
        function disableIdle() {
            if (!balance.enableSlowingOnIdle) {
                return
            }
            slowing = false
        }

        function getCenter() {
            return Qt.point(x + radius, y + radius)
        }

        onLinearVelocityChanged: {
            if (slowing) {
                return
            }

            updatePlayerVelocity()
            updatePlayerDamping()
        }
    }

    CircleCollider {
        id: hitDetectionCollider
        active: true
        bodyType: Body.Dynamic
        radius: 20
        x: 34 - gameViewport.x
        y: 34
        bullet: true
        gravityScale: 0
        collidesWith: 0
        collisionTestingOnlyMode: true

        function getCenter() {
            return body.getWorldCenter()
        }
    }
}
