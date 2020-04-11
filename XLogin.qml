import QtQuick 2.0

Rectangle {
    id: r
    anchors.fill: parent
    color: app.c1
    Column{
        spacing: app.fs*0.5
        anchors.centerIn: parent
        UText{
            text:  '<b>Acceder</b>'
            font.pixelSize: app.fs*2
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Item{width: 1;height: app.fs*2}
        Column{
            spacing: app.fs
            Row{
                anchors.right: parent.right
                spacing: app.fs
                UText{
                    text: 'Administrador:'
                    font.pixelSize: app.fs*2
                    anchors.verticalCenter: parent.verticalCenter
                }
                UTextInput{
                    id: tiAdmin
                    label: ''
                    fontSize: app.fs*2
                    width: app.fs*20
                    maximumLength: 12
                    KeyNavigation.tab: tiContrasenia
                    onFocusChanged: {
                        textInput.selectAll()
                    }
                }
            }
            Row{
                anchors.right: parent.right
                spacing: app.fs
                UText{
                    text: 'Contraseña:'
                    font.pixelSize: app.fs*2
                    anchors.verticalCenter: parent.verticalCenter
                }
                UTextInput{
                    id: tiContrasenia
                    label: ''
                    fontSize: app.fs*2
                    width: app.fs*20
                    maximumLength: 12
                    KeyNavigation.tab: botLogin
                    onFocusChanged: {
                        textInput.selectAll()
                    }
                }
            }
        }
        BotonUX{
            id: botLogin
            text: 'Ingresar'
            height: app.fs*4
            fontSize: app.fs*2
            anchors.right: parent.right
            Keys.onReturnPressed: login()
            onClicked: login()
            UnikFocus{}
        }
        Item {
            width: 1
            height: app.fs
        }
        UText{
            id: status
            font.pixelSize: app.fs*2
        }
    }
    Component.onCompleted: {
        tiAdmin.focus=true
    }
    function login(){
        let claveDec=unik.decData(unik.getFile('pass'), 'axf5d', 'adgd5a')
        let clave=tiAdmin.text+'|'+tiContrasenia.text
        if(clave===claveDec){
            r.visible=false
        }else{
            status.text='Administrador o contraseña incorrecta.'
            tiAdmin.text=''
            tiContrasenia.text=''
            tiAdmin.focus=true
        }
    }
}
