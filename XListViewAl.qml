import QtQuick 2.12
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0
import "func.js" as JS

Column{
    id: r
    width: parent.parent.width-app.fs
    height: app.fs*12
    visible: lm.count>0
    property alias listModel: lm
    signal idSelected(int id, string nom)
    onVisibleChanged: {
        lv.focus=visible
    }
    Item{
        width: lv.width
        height: app.fs*4-app.fs*0.25
        Item{
            id:xRowTitDes
            width: lv.width
            height: app.fs*4
            property var anchos: [0.05,0.25, 0.05,0.25,0.2,0.2]
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
                        property bool setearTos: true
                        onClicked: cbSelectedAll.setearTodos=true
                        onCheckedChanged: {
                            //r.selectedAll=checked
                            if(!setearTodos){
                                cbSelectedAll.setearTodos=true
                                //setBtnDeleteText()
                                return
                            }
                            for(var i=0;i<lm.count; i++){
                                lm.get(i).v7=checked
                            }
                            //setBtnDeleteText()
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        enabled: false
                        opacity: 0.0
                        onClicked: {
                            cbSelectedAll.checked=!cbSelectedAll.checked
                            r.idsSelected=[]
                            search()
                            /*if(!cbSelectedAll.checked){

                        }else{
                            r.idsSelected=[]
                            cbSelToTop.checked=false
                        }*/
                            for(var i=0;i<lm.count; i++){
                                lm.get(i).v7=cbSelectedAll.checked
                            }
                            //setBtnDeleteText()
                        }
                    }
                }
                Repeater{
                    model: app.colsNameDatosAlumnos
                    Rectangle{
                        width: xRowTitDes.width*xRowTitDes.anchos[index+1]
                        height:xRowTitDes.height
                        border.width: 2
                        border.color: app.c4
                        color: app.c2
                        UText{
                            text: '<b>'+(''+app.colsNameDatosAlumnos[index]).replace(/ /g, '<br />')+'</b>'
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
        height: r.height-xRowTitDes.height-app.fs*0.25
        color: 'transparent'
        border.color: app.c2
        border.width:   2
        //            UnikFocus{
        //                visible: lv.focus
        //                radius: 0
        //            }
        ListView{
            id: lv
            model: lm
            delegate: delPorCod//rbCod.checked?delPorCod:delPorDes
            spacing: 0//app.fs*0.5
            width: parent.width
            height: parent.height
            clip: true
            KeyNavigation.tab: botCC
            Keys.onDownPressed: downRow()
            Keys.onUpPressed: upRow()
            boundsBehavior: ListView.StopAtBounds
            ScrollBar.vertical: ScrollBar {}
            cacheBuffer: 1000
            displayMarginBeginning: lm.count*app.fs*2
            displayMarginEnd: lm.count*app.fs*2
            onCurrentIndexChanged: {
                //usFormSearch.uCurrentIndex=currentIndex
            }
            ListModel{
                id: lm
                function addDato(p1, p2, p3, p4, p5, p6){
                    return{
                        v1: p1,
                        v2: p2,
                        v3: p3,
                        v4:p4,
                        v5: p5,
                        v6: p6,
                        v7: false
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
                    property bool selected:v7//r.idsSelected.length>0?parseInt(idsSelected.indexOf(v1)+1):v7
                    property int rowId: v1
                    Keys.onDownPressed: downRow()
                    Keys.onUpPressed: upRow()
                    Keys.onSpacePressed: {
                        lv.currentIndex=index
                        cbRow.checked=!cbRow.checked
//                        if(cbSelToTop.checked){
//                            search()
//                        }
                        //uLogView.showLog('Spacing'+index)
                    }
                    onSelectedChanged: {
                        cbRow.checked=selected
                    }
//                    MouseArea{
//                        anchors.fill: parent
//                        onDoubleClicked: xFormInsert.loadModify(v1, v2, v3, v4, v5, v6)
//                    }
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
                                    if(!checked){
                                       // cbSelectedAll.setearTodos=false
                                        //cbSelectedAll.checked=false
                                        //r.selectedAll=false
                                    }
                                    idSelected(v1,v2)
                                    //setBtnDeleteText()
//                                    if(!tiSearch.textInput.focus){
//                                        lv.focus=true
//                                    }
                                    let allSelected=true
                                    for(var i=0;i<lm.count; i++){
                                        lm.get(i).v7=false
                                    }
                                    v7=checked
//                                    if(allSelected){
//                                        cbSelectedAll.setearTodos=false
//                                        cbSelectedAll.checked=allSelected
//                                    }
//                                    if(checked){
//                                        if(r.idsSelected.indexOf(parseInt(v1))<0){
//                                            r.idsSelected.push(parseInt(v1))
//                                        }
//                                    }else{
//                                        r.idsSelected = JS.removeItemFromArr(r.idsSelected, parseInt(v1))
//                                    }
                                    //cant.text=r.idsSelected.toString()

                                }
                                Timer{
                                    id: tSearchSelToTop
                                    running: false
                                    repeat: false
                                    interval: 500
                                    onTriggered: search()
                                }
                                MouseArea{
                                    anchors.fill: parent
                                    onDoubleClicked: {
                                        lv.currentIndex=index
                                        //setBtnDeleteText()
                                    }
                                    onClicked: {
                                        cbRow.checked=!cbRow.checked
//                                        if(cbSelToTop.checked){
//                                            search()
//                                        }
                                        //setBtnDeleteText()
                                    }
                                }
                                Rectangle{
                                    anchors.centerIn: parent
                                    width: parent.contentItem.width
                                    height: parent.contentItem.height
                                    border.width: 3
                                    border.color: 'red'
                                    color: 'transparent'
                                    visible: index===lv.currentIndex
                                    z:parent.z+100000
                                    onVisibleChanged: {
                                        if(visible)lv.currentIndex=index
                                    }
                                }
                            }
                        }
                        Repeater{
                            model: app.colsNameDatosAlumnos
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
                                    //color: index===3||index===4?'red':'blue'
                                }
                            }
                        }
                    }
                    //                        UText{
                    //                            text: '<b>'+parseInt(index +1)+'</b>'
                    //                            font.pixelSize: app.fs*0.6
                    //                            color: 'red'
                    //                            anchors.verticalCenter: parent.verticalCenter
                    //                            anchors.left: parent.left
                    //                            anchors.leftMargin: app.fs*0.5
                    //                        }
                    Component.onCompleted: {
//                        if(idsSelected.indexOf(parseInt(v1))>=0){
//                            xRowDes.selected=true
//                        }else{
//                            cbSelectedAll.setearTodos=false
//                            cbSelectedAll.checked=false
//                        }
                    }
                }
            }
        }
    }
}
