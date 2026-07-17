pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import "code/globals.js" as Globals
import "code/utils.js" as Utils
import "code/enum.js" as Enum

PlasmoidItem {
    id: root
    Layout.minimumWidth: Kirigami.Units.gridUnit
    Layout.preferredWidth: grid.implicitWidth
    Layout.maximumWidth: grid.implicitWidth

    Layout.minimumHeight: Kirigami.Units.gridUnit
    Layout.preferredHeight: grid.implicitHeight
    Layout.maximumHeight: grid.implicitHeight

    preferredRepresentation: compactRepresentation

    readonly property var settingsSync: SyncSettings.settings
    readonly property bool syncDetach: Plasmoid.configuration.syncDetach
    readonly property int syncId: Plasmoid.configuration.syncId
    readonly property bool initialized: Plasmoid.configuration.initialized
    property bool loading: true
    property int index: 0

    readonly property bool isVertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical
    readonly property real lineHeight: Plasmoid.configuration.height
    readonly property int fixedHeight: Plasmoid.configuration.fixedHeight
    readonly property bool fixedHeightEnabled: Plasmoid.configuration.fixedHeightEnabled
    readonly property int lineWidth: Plasmoid.configuration.width
    readonly property int leftMargin: Plasmoid.containment.corona.editMode ? 4 : Plasmoid.configuration.leftMargin
    readonly property int rightMargin: Plasmoid.containment.corona.editMode ? 4 : Plasmoid.configuration.rightMargin
    readonly property int radius: Plasmoid.configuration.radius

    readonly property int crossSize: fixedHeightEnabled ? fixedHeight : Math.round((isVertical ? width : height) * (lineHeight / 100))

    property var lineColor: {
        let cfg;
        try {
            cfg = JSON.parse(Plasmoid.configuration.lineColor);
        } catch (e) {
            console.error(e, e.stack);
            cfg = Globals.baseLineColor;
        }
        return Utils.mergeConfigs(Globals.baseLineColor, cfg);
    }

    Rectangle {
        id: kirigamiColorItem
        opacity: 0
        height: 1
        width: height
        Kirigami.Theme.colorSet: Kirigami.Theme[root.lineColor.systemColorSet]
    }

    Connections {
        target: SyncSettings
        function onSettingsChanged() {
            if (root.syncDetach || root.loading || !root.initialized)
                return;
            if (!loadDebounce.running) {
                root.loadSyncSettings();
            }
        }
    }

    Timer {
        id: loadDebounce
        interval: 500
    }

    function loadSyncSettings() {
        const settings = SyncSettings.settings;
        loadDebounce.restart();

        for (const key of Object.keys(settings)) {
            if (settings[key] !== undefined) {
                if (key === "lineColor") {
                    Plasmoid.configuration[key] = JSON.stringify(settings[key]);
                } else {
                    Plasmoid.configuration[key] = settings[key];
                }
            }
        }

        Plasmoid.configuration.writeConfig();
    }

    function syncSettings() {
        SyncSettings.settings = {
            height: lineHeight,
            fixedHeightEnabled: fixedHeightEnabled,
            fixedHeight: fixedHeight,
            width: lineWidth,
            leftMargin: leftMargin,
            rightMargin: rightMargin,
            radius: radius,
            lineColor: lineColor
        };
    }

    Timer {
        id: syncTimer
        interval: 10
        onTriggered: {
            if (root.initialized) {
                root.syncSettings();
            }
        }
    }

    Connections {
        target: Plasmoid.configuration
        function onValueChanged(key, value) {
            if (root.syncDetach || root.loading)
                return;
            syncTimer.restart();
        }
    }

    Component.onCompleted: {
        if (!initialized) {
            loadSyncSettings();
            Plasmoid.configuration.initialized = true;
            Plasmoid.configuration.writeConfig();
        } else {
            syncSettings();
        }
        root.loading = false;
        root.index = SyncSettings.counter;
        SyncSettings.counter++;
    }

    GridLayout {
        id: grid
        anchors.centerIn: parent
        columnSpacing: 0
        Rectangle {
            color: Utils.getColor(root.lineColor, root.index, kirigamiColorItem.Kirigami.Theme[root.lineColor.systemColor])
            radius: root.radius

            Layout.preferredHeight: root.isVertical ? root.lineWidth : root.crossSize
            Layout.preferredWidth: root.isVertical ? root.crossSize : root.lineWidth

            Layout.leftMargin: root.isVertical ? 0 : root.leftMargin
            Layout.rightMargin: root.isVertical ? 0 : root.rightMargin
            Layout.topMargin: root.isVertical ? root.leftMargin : 0
            Layout.bottomMargin: root.isVertical ? root.rightMargin : 0
        }
    }
}
