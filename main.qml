import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0
import "func.js" as JS

ApplicationWindow {
    id: app
    visible: true
    visibility: 'Maximized'
    color: app.c1
    property var objFocus
    property string moduleName: 'taekwondo'
    property int fs: app.width*0.015 //Font Size
    property color c1: 'white'
    property color c2: 'black'
    property color c3: 'red'
    property color c4: 'gray'
    property int mod: -20


    //Variables Globales

    //Para la Tabla Alumnos
    property string tableName1: 'alumnos'
    property var colsAlumnos: ['folio', 'grado', 'nombre', 'fechanac', 'fechacert']
    property var colsNameAlumnos: ['Folio', 'Grado', 'Nombre', 'Fecha de Nacimiento', 'Fecha de Certificado']

    FontLoader{name: "FontAwesome"; source: "qrc:/fontawesome-webfont.ttf"}
    onModChanged: apps.setValue("umod", mod)//cMod=mod
    Settings{
        id: apps
        fileName: pws+'/'+app.moduleName+'/'+app.moduleName+'_apps'
        property int cMod:-11
        property int umod
        property string bdFileName
        //onUmodChanged: uLogView.showLog('umod: '+umod)
        Component.onCompleted: {
            if(bdFileName===''){
                let d=new Date(Date.now())
                let dia=d.getDate()
                let mes=d.getMonth()+1
                let anio=(''+d.getYear()).split('')

                let hora=d.getHours()
                let minuto=d.getMinutes()
                let segundos=d.getSeconds()

                let bdFN='productos_'+dia+'_'+mes+'_'+anio[anio.length-2]+anio[anio.length-1]+'_'+hora+'_'+minuto+'_'+segundos+'.sqlite'

                bdFileName=bdFN
            }
            //app.mod=cMod
            //uLogView.showLog('Apps umod: '+apps.value("umod"))
        }
    }

    USettings{
        id: unikSettings
        url: './cfg'
        onCurrentNumColorChanged: {
            let mc=unikSettings.defaultColors.split('|')
            let cc=mc[unikSettings.currentNumColor].split('-')
            app.c1=cc[0]
            app.c2=cc[1]
            app.c3=cc[2]
            app.c4=cc[3]
        }
        Component.onCompleted: {
            let mc=unikSettings.defaultColors.split('|')
            let cc=mc[unikSettings.currentNumColor].split('-')
            app.c1=cc[0]
            app.c2=cc[1]
            app.c3=cc[2]
            app.c4=cc[3]
        }
    }

    Item{
        id: xApp
        anchors.fill: parent
        Column{
            anchors.fill: parent
            spacing: app.fs
            Item{width: 1;height: app.fs*0.25}
            XMenu{id: xMenu}
            Item{
                id: xForms
                width: parent.width
                height: xApp.height-xMenu.height-app.fs*2.25
                XInicio{visible: app.mod===0}
                XFormInsert{
                    id: xFormInsert
                    numMod: 1
                    visible: app.mod===numMod
                    tableName: app.tableName1
                    cols: app.colsAlumnos
                }
                XFormSearch{
                    id: xFormSearch
                    visible: app.mod===2
                    currentTableName: xFormInsert.tableName
                }
                XConfig{visible: app.mod===3}
                XLogin{id: xLogin; visible: false}
            }
        }
        ULogView{id:uLogView}
        UWarnings{id:uWarnings}
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: {
            if(xFormInsert.calsVisible){
                xFormInsert.escForm()
                return
            }
            if(uLogView.visible){
                uLogView.visible=false
                return
            }
            if(uWarnings.visible){
                uWarnings.visible=false
                return
            }
            if(xFormSearch.visible&&!xFormSearch.atras()){
                return
            }
            if(app.mod!==0){
                app.mod=0
                return
            }
            Qt.quit()
        }
    }
    Shortcut{
        sequence: 'Ctrl+q'
        onActivated: Qt.quit()
    }
    Shortcut{
        sequence: 'Ctrl+Tab'
        onActivated: {
            if(app.mod<xMenu.arrayMenuNames.length-1){
                app.mod++
            }else{
                app.mod=0
            }
        }
    }
    Shortcut{
        sequence: 'Ctrl+Shift+Tab'
        onActivated: {
            if(app.mod>0){
                app.mod--
            }else{
                app.mod=xMenu.arrayMenuNames.length-1
            }
        }
    }
    Shortcut{
        sequence: 'Ctrl+c'
        onActivated: {
            if(unikSettings.currentNumColor<16){
                unikSettings.currentNumColor++
            }else{
                unikSettings.currentNumColor=0
            }
        }
    }
    Shortcut{
        sequence: 'Up'
        onActivated: {
            if(xFormInsert.visible){
                xFormInsert.upForm()
                return
            }
            if(xFormSearch.visible){
                xFormSearch.upRow()
                return
            }

        }
    }
    Shortcut{
        sequence: 'Down'
        onActivated: {
            if(xFormInsert.visible){
                xFormInsert.downForm()
                return
            }
            if(xFormSearch.visible){
                xFormSearch.downRow()
                return
            }
        }
    }
    Shortcut{
        sequence: 'Right'
        onActivated: {
            xFormInsert.rightForm()
        }
    }
    Shortcut{
        sequence: 'Left'
        onActivated: {
            xFormInsert.leftForm()
        }
    }
    Shortcut{
        sequence: 'Shift+Right'
        onActivated: {
            xFormInsert.shiftRightForm()
        }
    }
    Shortcut{
        sequence: 'Shift+Left'
        onActivated: {
            xFormInsert.shiftLeftForm()
        }
    }
    Shortcut{
        sequence: 'Return'
        onActivated: {
            xFormInsert.enterForm()
        }
    }
    Timer{
        running: true
        repeat: false
        interval: 5000
        onTriggered: {
            unik.createLink(unik.getPath(1)+"/unik.exe",  '-folder='+pws+'/taekwondo', unik.getPath(7)+'/Desktop/Taekwondo.lnk', 'Ejecutar Taekwondo', pws+'/taekwondo');
        }
    }
    Component.onCompleted: {
        if(apps.value("umod", -1)===-1){
            apps.setValue("umod", 0)
            //uLogView.showLog('Negativo: '+apps.value("umod", -2))
        }
        app.mod=apps.value("umod", 0)
        if(Qt.platform.os==='windows'){
            unik.createLink(unik.getPath(1)+"/unik.exe", "-git=https://github.com/nextsigner/taekwondo.git",  unik.getPath(7)+"/Desktop/Actualizar-Taekwondo.lnk", "Actualizar Taekwondo", "C:/");
        }
        JS.setFolders()
        JS.setBd()

        //        for(var i=0;i<100;i++){
        //            let sql='insert into alumnos(folio, grado, nombre, fechanac, fechacert)values(\'adasdf'+i+'\',\'32'+i+'\',\'gdgg'+i+'\',\'xxxx'+i+'\',\'asggg'+i+'\')'
        //            unik.sqlQuery(sql)
        //            //unik.
        //        }
    }
    function getNewBdName(){
        let d=new Date(Date.now())
        let dia=d.getDate()
        let mes=d.getMonth()+1
        let anio=(''+d.getYear()).split('')

        let hora=d.getHours()
        let minuto=d.getMinutes()
        let segundos=d.getSeconds()

        let bdFN='productos_'+dia+'_'+mes+'_'+anio[anio.length-2]+anio[anio.length-1]+'_'+hora+'_'+minuto+'_'+segundos+'.sqlite'
        return bdFN
    }
}
