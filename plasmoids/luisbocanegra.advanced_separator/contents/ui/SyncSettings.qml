pragma Singleton

import QtQuick
import "code/globals.js" as Globals

QtObject {
    id: root
    property int counter: 0
    property var settings: ({
            height: 60,
            width: 3,
            fixedHeightEnabled: false,
            fixedHeight: 3,
            leftMargin: 4,
            rightMargin: 4,
            radius: 3,
            lineColor: Globals.baseLineColor
        })
}
