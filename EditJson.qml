import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: qsTr("Json Editor")

    // Обновление данных JSON при открытии окна
       Component.onCompleted: {
           JsonMove.reloadJsonData(); // Вызываем функцию перезагрузки данных
           textArea.text = JsonMove.text; // Устанавливаем текст в TextArea
       }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        //Область для редактирования JSON-файла
        TextArea {
            id: textArea
            text: JsonMove.text
            wrapMode: TextEdit.WordWrap
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        //Кнопка сохранения
        Button {
                text: "Save JSON"
                onClicked: {
                    JsonMove.text = textArea.text
                    var saved = JsonMove.saveJsonToFile("grid_config.json");
                    if (saved)
                        console.log("JSON saved successfully.");
                    else
                        console.error("Failed to save JSON.");
                }
                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter;
                    bottomMargin: 20
                }
            }
    }
}
