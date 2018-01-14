import QtQuick 2.0
import VPlay 2.0

EntityBase {
    entityType: 'Square'
    variationType: 'Default'
    opacity: 1
    width: 64
    height: 126
    y: -130

    Rectangle {
        color: 'green'
        anchors.fill: parent
    }

    BoxCollider {
        id: collider
        anchors.fill: parent
        gravityScale: 1
        linearDamping: 1
    }
}
