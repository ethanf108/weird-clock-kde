import QtQuick 2
import QtQuick.Controls 2.15
import org.kde.kquickcontrols 2.0 as KQuickControls
import org.kde.kirigami 2.5 as Kirigami

Kirigami.FormLayout {
    id: root
    twinFormLayouts: parentLayout

    property alias cfg_BGColor: bgColorPicker.color
    property alias cfg_Layout: layoutSelect.currentIndex
    property alias cfg_TickSpeed: tickSelect.currentIndex
    property alias formLayout: root

    KQuickControls.ColorButton {
	id: bgColorPicker
	Kirigami.FormData.label: "Background Color:"
	dialogTitle: "Select Background Color"
    }

    ComboBox {
	id: layoutSelect
	model: ["Fit to Screen", "Square"]
	Kirigami.FormData.label: "Layout:"
    }

    ComboBox {
	id: tickSelect
	model: ["Continuous (Try my Best)", "Tick per Second"]
	Kirigami.FormData.label: "Tick Speed:"
    }
}
