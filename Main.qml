import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebEngine
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    width: 1280
    height: 720
    title: qsTr("Info App")
    id: root

    property int time: 5000

    //Верхнее меню для функций редактирования
    menuBar: MenuBar {
        Menu {
            title: qsTr("&Edit")
            Action {
                text: qsTr("&Edit JSON-config")
                onTriggered: {
                    var component = Qt.createComponent("EditJson.qml")
                    if (component.status === Component.Ready) {
                        var Jwindow = component.createObject(root)
                        Jwindow.show()
                    }
                }
            }
            Action {
                text: qsTr("&Edit Timer")
                onTriggered: {
                    var component = Qt.createComponent("EditTimer.qml")
                    if (component.status === Component.Ready) {
                        var Twindow = component.createObject(root)
                        Twindow.show()

                        // Подключаем сигнал valueChanged из EditTimer.qml
                        Twindow.valueChanged.connect(function(newValue) {
                            root.time = newValue; // Обновляем переменную time
                        });
                    }
                }
            }
        }
    }

    GridLayout {
        id: grid
        rows: jsonData.rows
        columns: jsonData.columns
        rowSpacing: 25 // пространство между строками
        columnSpacing: 25 // пространство между столбцами
        anchors.fill: parent // Занимает всё доступное пространство окна
        anchors.margins: 20

        //Создание текста и WebView
        Repeater {
            id: rep
            model: jsonData.frames

            delegate: Item {
                Layout.fillWidth: true // заполняет ширину ячейки
                Layout.fillHeight: true // заполняет высоту ячейки
                Layout.row: modelData.row
                Layout.column: modelData.column

                ColumnLayout {
                    anchors.fill: parent // заполняет всю площадь Item

                    Text {
                        id: names
                        font.pixelSize: 30
                        text: modelData.name
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        z: 1
                    }

                    WebEngineView {
                        id: webView
                        Layout.fillWidth: true // заполняет ширину ColumnLayout
                        Layout.fillHeight: true // заполняет высоту ColumnLayout
                        url: modelData.url
                        z: 0
                        onUrlChanged:
                            webView.reload();

                        //Таймер для обновления страниц в WebView
                        Timer {
                            interval: root.time; running: true; repeat: true
                            onTriggered: {
                                webView.reload()
                            }
                        }
                    }
                }
            }
        }
    }
}
