import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "components" as Components
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid

KCM.SimpleKCM {
    id: root

    property alias cfg_syncDetach: syncDetach.checked
    property alias cfg_height: height.value
    property alias cfg_fixedHeightEnabled: fixedHeight_absolute.checked
    property alias cfg_fixedHeight: fixedHeight.value
    property alias cfg_width: width.value
    property alias cfg_leftMargin: leftMargin.value
    property alias cfg_rightMargin: rightMargin.value
    property alias cfg_radius: radius.value
    property string cfg_lineColor: ""
    property bool isVertical: Plasmoid.formFactor == PlasmaCore.Types.Vertical

    ColumnLayout {
        Kirigami.FormLayout {
            id: form
            RowLayout {
                Kirigami.FormData.label: i18n("Do not sync:")
                CheckBox {
                    id: syncDetach
                }
                Kirigami.ContextualHelpButton {
                    toolTipText: i18n("Do not copy the configuration from/to other separators")
                }
            }
            RowLayout {
                Kirigami.FormData.label: root.isVertical ? i18n("Width mode:") : i18n("Height mode:")
                ButtonGroup {
                    id: heightModeGroup
                    buttons: [fixedHeight_percentage, fixedHeight_absolute]
                }
                RadioButton {
                    id: fixedHeight_percentage
                    text: i18n("Percentage")
                    checked: !root.cfg_fixedHeightEnabled
                }
                RadioButton {
                    id: fixedHeight_absolute
                    text: i18n("Absolute")
                }
            }
            SpinBox {
                id: height
                Kirigami.FormData.label: root.isVertical ? i18n("Width:") : i18n("Height:")
                visible: !root.cfg_fixedHeightEnabled
                from: 0
                to: 999
                stepSize: 5
            }
            RowLayout {
                Kirigami.FormData.label: root.isVertical ? i18n("Width:") : i18n("Height:")
                visible: root.cfg_fixedHeightEnabled
                SpinBox {
                    id: fixedHeight
                    from: 0
                    to: 999
                    stepSize: 1
                }
            }
            SpinBox {
                id: width
                Kirigami.FormData.label: root.isVertical ? i18n("Height:") : i18n("Width:")
                from: 0
                to: 999
            }
            SpinBox {
                id: leftMargin
                Kirigami.FormData.label: root.isVertical ? i18n("Top margin:") : i18n("Left margin:")
                from: 0
                to: 999
            }
            SpinBox {
                id: rightMargin
                Kirigami.FormData.label: root.isVertical ? i18n("Bottom margin:") : i18n("Right margin:")
                from: 0
                to: 999
            }
            SpinBox {
                id: radius
                Kirigami.FormData.label: i18n("Radius:")
                from: 0
                to: 999
            }
        }
        Components.FormColors {
            configString: root.cfg_lineColor
            handleString: true
            onUpdateConfigString: (newString, newConfig) => {
                root.cfg_lineColor = JSON.stringify(newConfig);
            }
            sectionName: i18n("Color")
            multiColor: true
            twinFormLayouts: [form]
        }
    }
}
