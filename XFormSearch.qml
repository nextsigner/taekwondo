import QtQuick 2.0
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0

Item {
    id: r
    anchors.fill: parent
    property bool buscando: false
    property string currentTableName: ''
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
        width: parent.width-app.fs
        height: parent.height
        spacing: app.fs*0.5
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
                    //                    if(text===''){
                    //                        lm.clear()
                    //                        return
                    //                    }
                    search()
                }
            }
            BotonUX{
                id: botSearch
                text: 'Buscar'
                height: app.fs*2
                onClicked: search()
            }
            BotonUX{
                id: botSearchTools
                text: 'Opciones de Busqueda'
                height: app.fs*2
                onClicked: usFormSearch.showTools=!usFormSearch.showTools
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
        Rectangle{
            width: parent.width
            height: r.height-tiSearch.height-app.fs*2-cant.height
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
                spacing: app.fs*0.5
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
                ListModel{
                    id: lm
                    function addProd(pid, pcod, pdes, pcos, pven, pstock, pgan){
                        return{
                            vpid: pid,
                            vpcod: pcod,
                            vpdes: pdes,
                            vpcos:pcos,
                            vpven: pven,
                            vpstock: pstock,
                            vpgan: pgan
                        }
                    }
                }
                Component{
                    id: delPorCod
                    Rectangle{
                        id:xRowDes
                        width: parent.width
                        height: parseInt(vpid)!==-10?txtDes.height+app.fs:app.fs*3
                        radius: app.fs*0.1
                        border.width: 2
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: parseInt(vpid)!==-10&&index!==lv.currentIndex?app.c1:app.c2
                        property string fontColor: index!==lv.currentIndex?app.c2:app.c1
                        Row{
                            visible: parseInt(vpid)!==-10
                            anchors.centerIn: parent
                            Rectangle{
                                id: xRD1
                                width: app.fs*10
                                height:xRD2.height
                                border.width: 2
                                border.color: app.c2
                                color: parseInt(vpid)!==-10&&index!==lv.currentIndex?app.c1:app.c2
                                UText{
                                    text: vpcod
                                    anchors.centerIn: parent
                                    color: xRowDes.fontColor
                                }
                            }
                            Rectangle{
                                id: xRD2
                                width: xRowDes.width-xRD1.width-xRD3.width
                                height:txtDes.contentHeight+app.fs*2
                                border.width: 2
                                border.color: app.c2
                                color: parseInt(vpid)!==-10&&index!==lv.currentIndex?app.c1:app.c2
                                UText{
                                    id: txtDes
                                    text: vpdes
                                    color: xRowDes.fontColor
                                    width: parent.width-app.fs
                                    wrapMode: Text.WordWrap
                                    anchors.centerIn: parent
                                }
                            }
                            Rectangle{
                                id: xRD3
                                width: app.fs*10
                                height:xRD2.height
                                border.width: 2
                                border.color: app.c2
                                color: parseInt(vpid)!==-10&&index!==lv.currentIndex?app.c1:app.c2
                                UText{
                                    text: ''+vpcos
                                    color: xRowDes.fontColor
                                    anchors.centerIn: parent
                                }
                            }
                        }
                        Rectangle{
                            visible: parseInt(vpid)===-10
                            width: xRowDes.width
                            height:app.fs*3
                            border.width: 2
                            border.color: app.c2
                            color: app.c1
                            UText{
                                text: tiSearch.text==='*'?'Mostrando todos los alumnos.':'Resultados de '+tiSearch.text
                                color: app.c2
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: app.fs
                            }
                        }
                        BotonUX{
                            text: 'Eliminar'
                            height: app.fs*2
                            fontColor: app.c2
                            bg.color: app.c1
                            glow.radius: 2
                            visible: index===lv.currentIndex&&parseInt(vpid)!==-10
                            anchors.right: parent.right
                            anchors.rightMargin: app.fs*0.5
                            anchors.verticalCenter: parent.verticalCenter
                            onClicked: {
                                let sql='delete from '+r.currentTableName+' where id='+vpid
                                unik.sqlQuery(sql)
                                search()
                            }
                        }
                    }
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

        lm.append(lm.addProd('-10', tiSearch.text, '', '',''))
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
            lm.append(lm.addProd(rows[i].col[0], rows[i].col[1], rows[i].col[2], rows[i].col[3], rows[i].col[4]))
        }

        b=''
        for(var i=0;i<p1.length-1;i++){
            /*if(i===0){
                b+='nombre like \'%'+p1[i]+'%\' '
            }else{
                b+='or nombre like \'%'+p1[i]+'%\' '
            }*/
            //lm.append(lm.addProd('-10', p1[i], '', '','','',''))
            sql='select distinct * from '+app.tableName1+' where '+colSearch+' like \'%'+p1[i]+'%\' '+sOrderByAndAsc
            console.log('Sql 2: '+sql)
            var rows2=unik.getSqlData(sql)
            //console.log('Sql count result: '+rows.length)
            //cant.text='Resultados: '+parseInt(rows.length+rows2.length)
            for(var i2=0;i2<rows2.length;i2++){
                lm.append(lm.addProd(rows2[i2].col[0], rows2[i2].col[1], rows2[i2].col[2], rows2[i2].col[3], rows2[i2].col[4]))
            }
        }

        //uLogView.showLog('2 SQL SEARCH:'+sql)
    }
}
