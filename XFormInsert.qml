import QtQuick 2.0
import QtQuick.Controls 1.4

Item {
    id: r
    anchors.fill: parent
    property int numMod
    property bool modificando: false
    property int pIdAModificar: -1
    property string tableName: ''
    property string uCodInserted: ''
    property var cols: []
    property bool calsVisible: itemCalFN.visible||itemCalFC.visible
    property var currentCal
    property var uDateFNSelected
    property var uDate
    property var uMaxDate
    property var uMinDate
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
        id: col1
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
                width: app.fs*12
                maximumLength: 10
                KeyNavigation.tab: tiGrado
                property string uCodExist: ''
                textInput.onFocusChanged: {
                    if(textInput.focus){
                        itemCalFN.visible=false
                        itemCalFC.visible=false
                        textInput.selectAll()
                    }
                }
                onTextChanged: {
                    if(r.modificando)return
                    //tCheckCodExist.restart()
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
                width: r.width*0.5-tiFolio.width//-app.fs*2
                maximumLength: 250
                KeyNavigation.tab: tiNombre
                textInput.onFocusChanged: {
                    if(textInput.focus){
                        itemCalFN.visible=false
                        itemCalFC.visible=false
                        textInput.selectAll()
                    }
                }
            }
        }
        UTextInput{
            id: tiNombre
            label: 'Nombre: '
            width: r.width*0.5+app.fs
            maximumLength: 50
            //regularExp: RegExpValidator{regExp: /^\d+(\.\d{1,2})?$/ }
            KeyNavigation.tab: tiFechaNac
            textInput.onFocusChanged: {
                if(textInput.focus){
                    itemCalFN.visible=false
                    itemCalFC.visible=false
                    textInput.selectAll()
                }
            }
        }
        Row{
            z:labelCount.z+100
            spacing: app.fs*1.5
            UTextInput{
                id: tiFechaNac
                label: 'Fecha de Nacimiento: '
                width: tiNombre.width*0.5-app.fs*0.5
                maximumLength: 10
                textInput.enabled: false
                //regularExp: RegExpValidator{regExp: /^([1-9])([0-9]{10})/ }
                KeyNavigation.tab: tiFechaCert
                textInput.onFocusChanged: {
                    //textInput.selectAll()
                    //showCal(itemCalFN, 1)
                    itemCalFN.visible=true
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked:{
                        //showCal(itemCalFN, 1)
                        tiFolio.textInput.focus=false
                        tiGrado.textInput.focus=false
                        tiNombre.textInput.focus=false
                        tiFechaNac.textInput.focus=false
                        tiFechaCert.textInput.focus=false
                        itemCalFC.visible=false
                        itemCalFN.visible=true
                    }
                }
                Item{
                    id: itemCalFN
                    width: itemCalFC.width
                    height: app.fs*20
                    anchors.right: parent.right
                    anchors.rightMargin: app.fs*5
                    anchors.verticalCenter: parent.verticalCenter
                    visible: false
                    property string prevDateString:''
                    onVisibleChanged: {
                        if(visible&&tiFechaNac.text!==''){
                            prevDateString=tiFechaNac.text
                        }
                    }
                    //                    onVisibleChanged: {
                    //                        if(visible)return
                    //                        for(var i=0;i<itemCalFN.children.length;i++){
                    //                            itemCalFN.children[i].destroy(10)
                    //                        }
                    //                        r.focus=true
                    //                    }
                    Calendar{
                        id: cal1
                        anchors.fill: parent
                        property bool setTextInput: false
                        onSelectedDateChanged: {
                            let d = selectedDate
                            let dia=''+d.getDate()
                            let mes=''+parseInt(d.getMonth()+1)
                            if(parseInt(dia)<10){
                                dia='0'+dia
                            }
                            if(parseInt(mes)<10){
                                mes='0'+mes
                            }
                            let an=d.getFullYear()
                            let s=''+dia+'/'+mes+'/'+an
                            if(setTextInput){
                                tiFechaNac.text=s
                                itemCalFN.visible=false
                                itemCalFC.visible=true
                            }
                            setTextInput=true
                        }
                    }
                }
            }
            UTextInput{
                id: tiFechaCert
                label: 'Fecha de Certificado: '
                width: tiNombre.width*0.5-app.fs
                maximumLength: 10
                textInput.enabled: false
                //regularExp: RegExpValidator{regExp: /^([1-9])([0-9]{10})/ }
                KeyNavigation.tab: botReg
                textInput.onFocusChanged: {
                    //textInput.selectAll()
                    //showCal(itemCalFC, 2)
                    itemCalFC.visible=true
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked:{
                        //showCal(itemCalFC, 2)
                        tiFolio.textInput.focus=false
                        tiGrado.textInput.focus=false
                        tiNombre.textInput.focus=false
                        tiFechaNac.textInput.focus=false
                        tiFechaCert.textInput.focus=false
                        itemCalFN.visible=false
                        itemCalFC.visible=true
                    }
                }
                Item{
                    id: itemCalFC
                    width: r.width-col1.x-tiFechaCert.x-tiFechaCert.width
                    height: app.fs*20
                    anchors.left: parent.right
                    anchors.leftMargin: 0
                    anchors.verticalCenter: parent.verticalCenter
                    visible: false
                    property string prevDateString: ''
                    onVisibleChanged: {
                        if(visible&&tiFechaCert.text!==''){
                            prevDateString=tiFechaCert.text
                        }
                    }
                    Calendar{
                        id: cal2
                        anchors.fill: parent
                        property bool setTextInput: false
                        onSelectedDateChanged: {
                            let d = selectedDate
                            let dia=''+d.getDate()
                            let mes=''+parseInt(d.getMonth()+1)
                            if(parseInt(dia)<10){
                                dia='0'+dia
                            }
                            if(parseInt(mes)<10){
                                mes='0'+mes
                            }
                            let an=d.getFullYear()
                            let s=''+dia+'/'+mes+'/'+an
                            if(setTextInput){
                                tiFechaCert.text=s
                                itemCalFC.visible=false
                            }
                            setTextInput=true
                        }
                    }
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
                    clear()
                }
                UnikFocus{}
            }
            BotonUX{
                id: botCancelarModificar
                text: 'Cancelar'
                height: app.fs*2
                visible: r.modificando
                onClicked: {
                    r.modificando=false
                    clear()
                }
            }
            BotonUX{
                id: botReg
                text: !r.modificando?'Guardar Registro':'Modificar Registro'
                height: app.fs*2
                onClicked: {
                    if(!r.modificando){
                        if(codExist()){
                            let msg='<b>Atención!: </b>El folio actual ya existe.'
                            unik.speak(msg.replace(/<[^>]*>?/gm, ''))
                            labelStatus.text=msg
                        }else{
                            insert()
                        }
                    }else{
                        modify()
                        r.modificando=false
                    }
                }
                KeyNavigation.tab: tiFolio
                Keys.onReturnPressed: {
                    if(!r.modificando){
                        if(codExist()){
                            let msg='<b>Atención!: </b>El folio actual ya existe.'
                            unik.speak(msg.replace(/<[^>]*>?/gm, ''))
                            labelStatus.text=msg
                        }else{
                            insert()
                        }
                    }else{
                        modify()
                        r.modificando=false
                    }
                }
                UnikFocus{}
            }
        }
        UText{
            id: labelCalCmd
            width: parent.width
            height: app.fs*2
            wrapMode: Text.WordWrap
            opacity: itemCalFC.visible||itemCalFN.visible?1.0:0.0
            text: 'Presionar arriba o abajo para cambiar día.\nPresionar derecha o izquierda para cambiar mes.\nPresionar Shift+derecha o Shift+izquierda para cambiar de año.'
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
            border.color: app.c2
            anchors.centerIn: parent
            color: app.c1
            property string vaid: ''
            property string vafolio: ''
            property string vagrado: ''
            property string vanom: ''
            property string vafechanac: ''
            property string vafechacert: ''
            Column{
                id: colExists
                spacing: app.fs
                width: parent.width-app.fs
                anchors.centerIn: parent
                UText{
                    id: txt
                    color:app.c2
                    font.pixelSize: app.fs
                    text: '<br /><b style="font-size:'+app.fs+'px;">Id único del registro: </b><span style="font-size:'+app.fs+'px;">'+vaid+'</span><br /><br /><b style="font-size:'+app.fs+'px;">Folio: </b><span style="font-size:'+app.fs+'px;">'+vafolio+'</span><br /><b  style="font-size:'+app.fs*1.4+'px;">Grado: </b><span style="font-size:'+app.fs+'px;">'+vagrado+'</span><br /><b style="font-size:'+app.fs+'px;">Nombre: </b> <span style="font-size:'+app.fs+'px;">'+vanom+'</span><br /><b>Fecha de Nacimiento: </b>'+vafechanac+'<br /><b>Fecha de Certificado: </b>'+vafechacert+'<br />'
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
                            tiFolio.text=vafolio
                            tiGrado.text=vagrado
                            tiNombre.text=vanom
                            tiFechaNac.text=vafechanac
                            tiFechaCert.text=vafechacert
                            tiFolio.focus=true
                            r.modificando=true
                            r.pIdAModificar=parseInt(vaid)
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
    Component.onCompleted: {
        tiFolio.focus=true
    }
    function codExist(){
        let sql = 'select * from '+r.tableName+' where folio=\''+tiFolio.text+'\''
        let rows = unik.getSqlData(sql)
        let exists= rows.length>0
        if(exists){
            let comp = compExist
            let obj = comp.createObject(r, {vaid:rows[0].col[0], vafolio:rows[0].col[1],  vagrado:rows[0].col[2], vanom: rows[0].col[3], vafechanac: rows[0].col[4], vafechacert: rows[0].col[5]})
        }
        return exists
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
        let m0DFN=tiFechaNac.text.split('/')
        let m0DFC=tiFechaCert.text.split('/')
        let dateFN= new Date(parseInt(m0DFN[2]), parseInt(m0DFN[1] - 1), parseInt(m0DFN[0]))
        let dateFC= new Date(parseInt(m0DFC[2]), parseInt(m0DFC[1] - 1), parseInt(m0DFC[0]))
        sql = 'insert into '+r.tableName+'('+r.cols+')values('+
                '\''+tiFolio.text+'\','+
                '\''+tiGrado.text+'\','+
                '\''+tiNombre.text+'\','+
                ''+dateFN.getTime()+','+
                '\''+dateFC.getTime()+'\''+
                ')'
        let insertado = unik.sqlQuery(sql)
        if(insertado){
            labelStatus.text='Se ha registrado el alumno con el folio '+tiFolio.text
        }else{
            labelStatus.text='El alumno con el folio '+tiFolio.text+' no ha sido registrado correctamente.'
            r.uCodInserted=tiFolio.text
        }
        clear()
        //uLogView.showLog('Registro Insertado: '+insertado)
    }
    function modify(){
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
        clear()
        //uLogView.showLog('Registro Insertado: '+insertado)
    }
    function updateGui(){
        labelCount.text=!r.modificando?'Creando el registro número '+parseInt(getCount() + 1):'Modificando el registro con folio '+tiFolio.text
    }
    function loadModify(p1, p2, p3, p4, p5, p6){
        r.modificando=true
        app.mod=r.numMod
        tiFolio.text=p2
        tiGrado.text=p3
        tiNombre.text=p4
        tiFechaNac.text=p5
        tiFechaCert.text=p6
    }
    function clear(){
        tiFolio.text=''
        tiGrado.text=''
        tiNombre.text=''
        tiFechaNac.text=''
        tiFechaCert.text=''
        tiFolio.focus=true
        labelStatus.text='Formulario limpiado.'
    }

    function upForm(){
        if(!itemCalFN.visible&&!itemCalFC.visible){
            return
        }
        if(itemCalFN.visible){
            r.currentCal=cal1
        }
        if(itemCalFC.visible){
            r.currentCal=cal2
        }
        if(r.currentCal){
            var ayer = r.currentCal.selectedDate;
            ayer.setDate(ayer.getDate() - 1);
            //r.currentCal.hide=true
            r.currentCal.setTextInput=false
            r.currentCal.selectedDate=ayer
            //r.currentCal.hide=false
        }
    }
    function downForm(){
        if(!itemCalFN.visible&&!itemCalFC.visible){
            return
        }
        if(itemCalFN.visible){
            r.currentCal=cal1
        }
        if(itemCalFC.visible){
            r.currentCal=cal2
        }
        if(r.currentCal){
            var ayer = r.currentCal.selectedDate;
            ayer.setDate(ayer.getDate() + 1);
            r.currentCal.setTextInput=false
            r.currentCal.selectedDate=ayer
        }
    }
    function rightForm(){
        if(!itemCalFN.visible&&!itemCalFC.visible){
            return
        }
        if(itemCalFN.visible){
            r.currentCal=cal1
        }
        if(itemCalFC.visible){
            r.currentCal=cal2
        }
        if(r.currentCal){
            var ahora = r.currentCal.selectedDate;
            ahora.setMonth(ahora.getMonth() + 1);
            r.currentCal.setTextInput=false
            r.currentCal.selectedDate=ahora
        }
    }
    function leftForm(){
        if(!itemCalFN.visible&&!itemCalFC.visible){
            return
        }
        if(itemCalFN.visible){
            r.currentCal=cal1
        }
        if(itemCalFC.visible){
            r.currentCal=cal2
        }
        if(r.currentCal){
            var ahora = r.currentCal.selectedDate;
            ahora.setMonth(ahora.getMonth() - 1);
            r.currentCal.setTextInput=false
            r.currentCal.selectedDate=ahora
        }
    }
    function shiftRightForm(){
        if(r.currentCal){
            var ahora = r.currentCal.selectedDate;
            ahora.setYear(ahora.getFullYear() + 1);
            r.currentCal.selectedDate=ahora
        }
    }
    function shiftLeftForm(){
        if(r.currentCal){
            var ahora = r.currentCal.selectedDate;
            ahora.setYear(ahora.getFullYear() - 1);
            r.currentCal.setTextInput=false
            r.currentCal.selectedDate=ahora
        }
    }
    function enterForm(){
        if(botReg.focus){
            botReg.clicked()
            return
        }
        if(!itemCalFN.visible&&tiFechaNac.focus){
            //showCal(itemCalFN, 1)
            itemCalFN.visible=true
            return
        }
        if(!itemCalFC.visible&&tiFechaCert.focus){
            //showCal(itemCalFC, 2)
            itemCalFC.visible=true
            return
        }
        if(r.currentCal){
            let d = r.currentCal.selectedDate
            let dia=d.getDate()
            let mes=d.getMonth()+1
            let an=''+d.getFullYear()
            let s=''+dia+'/'+mes+'/'+an
            if(itemCalFN.visible){
                tiFechaNac.text=s
                itemCalFN.visible=false
            }
            if(itemCalFC.visible){
                tiFechaCert.text=s
                itemCalFC.visible=false
                botReg.focus=true
            }
        }
    }
    function escForm(){
        if(itemCalFN.visible){
            tiFechaNac.text=itemCalFN.prevDateString
        }
        if(itemCalFC.visible){
            tiFechaCert.text=itemCalFC.prevDateString
        }
        itemCalFN.visible=false
        itemCalFC.visible=false
    }
}
