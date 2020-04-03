function setBd() {
    let folderBds=""+pws+"/taekwondo/bds"
    let bd=apps.bdFileName.indexOf('\\')<0?""+folderBds+"/"+apps.bdFileName:""+apps.bdFileName.replace(/\\\\/g, '/')
    if(!unik.fileExist(bd)){
        apps.bdFileName=getNewBdName()
        bd=""+folderBds+"/"+apps.bdFileName
    }
    //bd="C:\\Users\\qt\\Documents\\unik\\taekwondo\\bds\\productos_24_2_20_17_4_1.sqlite"
    //uLogView.showLog('Iniciando Bd: '+bd)
    let iniciado=unik.sqliteInit(bd)
    //uLogView.showLog('Iniciado: '+iniciado)

    let sql='CREATE TABLE IF NOT EXISTS '+app.tableName1
        +'('
        +'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        +app.colsAlumnos[0]+' TEXT NOT NULL,'
        +app.colsAlumnos[1]+' TEXT NOT NULL,'
        +app.colsAlumnos[2]+' TEXT NOT NULL,'
        +app.colsAlumnos[3]+' TEXT NOT NULL,'
        +app.colsAlumnos[4]+' TEXT NOT NULL'
        +')'
    unik.sqlQuery(sql)
    //console.log('Ejecutado: '+ejecutado)
}

function setFolders(){
    if(!unik.folderExist('facts')){
        unik.mkdir('facts')
    }
    unik.debugLog=true

    if(!unik.folderExist(pws+'/taekwondo')){
        unik.mkdir(pws+'/taekwondo')
    }
    if(!unik.folderExist(pws+'/taekwondo/bds')){
        unik.mkdir(pws+'/taekwondo/bds')
    }
    //apps.bdFileName=''
    //apps.bdFileName=unik.currentFolderPath()+'/bds/p.sqlite'
}
