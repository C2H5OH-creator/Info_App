import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

ApplicationWindow {
    id: timerRoot
    visible: false
    width: 400
    height: 300
    title: qsTr("Edit Timer")

    signal valueChanged(int newValue)
    property int curammt: spinBox.value //Переменная для отображения текущего времени таймера

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        //Пояснения
        Text {
            text: "Enter time (in milliseconds).\n You can enter -1, if you dont need timer.\n Current amount of milliseconds: " + curammt
            wrapMode: Text.WordWrap
            font.pixelSize: 16
            Layout.alignment: Qt.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.9
        }

        //Ввод значений
        SpinBox {
            id: spinBox
            anchors.horizontalCenter: parent.horizontalCenter
            from: -1 // Минимальное значение
            to: 9999999
            stepSize: 1 // Шаг изменения значения
            value: 5000 // Начальное значение
            editable: true // Разрешаем редактирование значения с клавиатуры

            onValueChanged: {
                console.log("SpinBox value changed to:", value)
                valueChanged(value); // Отправляем сигнал с новым значением
            }
        }

        //Кнопка сохранения
        Button {
            text: "Save"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                valueChanged(spinBox.value); // Вызываем сигнал valueChanged с текущим значением SpinBox
                curammt = spinBox.value
            }
        }
    }
}
