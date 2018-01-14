import VPlay 2.0
import QtQuick 2.0

GameWindow {
    id: gameWindow
    activeScene: gameScene
    screenWidth: 320
    screenHeight: 569

    readonly property string squareType: 'Square'

    function movePlayerByForce(mouseX, mouseY) {
        var minValue = 150
        var xVector = balance.playerVelocityMultiplier * (mouseX - player.centerX)
        var yVector = balance.playerVelocityMultiplier * (mouseY - player.sprite.touchY)
        var xVectorAbs = Math.abs(xVector)
        var yVectorAbs = Math.abs(yVector)

        if (xVectorAbs < minValue && yVectorAbs < minValue) {
            if (xVectorAbs >= yVectorAbs) {
                if (xVector < 0) {
                    xVector = -1 * minValue
                } else {
                    xVector = minValue
                }
            } else {
                if (yVector < 0) {
                    yVector = -1 * minValue
                } else {
                    yVector = minValue
                }
            }
        }

        gameScene.playerMoveVectorX = xVector
        gameScene.playerMoveVectorY = yVector
        gameScene.playerLastMoveTime = getUnixTime()
        player.sprite.moveCollider.force =  Qt.point(xVector, yVector)
    }

    function getUnixTime() {
        var nowDate = new Date()

        return nowDate.getTime()
    }

    BalanceSettings {
        id: balance
    }

    EntityManager {
        id: entityManager
        entityContainer: gameScene.gameViewport
        dynamicCreationEntityList: [Qt.resolvedUrl("Square.qml")]
    }

    EntityCreator {
        id: entityCreator
    }

    Scene {
        id: gameScene
        property real playerMoveVectorX
        property real playerMoveVectorY
        property real playerLastMoveTime
        property alias gameViewport: gameViewport

        width: 320
        height: 569

        Player {
            id: player
        }
        MouseArea {
            id: playerTouchArea
            enabled: true
            anchors.fill: parent
            property bool initialized: false

            function reset() {
                initialized = false
            }

            onPositionChanged: {
                if (pressed) {
                    initialized = true
                    movePlayerByForce(mouseX, mouseY)
                }
            }

            onPressed: {
                initialized = true
                movePlayerByForce(mouseX, mouseY)
            }

            // there was some bug, without this below in some situations
            // no input was recorded for this area
            // not related to the main problem
            Rectangle {
                anchors.fill: parent
                color: 'transparent'
            }
        }

        Item {
            id: gameViewport
            width: basicWidth * horizontalRepeat
            height: gameScene.height
            x: startingX
            y: 0
            z: 10
            readonly property int basicWidth: 320
            readonly property int startingX: -1 * basicWidth/2 * (horizontalRepeat - 1)
            property int center: width/2
            property int horizontalRepeat: 5

            PhysicsWorld {
                id: physicsWorld
                gravity.y: 8
                debugDrawVisible: false
                updatesPerSecondForPhysics: 30
            }

            ScreenBottom {
                width: parent.width
                height: 5
                y: 150
                anchors.bottom: parent.bottom
                z: 10000
            }

        }
    }
}
