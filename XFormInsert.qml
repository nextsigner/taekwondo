import QtQuick 2.0

Item {
    id: r
    anchors.fill: parent
    property bool modificando: false
    property int pIdAModificar: -1
    property string tableName: ''
    property string uCodInserted: ''
    property var cols: []
    onVisibleChanged: {
        if(visible){
            updateGui()
            tiFolio.focus=visible
        }else{
            tiFolio.focus=false
            tiGrado.focus=false
            tiNombre.focus=false
            tiFechaNac.focus=false
        }
    }
    Column{
        spacing: app.fs*0.5
        anchors.centerIn: parent
        UText{
            text:  !r.modificando?'<b>Registro de Alumnos</b>':'<b>Modificando Registro de Alumno</b>'
            font.pixelSize: app.fs*2
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Item{width: 1;height: app.fs*2}
        Row{
            spacing: app.fs
            UTextInput{
                id: tiFolio
                label: 'Folio: '
                width: app.fs*10
                maximumLength: 10
                KeyNavigation.tab: tiGrado
                property string uCodExist: ''
                onFocusChanged: {
                    textInput.selectAll()
                }
                onTextChanged: {
                    tCheckCodExist.restart()
                }
                Timer{
                    id: tCheckCodExist
                    running: false
                    repeat: false
                    interval: 3000
                    onTriggered: {
                        let ce=r.codExist()
                        if(tiFolio.text!==r.uCodInserted&&ce&&tiFolio.text!==tiFolio.uCodExist){
                            let msg='<b>Atención!: </b>El código actual ya existe.'
                            unik.speak(msg.replace(/<[^>]*>?/gm, ''))
                            labelStatus.text=msg
                        }
                        if(!ce){
                            r.modificando=false
                        }
                        tiFolio.uCodExist=tiFolio.text
                    }
                }
            }
            UTextInput{
                id: tiGrado
                label: 'Grado: '
                width: r.width*0.5-tiFolio.width-app.fs*2
                maximumLength: 250
                KeyNavigation.tab: tiNombre
                onFocusChanged: {
                    textInput.selectAll()
                }
            }
        }
        UTextInput{
            id: tiNombre
            label: 'Nombre: '
            width: r.width*0.5-app.fs
            maximumLength: 50
            //regularExp: RegExpValidator{regExp: /^\d+(\.\d{1,2})?$/ }
            KeyNavigation.tab: tiFechaNac
            onFocusChanged: {
                textInput.selectAll()
            }
        }
        Row{
            spacing: app.fs
            UTextInput{
                id: tiFechaNac
                label: 'Fecha de Nacimiento: '
                width: parent.parent.width*0.5-app.fs*0.5
                maximumLength: 10
                //regularExp: RegExpValidator{regExp: /^([1-9])([0-9]{10})/ }
                KeyNavigation.tab: tiFechaCert
                onFocusChanged: {
                    textInput.selectAll()
                }
            }
            UTextInput{
                id: tiFechaCert
                label: 'Fecha de Certificado: '
                width: parent.parent.width*0.5-app.fs*0.5
                maximumLength: 10
                //regularExp: RegExpValidator{regExp: /^([1-9])([0-9]{10})/ }
                KeyNavigation.tab: botReg
                onFocusChanged: {
                    textInput.selectAll()
                }
            }
        }
        Item{width: 1;height: app.fs*2}
        UText{
            id: labelCount
            width: r.width*0.5-tiFolio.width-app.fs*2
            height: contentHeight
            wrapMode: Text.WordWrap
        }
        Item{
            width: r.width*0.5-app.fs
            height: 1
            UText{
                id: labelStatus
                text: 'Esperando a que se registren alumnos.'
                width: r.width
                height: contentHeight
                wrapMode: Text.WordWrap
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Item{width: 1;height: app.fs*2}
        Row{
            spacing: app.fs
            anchors.right: parent.right
            BotonUX{
                id: botClear
                text: 'Limpiar'
                height: app.fs*2
                KeyNavigation.tab: botReg
                onClicked: {
                    tiFolio.text=''
                    tiGrado.text=''
                    tiNombre.text=''
                    tiFolio.focus=true
                    labelStatus.text='Formulario limpiado.'
                }
                UnikFocus{}
            }
            BotonUX{
                id: botReg
                text: !r.modificando?'Guardar Registro':'Modificar Registro'
                height: app.fs*2
                onClicked: {
                    if(!r.modificando){
                        insert()
                    }else{
                        modify()
                    }
                }
                KeyNavigation.tab: tiFolio
                Keys.onReturnPressed: {
                    if(!r.modificando){
                        insert()
                    }else{
                        modify()
                    }
                }
                UnikFocus{}
            }
        }
    }
    Timer{
        repeat: true
        running: r.visible
        interval: 15000
        onTriggered: updateGui()
    }
    Component{
        id: compExist
        Rectangle{
            id: xCodExists
            width: r.width*0.5
            height: colExists.height+app.fs
            radius: app.fs*0.1
            border.width: 2
            anchors.centerIn: parent
            color: parseInt(vpid)!==-10?app.c1:app.c2
            property string vpid: ''
            property string vafolio: ''
            property string vagrado: ''
            property string vanom: ''
            property string vafechanac: ''
            Column{
                id: colExists
                spacing: app.fs
                width: parent.width-app.fs
                anchors.centerIn: parent
                UText{
                    id: txt
                    color:parseInt(vpid)!==-10?app.c2:app.c1
                    font.pixelSize: app.fs
                    text: parseInt(vpid)!==-10? '<b style="font-size:'+app.fs+'px;">Folio: </b><span style="font-size:'+app.fs+'px;">'+vafolio+'</span><br /><br /><b  style="font-size:'+app.fs*1.4+'px;">Grado: </b><span style="font-size:'+app.fs+'px;">'+vagrado+'</span><br /><br /><b style="font-size:'+app.fs+'px;">Nombre: </b> <span style="font-size:'+app.fs+'px;">$'+vanom+'</span><br /><b>Fecha de Nacimiento: </b>'+vafechanac:'<b>Resultados por descripción:</b> '+tiSearch.text
                    textFormat: Text.RichText
                    width: parent.width-app.fs
                    wrapMode: Text.WordWrap
                }
                Row{
                    spacing: app.fs
                    BotonUX{
                        id: botCodExistsMod
                        text: 'Modificar'
                        height: app.fs*1.6
                        fontColor: focus?app.c1:app.c2
                        bg.color: focus?app.c2:app.c1
                        glow.radius:focus?2:6
                        Keys.onReturnPressed: loadProd()
                        onClicked: loadProd()
                        function loadProd(){
                            xCodExists.visible=false
                            xCodExists.destroy(3000)
                            tiFolio.text=vagrado
                            tiGrado.text=vafolio
                            tiNombre.text=vanom
                            tiFechaNac.text=vafechanac
                            r.modificando=true
                            r.pIdAModificar=parseInt(vpid)
                        }
                    }
                    BotonUX{
                        text: 'Cerrar'
                        height: app.fs*1.6
                        fontColor: focus?app.c1:app.c2
                        bg.color: focus?app.c2:app.c1
                        glow.radius:focus?2:6
                        onClicked: xCodExists.destroy(10)
                    }
                }
            }
            Component.onCompleted: botCodExistsMod.focus=true
        }
    }
    function codExist(){
        let sql = 'select * from '+r.tableName+' where folio=\''+tiFolio.text+'\''
        let rows = unik.getSqlData(sql)
        let exists= rows.length>0
        if(exists){
            let comp = compExist
            let obj = comp.createObject(r, {vpid:rows[0].col[0], vagrado:rows[0].col[1],  vafolio:rows[0].col[2], vanom: rows[0].col[3], vafechanac: rows[0].col[4]})
        }
        return exists
    }
    function calcPorcVen(pcos, porc){
        let diff=pcos/100*porc
        return parseFloat(pcos+diff).toFixed(2)
    }
    function getCount(){
        let sql = 'select '+r.cols[0]+' from '+r.tableName
        let rows = unik.getSqlData(sql)
        return rows.length
    }
    function insert(){
        if(tiFolio.text===''||tiGrado.text===''||tiNombre.text===''||tiFechaNac.text===''||tiFechaCert.text===''){
            uLogView.showLog('Error!\nNo se han introducido todos los datos requeridos.\nPara registrar este alumno es necesario completar el formulario en su totalidad.')
            if(tiFolio.text===''){
                uLogView.showLog('Faltan los datos de folio.')
            }
            if(tiGrado.text===''){
                uLogView.showLog('Faltan los datos de grado.')
            }
            if(tiNombre.text===''){
                uLogView.showLog('Faltan los datos de nombre.')
            }
            if(tiFechaNac.text===''){
                uLogView.showLog('Faltan los datos de fecha de nacimiento.')
            }
            if(tiFechaCert.text===''){
                uLogView.showLog('Faltan los datos de fecha de certificado.')
            }
            return
        }
        if(r.tableName===''){
            uLogView.showLog('Table Name is empty!')
            return
        }
        if(r.cols.length===0){
            uLogView.showLog('Cols is empty!')
            return
        }
        let sql = 'select '+r.cols[0]+' from '+r.tableName+' where '+r.cols[0]+'=\''+tiFolio.text+'\''
        let rows = unik.getSqlData(sql)
        if(rows.length>=1){
            uLogView.showLog('Error! No se puede registrar el alumno con este número de folio.\nYa existe un alumno con el folio '+tiFolio.text)
            return
        }
        sql = 'insert into '+r.tableName+'('+r.cols+')values('+
                '\''+tiFolio.text+'\','+
                '\''+tiGrado.text+'\','+
                '\''+tiNombre.text+'\','+
                '\''+tiFechaNac.text+'\','+
                '\''+tiFechaCert.text+'\''+
                ')'
        let insertado = unik.sqlQuery(sql)
        if(insertado){
            labelStatus.text='Se ha registrado el alumno con el folio '+tiFolio.text
        }else{
            labelStatus.text='El alumno con el folio '+tiFolio.text+' no ha sido registrado correctamente.'
            r.uCodInserted=tiFolio.text
        }
        //uLogView.showLog('Registro Insertado: '+insertado)
    }
    function modify(){
        if(tiFolio.text===''||tiGrado.text===''||tiNombre.text===''||tiPrecioVenta.text===''||tiStock.text===''||tiFechaNac.text===''||tiFechaCert.text===''){
            uLogView.showLog('Error!\nNo se han introducido todos los datos requeridos.\nPara registrar este alumno es necesario completar el formulario en su totalidad.')
            if(tiFolio.text===''){
                uLogView.showLog('Faltan los datos de folio.')
            }
            if(tiGrado.text===''){
                uLogView.showLog('Faltan los datos de grado.')
            }
            if(tiNombre.text===''){
                uLogView.showLog('Faltan los datos de nombre.')
            }
            if(tiFechaNac.text===''){
                uLogView.showLog('Faltan los datos de fecha de nacimiento.')
            }
            if(tiFechaCert.text===''){
                uLogView.showLog('Faltan los datos de fecha de certificado.')
            }
            return
        }
        if(r.tableName===''){
            uLogView.showLog('Table Name is empty!')
            return
        }
        if(r.cols.length===0){
            uLogView.showLog('Cols is empty!')
            return
        }
        let sql = 'update '+r.tableName+' set '+
            app.colsAlumnos[0]+'=\''+tiFolio.text+'\','+
            app.colsAlumnos[1]+'=\''+tiGrado.text+'\','+
            app.colsAlumnos[2]+'=\''+tiNombre.text+'\','+
            app.colsAlumnos[3]+'=\''+tiFechaNac.text+'\','+
            app.colsAlumnos[4]+'=\''+tiFechaCert.text+'\''+
            ' where id='+r.pIdAModificar
        let insertado = unik.sqlQuery(sql)
        if(insertado){
            let msg='Se ha modificado el registro del alumno con folio '+tiFolio.text
            unik.speak(msg)
            labelStatus.text=msg
        }else{
            let msg='El alumno con el folio '+tiFolio.text+' no ha sido modificado correctamente.'
            unik.speak(msg)
            labelStatus.text=msg
            r.uCodInserted=tiFolio.text
        }
        //uLogView.showLog('Registro Insertado: '+insertado)
    }
    function updateGui(){
        labelCount.text=!r.modificando?'Creando el registro número '+parseInt(getCount() + 1):'Modificando el registro con código '+tiFolio.text
    }
}
