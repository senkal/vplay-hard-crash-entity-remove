import VPlay 2.0
import QtQuick 2.0

Item {
    property variant matrix: {1: 1, 2:54, 3:107, 4: 160, 5: 213, 6: 266 }
    property int entityQty: 0
    property int lastCreatedAtColumn: 0

    function calculateXPosition() {
        var columns = 6;
        var position = Math.floor(Math.random() * columns) + 1
        var pixelXStep = 55;
        var xPosition

        // do not create item twice in a row in the same column
        if (position === lastCreatedAtColumn) {
            if (position === columns) {
                position = 1
            } else {
                ++ position
            }
        }

        lastCreatedAtColumn = position
        xPosition = matrix[position]
        xPosition += -gameScene.gameViewport.x

        return xPosition
    }

    function createDynamicEntity() {
        var newId
        var xPosition = calculateXPosition()

        // to not get to many diplication, reset after 100, used to get entity id upfront
        ++ entityQty
        if (entityQty >= 99) {
            entityQty = 1
        }

        newId = 'SQUARE_' + entityQty

        entityManager.createEntityFromEntityTypeAndVariationType(
                    {
                        entityType: squareType,
                        x: xPosition,
                        variationType: 'Default',
                        entityId: newId
                    })
    }

    Timer {
        id: createTimer
        interval: 750
        running: true
        repeat: true
        onTriggered: {
            createDynamicEntity()
        }
    }
}
