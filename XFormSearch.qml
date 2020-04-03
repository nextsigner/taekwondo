import QtQuick 2.0
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0

Item {
    id: r
    anchors.fill: parent
    property bool buscando: false
    property string currentTableName: ''
    property bool selectedAll: false
    onSelectedAllChanged: {
        cbSelectedAll.checked=selectedAll
        if(!cbSelectedAll.setearTodos&&!selectedAll){
            cbSelectedAll.setearTodos=true
            return
        }
        for(var i=0;i<lm.count+1; i++){
            if(lv.children[0].children[i]){
                lv.children[0].children[i].selected=selectedAll
            }
        }

    }
    onVisibleChanged: {
        tiSearch.focus=visible
        if(visible&&tiSearch.text===''){
            search()
        }
    }
    Settings{
        id: usFormSearch
        property string searchBy
        property int orderAscDesc
        property bool showTools
    }
    Column{
        id: colFormSearch
        width: parent.width-app.fs
        height: parent.height
        spacing: app.fs*0.25
        anchors.horizontalCenter: parent.horizontalCenter
        Row{
            spacing: app.fs*0.5
            anchors.horizontalCenter: parent.horizontalCenter
            UTextInput{
                id: tiSearch
                label: 'Buscar:'
                width: app.fs*18
                KeyNavigation.tab: lv
                onTextChanged: {
                    r.buscando=true
                    lv.currentIndex=0
                    search()
                }
            }
            BotonUX{
                id: botSearchTools
                text: 'Opciones de Busqueda'
                height: app.fs*2
                onClicked: usFormSearch.showTools=!usFormSearch.showTools
            }
            BotonUX{
                id: botDelete
                text: 'Eliminar Registro'
                height: app.fs*2
                onClicked: deleteRows()
            }
        }
        Row{
            id: rowRBX
            spacing: app.fs*0.5
            anchors.horizontalCenter: parent.horizontalCenter
            visible: usFormSearch.showTools
            Row{
                id: rowRB
                spacing: app.fs*0.5
                anchors.verticalCenter: parent.verticalCenter
                UText{text: '<b>Buscar por:</b>';anchors.verticalCenter: parent.verticalCenter}
                URadioButton{
                    id: rbCod
                    text: 'Folio'
                    checked: true
                    d: app.fs*1.4
                    onCheckedChanged: search()
                    anchors.verticalCenter: parent.verticalCenter
                }
                URadioButton{
                    id: rbDes
                    text: 'Nombre'
                    d: app.fs*1.4
                    onCheckedChanged: search()
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            UText{text: '<b>Ordenar por:</b>';anchors.verticalCenter: parent.verticalCenter}
            ComboBox{
                id: cbPor
                model: app.colsNameAlumnos
                currentIndex: app.colsNameAlumnos.indexOf(usFormSearch.searchBy)
                anchors.verticalCenter: parent.verticalCenter
                onCurrentTextChanged:{
                    usFormSearch.searchBy=currentText
                    search()
                }
            }
            ComboBox{
                id: cbAscDesc
                model: ['Ascendente', 'Descendente']
                currentIndex: usFormSearch.orderAscDesc
                anchors.verticalCenter: parent.verticalCenter
                onCurrentIndexChanged:{
                    usFormSearch.orderAscDesc=currentIndex
                    search()
                }
            }
        }

        UText{id: cant}
        Item{
            width: lv.width
            height: app.fs*4-colFormSearch.spacing
            Item{
                id:xRowTitDes
                width: lv.width
                height: app.fs*4
                property var anchos: [0.05,0.1, 0.25,0.4,0.1,0.1]
                property string fontColor: app.c1
                Row{
                    anchors.centerIn: parent
                    Rectangle{
                        width: xRowTitDes.width*xRowTitDes.anchos[0]
                        height:xRowTitDes.height
                        border.width: 2
                        border.color: app.c2
                        color: app.c1
                        CheckBox{
                            id: cbSelectedAll
                            anchors.centerIn: parent
                            property bool setearTodos: true
                            onClicked: cbSelectedAll.setearTodos=true
                            onCheckedChanged: {
                                r.selectedAll=checked
                            }
                        }
                    }
                    Repeater{
                        model: app.colsNameAlumnos
                        Rectangle{
                            width: xRowTitDes.width*xRowTitDes.anchos[index+1]
                            height:xRowTitDes.height
                            border.width: 2
                            border.color: app.c4
                            color: app.c2
                            UText{
                                text: (''+app.colsNameAlumnos[index]).replace(/ /g, '\n')
                                anchors.centerIn: parent
                                color: app.c1//xRowTitDes.fontColor
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                    }
                }
            }
        }
        Rectangle{
            width: parent.width
            height: usFormSearch.showTools?r.height-tiSearch.height-xRowTitDes.height-cant.height-colFormSearch.spacing*4-rowRBX.height:r.height-tiSearch.height-xRowTitDes.height-cant.height-colFormSearch.spacing*3
            color: 'transparent'
            border.color: app.c2
            border.width:   2
            UnikFocus{
                visible: lv.focus
                radius: 0
            }
            ListView{
                id: lv
                model: lm
                delegate: delPorCod//rbCod.checked?delPorCod:delPorDes
                spacing: 0//app.fs*0.5
                width: parent.width
                height: parent.height
                clip: true
                onFocusChanged: currentIndex=1
                KeyNavigation.tab: tiSearch
                Keys.onDownPressed: {
                    if(currentIndex<lm.count-1){
                        currentIndex++
                    }else{
                        currentIndex=1
                    }
                }
                Keys.onUpPressed: {
                    if(currentIndex>1){
                        currentIndex--
                    }else{
                        currentIndex=lm.count-1
                    }
                }
                ScrollBar.vertical: ScrollBar {}
                ListModel{
                    id: lm
                    function addDato(p1, p2, p3, p4, p5, p6){
                        return{
                            v1: p1,
                            v2: p2,
                            v3: p3,
                            v4:p4,
                            v5: p5,
                            v6: p6
                        }
                    }
                }
                Component{
                    id: delPorCod
                    Rectangle{
                        id:xRowDes
                        width: parent.width
                        height: app.fs*2//parseInt(v1)!==-10?app.fs*2:app.fs*3
                        radius: app.fs*0.1
                        border.width: 2
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: cbRow.checked?app.c1:app.c2
                        property string fontColor: cbRow.checked?app.c1:app.c2
                        property var arrayModeloDatos: [v2, v3, v4, v5, v6]//[v2, v3, v4, v5, v6]
                        property bool selected:false
                        property int rowId: v1
                        onSelectedChanged: {
                            cbRow.checked=selected
                        }
                        MouseArea{
                            anchors.fill: parent
                            onDoubleClicked: xFormInsert.loadModify(v1, v2, v3, v4, v5, v6)
                        }
                        Row{
                            anchors.centerIn: parent
                            Rectangle{
                                width: xRowDes.width*xRowTitDes.anchos[0]
                                height:xRowDes.height
                                border.width: 2
                                border.color: app.c2
                                color:app.c1
                                CheckBox{
                                    id: cbRow
                                    checked: xRowDes.selected
                                    anchors.centerIn: parent
                                    onCheckedChanged: {
                                        xRowDes.selected=checked
                                        if(!checked){
                                            cbSelectedAll.setearTodos=false
                                            r.selectedAll=false
                                        }
                                    }
                                }
                            }
                            Repeater{
                                model: app.colsNameAlumnos
                                Rectangle{
                                    width: xRowDes.width*xRowTitDes.anchos[index+1]
                                    height:xRowDes.height
                                    border.width: 2
                                    border.color:cbRow.checked?app.c1:app.c2
                                    color: cbRow.checked?app.c2:app.c1
                                    clip: true
                                    UText{
                                        id: txtCelda
                                        text: xRowDes.arrayModeloDatos[index]
                                        anchors.centerIn: parent
                                        color: xRowDes.fontColor
                                        horizontalAlignment: Text.AlignHCenter
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    Timer{
        running: r.visible
        repeat: true
        interval: 500
        onTriggered: {
            let cantSel=0
            for(var i=0;i<lm.count+1; i++){
                if(!lv.children[0].children[i]){
                    //return
                }
                if(lv.children[0].children[i].selected){
                    cantSel++
                }
            }
            if(cantSel===0){
                botDelete.visible=false
            }else{
                botDelete.visible=true
                if(cantSel===1){
                    botDelete.text='Eliminar Registro'
                }else{
                    botDelete.text='Eliminar '+cantSel+' Registros'
                }
            }
        }
    }
    Component.onCompleted: {
        if(r.visible)search()
    }
    function search(){
        //if(!buscando)return
        lm.clear()

        let colSearch=''
        if(rbCod.checked){
            colSearch='folio'
        }else{
            colSearch='nombre'
        }

        var p1=tiSearch.text!=='*'||tiSearch.text!==''?tiSearch.text.split(' '):('').split(' ')

        let sOrderByAndAsc=' order by '
        let ascDesc=cbAscDesc.currentIndex===0?'asc':'desc'
        if(usFormSearch.orderBy===''){
            sOrderByAndAsc+='id desc'
        }else{
            sOrderByAndAsc+=app.colsAlumnos[cbPor.currentIndex]+' '+ascDesc
        }

        //lm.append(lm.addDato('-10', tiSearch.text, '', '','',''))
        var b=colSearch+' like \'%'
        //b+=p1[0]+'%'
        for(var i=0;i<p1.length;i++){
            b+=p1[i]+'%'
        }
        b+='\' or '+colSearch+' like \'%'
        for(i=p1.length-1;i>-1;i--){
            b+=p1[i]+'%'
        }
        b+='\''
        var sql='select distinct * from '+app.tableName1+' where '+b+' '+sOrderByAndAsc
        console.log('Sql: '+sql)

        //uLogView.showLog('1 SQL SEARCH:'+sql)

        var rows=unik.getSqlData(sql)
        //console.log('Sql count result: '+rows.length)
        cant.text='Resultados: '+rows.length
        for(i=0;i<rows.length;i++){
            lm.append(lm.addDato(rows[i].col[0], rows[i].col[1], rows[i].col[2], rows[i].col[3], rows[i].col[4], rows[i].col[5]))
        }

        b=''
        for(var i=0;i<p1.length-1;i++){
            /*if(i===0){
                b+='nombre like \'%'+p1[i]+'%\' '
            }else{
                b+='or nombre like \'%'+p1[i]+'%\' '
            }*/
            //lm.append(lm.addDato('-10', p1[i], '', '','','',''))
            sql='select distinct * from '+app.tableName1+' where '+colSearch+' like \'%'+p1[i]+'%\' '+sOrderByAndAsc
            console.log('Sql 2: '+sql)
            var rows2=unik.getSqlData(sql)
            //console.log('Sql count result: '+rows.length)
            //cant.text='Resultados: '+parseInt(rows.length+rows2.length)
            for(var i2=0;i2<rows2.length;i2++){
                lm.append(lm.addDato(rows2[i2].col[0], rows2[i2].col[1], rows2[i2].col[2], rows2[i2].col[3], rows2[i2].col[4], rows[i].col[5]))
            }
        }
        //uLogView.showLog('2 SQL SEARCH:'+sql)
    }
    function deleteRows(){
        for(var i=0;i<lv.children[0].children.length; i++){
            let id=lv.children[0].children[i].rowId
            //uLogView.showLog('s: '+lv.children[0].children[i].selected)
            if(id&&lv.children[0].children[i].selected){
                let sql='delete from '+app.tableName1+' where id='+id
                unik.sqlQuery(sql)
            }
        }
        search()
    }
}
