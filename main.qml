import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ApplicationWindow {
    id:win
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")


    GridLayout {
        id : grid
       // width: 640
       // height: 480
        anchors.fill: parent
        property var lista:[1,1,1,1,1,1,1,1,1]
        onListaChanged: {
             repeater.model=0
             repeater.model= grid.lista.length
        }
        property double colMulti : (grid.width - (columnSpacing*2))/columns
        property double rowMulti :( grid.height- (rowSpacing*2))/rows


        function prefWidth(index){
                 return colMulti * index
        }
        function prefHeight(){
            return rowMulti
        }

        function modColSpan(clSpan,cellSel) {
           var lista=grid.lista
            switch(cellSel){
              case 0:
              case 3:
              case 6:
                       if(clSpan==3) {
                           lista[cellSel+1]=0
                           lista[cellSel+2]=0
                           lista[cellSel]=clSpan
                       }
                       else if(clSpan==2){

                           lista[cellSel+1]=1
                           lista[cellSel+2]=0
                            lista[cellSel]=clSpan
                        }
                       else if(clSpan==1){
                          lista[cellSel+1]=1
                          lista[cellSel+2]=1
                           lista[cellSel]=clSpan
                       }
                       break;
              case 1:
              case 4:
              case 7:
                       if(clSpan==3) {
                           lista[cellSel-1]=0
                           lista[cellSel+1]=0
                           lista[cellSel]=clSpan
                       }
                       else if(clSpan==2){
                           lista[cellSel+1]=0
                           lista[cellSel-1]=1
                            lista[cellSel]=clSpan
                        }
                       else if(clSpan==1){
                          lista[cellSel+1]=1
                          lista[cellSel-1 ]=1
                          lista[cellSel]   =clSpan
                       }
                       break;
              case 2:
              case 5:
              case 8:
                       if(clSpan==3) {
                           lista[cellSel-1]=0
                           lista[cellSel-2]=0
                           lista[cellSel]=clSpan
                       }
                       else if(clSpan==2){
                           lista[cellSel-1]=0
                           lista[cellSel-2]=1
                            lista[cellSel]=clSpan
                        }
                       else if(clSpan==1){
                          lista[cellSel-1]=1
                          lista[cellSel-2 ]=1
                          lista[cellSel]   =clSpan
                       }
                       break;

              default : break;

            }
           grid.lista=lista
        }
        //anchors.fill: parent

        rows    : 3
        columns : 3
        columnSpacing: 20
        rowSpacing: 20

        Repeater{
             id:repeater
             model: 6//grid.lista.length
             Rectangle {

               visible: grid.lista[index]==0 ? false : true
               color :  Qt.rgba(Math.random(),Math.random(),Math.random(),1)

               Layout.preferredWidth:
                   switch(grid.lista[index])
                     {
                               case 0 : 0; break;
                               case 1:
                                   grid.colMulti;
                                   //200;
                                   break;
                               case 2: //420;
                                   grid.colMulti*2+grid.columnSpacing   ;
                                   break;
                               case 3:
                                  // 640;
                                   grid.colMulti*3+grid.columnSpacing*2 ;
                                   break;
                     }
                Layout.preferredHeight:  grid.prefHeight()
               // Layout.fillWidth: true   // se non è commentato ho problemi quando cambio la columnSpan a 2
                Layout.columnSpan:  grid.lista[index] == 0 ? 4 : grid.lista[index]
                Layout.rowSpan: 1
                Text{
                 text: index + " CLSPAN: " + grid.lista[index] + "\n"+" " + "width:"+parent.width+ "\n"+"height:"+parent.height
                 font.pointSize: 10
                 anchors.horizontalCenter: parent.horizontalCenter
                 anchors.verticalCenter: parent.verticalCenter
                }
                MouseArea{
                   anchors.fill: parent
                   onClicked: {
                       pop.cellaSel=index
                       pop.open()
                       pop.cellSpan= grid.lista[index]
                       pop.x=parent.x+10
                       pop.y=parent.y+10
                   }
                }
             }
        }
    }



    Popup {
           id: pop
           property int  cellaSel: 0
           property int  cellSpan: 1
           signal changeColumnSpan(int valSelezionato)
           x:(parent.width/2) - (width/2)
           y: (parent.height/2) - (height/2)
           width: parent.width*0.40
           height: parent.height*0.40
           background: Rectangle {
                   border.color: "red"
           }
           contentItem: Item{

                Text{
                 anchors.top: parent.top
                 anchors.topMargin: 20
                 text: "Selezionare Grandezza Mattonella"
                 anchors.horizontalCenter: parent.horizontalCenter
                 font.pointSize: 10
               }
                ComboBox {
                   id:comboBox
                   model: ["1", "2", "3"]
                   currentIndex: pop.cellSpan-1
                   anchors.verticalCenter: parent.verticalCenter
                   anchors.horizontalCenter: parent.horizontalCenter
                   anchors.verticalCenterOffset: -40

               }
                RowLayout {
                        spacing: 20
                        width: parent.width
                        Button {
                            Layout.preferredWidth: 50
                            Layout.fillWidth: true
                            text: "Chiudi"
                            onClicked: pop.close()
                        }
                        Button {
                            Layout.fillWidth: true
                            Layout.preferredWidth:50
                            text: "Cambia ColumnSpan"
                            onClicked: pop.changeColumnSpan(comboBox.currentIndex+1)

                        }
                        anchors.bottom: parent.bottom ; anchors.bottomMargin: 20
                    }
           }
           modal: false // ho l'opacità nera trasparente attorno se è true
           focus: true
           closePolicy: Popup.CloseOnEscape | Popup.CloseOnReleaseOutside  // CON CLOSE ESCAPE SE PREMO ESC SI CHIUDE
           enter: Transition {
                   NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
           }
           exit: Transition {
                  NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
           }
           onChangeColumnSpan: {
               grid.modColSpan(valSelezionato,cellaSel) // function per modificare i valori della lista dei columSpan
               close()

           }

       }


}


