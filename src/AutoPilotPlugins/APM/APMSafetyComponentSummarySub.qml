import QtQuick 2.2
import QtQuick.Controls 1.2

import QGroundControl.FactSystem 1.0
import QGroundControl.FactControls 1.0
import QGroundControl.Controls 1.0
import QGroundControl.Palette 1.0

FactPanel {
    id:             panel
    anchors.fill:   parent
    color:          qgcPal.windowShadeDark

    QGCPalette { id: qgcPal; colorGroupEnabled: enabled }
    FactPanelController { id: controller; factPanel: panel }

    property Fact _failsafeBattEnable:  controller.getParameterFact(-1, "FS_BATT_ENABLE")
    property Fact _failsafeThrEnable:   controller.getParameterFact(-1, "FS_THR_ENABLE")

    property Fact _fenceAction: controller.getParameterFact(-1, "FENCE_ACTION")
    property Fact _fenceEnable: controller.getParameterFact(-1, "FENCE_ENABLE")
    property Fact _fenceType:   controller.getParameterFact(-1, "FENCE_TYPE")

    property Fact _leakPin:            controller.getParameterFact(-1, "WD_1_PIN")

    property Fact _armingCheck: controller.getParameterFact(-1, "ARMING_CHECK")

    property string _failsafeBattEnableText
    property string _failsafeThrEnableText

    Component.onCompleted: {
        setFailsafeBattEnableText()
        setFailsafeThrEnableText()
    }

    Connections {
        target: _failsafeBattEnable

        onValueChanged: setFailsafeBattEnableText()
    }

    Connections {
        target: _failsafeThrEnable

        onValueChanged: setFailsafeThrEnableText()
    }

    function setFailsafeThrEnableText() {
        switch (_failsafeThrEnable.value) {
        case 0:
            _failsafeThrEnableText = qsTr("Disabled")
            break
        case 1:
            _failsafeThrEnableText = qsTr("Always RTL")
            break
        case 2:
            _failsafeThrEnableText = qsTr("Continue with Mission in Auto Mode")
            break
        case 3:
            _failsafeThrEnableText = qsTr("Always Land")
            break
        default:
            _failsafeThrEnableText = qsTr("Unknown")
        }
    }

    function setFailsafeBattEnableText() {
        switch (_failsafeBattEnable.value) {
        case 0:
            _failsafeBattEnableText = qsTr("Disabled")
            break
        case 1:
            _failsafeBattEnableText = qsTr("Land")
            break
        case 2:
            _failsafeBattEnableText = qsTr("Return to Launch")
            break
        default:
            _failsafeThrEnableText = qsTr("Unknown")
        }
    }

    Column {
        anchors.fill:       parent

        VehicleSummaryRow {
            labelText: qsTr("Arming Checks:")
            valueText:  _armingCheck.value & 1 ? qsTr("Enabled") : qsTr("Some disabled")
        }

        VehicleSummaryRow {
            labelText: qsTr("Throttle failsafe:")
            valueText:  _failsafeThrEnableText
        }

        VehicleSummaryRow {
            labelText: qsTr("Battery failsafe:")
            valueText:  _failsafeBattEnableText
        }

        VehicleSummaryRow {
            labelText: qsTr("Leak Detector:")
            valueText: _leakPin.value > 0 ? qsTr("Enabled") : qsTr("Disabled")
        }

        VehicleSummaryRow {
            labelText: qsTr("GeoFence:")
            valueText: _fenceEnable.value == 0 || _fenceType == 0 ?
                           qsTr("Disabled") :
                           (_fenceType.value == 1 ?
                                qsTr("Altitude") :
                                (_fenceType.value == 2 ? qsTr("Circle") : qsTr("Altitude,Circle")))
        }

        VehicleSummaryRow {
            labelText: qsTr("GeoFence:")
            valueText: _fenceAction.value == 0 ?
                           qsTr("Report only") :
                           (_fenceAction.value == 1 ? qsTr("RTL or Land") : qsTr("Unknown"))
            visible:    _fenceEnable.value != 0
        }
    }
}
