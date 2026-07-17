import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid
import "../"
import "../code/enum.js" as Enum
import "../code/utils.js" as Utils

Kirigami.FormLayout {
    id: root

    // required to align with parent form
    property alias formLayout: root
    property bool isSection: true
    property string sectionName
    // wether read from the string or existing config object
    property bool handleString
    // internal config objects to be sent, both string and json
    property string configString: "{}"
    property var config: handleString ? JSON.parse(configString) : undefined
    // to hide options that make no sense
    property var followOptions: {
        "panel": false,
        "widget": false,
        "tray": false
    }
    property bool showFollowPanel: followOptions.panel
    property bool showFollowWidget: followOptions.widget
    property bool showFollowTray: followOptions.tray
    property bool showFollowRadio: showFollowPanel || showFollowWidget || showFollowTray
    // wether or not show these options
    property bool multiColor: true

    signal updateConfigString(string configString, var config)

    function updateConfig() {
        updateConfigString(configString, config);
    }

    onConfigStringChanged: {
        updateConfigString(configString, config);
    }

    twinFormLayouts: parentLayout
    Layout.fillWidth: true

    ListModel {
        id: themeColorSetModel

        ListElement {
            value: "View"
            displayName: "View"
        }

        ListElement {
            value: "Window"
            displayName: "Window"
        }

        ListElement {
            value: "Button"
            displayName: "Button"
        }

        ListElement {
            value: "Selection"
            displayName: "Selection"
        }

        ListElement {
            value: "Tooltip"
            displayName: "Tooltip"
        }

        ListElement {
            value: "Complementary"
            displayName: "Complementary"
        }

        ListElement {
            value: "Header"
            displayName: "Header"
        }
    }

    ListModel {
        id: themeColorModel

        ListElement {
            value: "textColor"
            displayName: "Text Color"
        }

        ListElement {
            value: "disabledTextColor"
            displayName: "Disabled Text Color"
        }

        ListElement {
            value: "highlightedTextColor"
            displayName: "Highlighted Text Color"
        }

        ListElement {
            value: "activeTextColor"
            displayName: "Active Text Color"
        }

        ListElement {
            value: "linkColor"
            displayName: "Link Color"
        }

        ListElement {
            value: "visitedLinkColor"
            displayName: "Visited LinkColor"
        }

        ListElement {
            value: "negativeTextColor"
            displayName: "Negative Text Color"
        }

        ListElement {
            value: "neutralTextColor"
            displayName: "Neutral Text Color"
        }

        ListElement {
            value: "positiveTextColor"
            displayName: "Positive Text Color"
        }

        ListElement {
            value: "backgroundColor"
            displayName: "Background Color"
        }

        ListElement {
            value: "highlightColor"
            displayName: "Highlight Color"
        }

        ListElement {
            value: "activeBackgroundColor"
            displayName: "Active Background Color"
        }

        ListElement {
            value: "linkBackgroundColor"
            displayName: "Link Background Color"
        }

        ListElement {
            value: "visitedLinkBackgroundColor"
            displayName: "Visited Link Background Color"
        }

        ListElement {
            value: "negativeBackgroundColor"
            displayName: "Negative Background Color"
        }

        ListElement {
            value: "neutralBackgroundColor"
            displayName: "Neutral Background Color"
        }

        ListElement {
            value: "positiveBackgroundColor"
            displayName: "Positive Background Color"
        }

        ListElement {
            value: "alternateBackgroundColor"
            displayName: "Alternate Background Color"
        }

        ListElement {
            value: "focusColor"
            displayName: "Focus Color"
        }

        ListElement {
            value: "hoverColor"
            displayName: "Hover Color"
        }
    }

    Item {
        Kirigami.FormData.isSection: root.isSection
        Kirigami.FormData.label: root.sectionName || i18n("Color")
        Layout.fillWidth: true
    }

    RowLayout {
        Kirigami.FormData.label: i18n("Color source:")
        RadioButton {
            id: singleColorRadio

            property int value: Enum.ColorSourceType.Custom

            text: i18n("Custom")
            ButtonGroup.group: colorModeGroup
            checked: root.config.sourceType === value
        }
        Kirigami.ContextualHelpButton {
            toolTipText: i18n("A fixed custom color")
        }
    }

    RowLayout {
        RadioButton {
            id: accentColorRadio

            property int value: Enum.ColorSourceType.System

            text: i18n("System")
            ButtonGroup.group: colorModeGroup
            checked: root.config.sourceType === value
        }
        Kirigami.ContextualHelpButton {
            toolTipText: i18n("Color that updates with your System theme")
        }
    }

    RowLayout {
        RadioButton {
            id: randomColorRadio

            property int value: Enum.ColorSourceType.Random

            text: i18n("Random")
            ButtonGroup.group: colorModeGroup
            checked: root.config.sourceType === value
        }
        Kirigami.ContextualHelpButton {
            toolTipText: i18n("Random color")
        }
    }

    RowLayout {
        RadioButton {
            id: listColorRadio
            property int value: Enum.ColorSourceType.List

            text: i18n("Custom list")
            ButtonGroup.group: colorModeGroup
            checked: root.config.sourceType === value
        }
        Kirigami.ContextualHelpButton {
            toolTipText: i18n("Define a list of colors that will be applied to all the separators, wraps around if there are more separators than colors")
        }
    }

    ButtonGroup {
        id: colorModeGroup
        onCheckedButtonChanged: {
            if (checkedButton) {
                root.config.sourceType = checkedButton.value;
                root.updateConfig();
            }
        }
    }

    ColorButton {
        id: customColorBtn
        Kirigami.FormData.label: i18n("Color:")
        color: root.config.custom
        visible: singleColorRadio.checked
        onAccepted: color => {
            root.config.custom = color.toString();
            root.updateConfig();
        }
    }

    ComboBox {
        id: colorSetCombobx

        Kirigami.FormData.label: i18n("Color set:")
        model: themeColorSetModel
        textRole: "displayName"
        visible: accentColorRadio.checked
        onCurrentIndexChanged: {
            root.config.systemColorSet = themeColorSetModel.get(currentIndex).value;
            root.updateConfig();
        }

        Binding {
            target: colorSetCombobx
            property: "currentIndex"
            value: {
                for (var i = 0; i < themeColorSetModel.count; i++) {
                    if (themeColorSetModel.get(i).value === root.config.systemColorSet)
                        return i;
                }
                return 0; // Default to the first item if no match is found
            }
        }
    }

    ComboBox {
        id: colorThemeCombobx

        Kirigami.FormData.label: i18n("Color:")
        model: themeColorModel
        textRole: "displayName"
        visible: accentColorRadio.checked
        onCurrentIndexChanged: {
            root.config.systemColor = themeColorModel.get(currentIndex).value;
            root.updateConfig();
        }

        Binding {
            target: colorThemeCombobx
            property: "currentIndex"
            value: {
                for (var i = 0; i < themeColorModel.count; i++) {
                    if (themeColorModel.get(i).value === root.config.systemColor)
                        return i;
                }
                return 0; // Default to the first item if no match is found
            }
        }
    }

    ColumnLayout {
        visible: multiColor && listColorRadio.checked
        Kirigami.FormData.label: i18n("Colors:")

        Loader {
            asynchronous: true
            sourceComponent: listColorRadio.checked ? pickerList : null
            onLoaded: {
                item.colorsList = config.list;
                item.onColorsChanged.connect(colorsList => {
                    config.list = colorsList;
                    updateConfig();
                });
            }
        }

        Component {
            id: pickerList

            ColorPickerList {}
        }
    }

    RowLayout {
        Kirigami.FormData.label: i18n("Alpha:")
        visible: colorModeGroup.checkedButton.index !== 6

        DoubleSpinBoxCompat {
            id: alphaSpinbox
            from: 0 * multiplier
            to: 1 * multiplier
            value: (root.config.alpha ?? 0) * multiplier
            onValueModified: {
                root.config.alpha = value / alphaSpinbox.multiplier;
                root.updateConfig();
            }
        }
    }

    Kirigami.Separator {
        Kirigami.FormData.isSection: false
        Kirigami.FormData.label: i18n("Contrast Correction")
        Layout.fillWidth: true
        visible: colorModeGroup.checkedButton.index !== 6
    }

    RowLayout {
        Kirigami.FormData.label: i18n("Saturation:")
        visible: colorModeGroup.checkedButton.index !== 6

        CheckBox {
            id: saturationEnabled

            checked: root.config.saturationEnabled
            onCheckedChanged: {
                root.config.saturationEnabled = checked;
                root.updateConfig();
            }
        }

        DoubleSpinBoxCompat {
            id: saturationSpinbox
            from: 0 * multiplier
            to: 1 * multiplier
            value: (root.config.saturation ?? 0) * multiplier
            onValueModified: {
                root.config.saturation = value / saturationSpinbox.multiplier;
                root.updateConfig();
            }
        }
    }

    RowLayout {
        Kirigami.FormData.label: i18n("Lightness:")
        visible: colorModeGroup.checkedButton.index !== 6

        CheckBox {
            id: lightnessEnabled

            checked: root.config.lightnessEnabled
            onCheckedChanged: {
                root.config.lightnessEnabled = checked;
                root.updateConfig();
            }
        }

        DoubleSpinBoxCompat {
            id: lightnessSpinbox
            from: 0 * multiplier
            to: 1 * multiplier
            value: (root.config.lightness ?? 0) * multiplier
            onValueModified: {
                root.config.lightness = value / lightnessSpinbox.multiplier;
                root.updateConfig();
            }
        }
    }
}
