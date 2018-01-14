import VPlay 2.0
import QtQuick 2.0

EntityBase {
    entityType: "Bottom"
    height: 5

    Rectangle {
        id: rect
        color: "red"
        anchors.fill: parent
    }

    BoxCollider {
        anchors.fill: parent
        fixture.onBeginContact: {
            var collidedEntity = other.getBody().target;
            collidedEntity.removeEntity()  // POTENTIAL KILLER
        }
    }

}
