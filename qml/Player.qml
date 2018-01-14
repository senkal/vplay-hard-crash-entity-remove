import VPlay 2.0
import QtQuick 2.0

Item {
    z: 50

    property alias sprite: sprite
    property alias centerX: sprite.centerX
    property alias centerY: sprite.centerY
    property alias xVelocity: sprite.xVelocity

    function getCenter() {
        return sprite.hitDetectionCollider.getCenter()
    }

    PlayerSprite {
        id: sprite
    }
}
