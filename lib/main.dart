import 'package:Vocabulary/savedata.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toast/toast.dart';

import 'DatabaseClass/DatabaseHelper.dart';
import 'DatabaseClass/Details.dart';

void main()
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Vocabulary",
      home: MainActivity(),
    );
  }
}

class MainActivity extends StatefulWidget {
  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {

  List<Details> listData = [];
  int count = 0;
  @override
  Widget build(BuildContext context) {
    showData();
    return Scaffold(
      appBar: AppBar(title: Text('Vocabulary'),),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Add Data',
        onPressed: () => Navigator.push(context,
        MaterialPageRoute(builder: (context) => SaveData(title: "Add Data",))),
      ),
      drawer: Drawer(
        child: ,
      ),
      body: Container(
        child: Center(
          child: ListView.builder(
            itemCount: count,
            itemBuilder: (_,index){
              return GestureDetector(
                  onTap: (){
                  setState(() {
                    Details data = Details.withId(listData[index].id,
                    listData[index].spell,listData[index].meaning,listData[index].synonyms);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                        SaveData(title: "Edit Data", data: data)));
                  });
                },
                child: Card(
                  elevation: 5.0,
                  shadowColor: Colors.blue,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: Icon(Icons.arrow_right_outlined,size: 35,),
                    title: Padding(child: Text(listData[index].spell,style: TextStyle(
                      fontSize: 18,color: Colors.blue, fontWeight: FontWeight.bold
                    ),),padding:
                      EdgeInsets.only(bottom: 5,left: 10),),
                    subtitle:
                    Padding(child: Text('->   ${listData[index].meaning} \n'
                        '->   ${listData[index].synonyms}'),padding:
                    EdgeInsets.only(left: 10),),

                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        DialogBox(context , index);

                      }
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  void deletData(int id)async
  {
    int result = await DatabaseHelper.delet_Data(id);
    if (result != 0) {
      Toast.show("Successful",context);
      debugPrint("Successful");
    } else {
      Toast.show("UnSuccessful",context);
      debugPrint("UnSuccessful");
    }
  }
  void showData() async
  {
    Future<Database> getDatabase =  DatabaseHelper.initsetDatabase();
    getDatabase.then((value){
      Future<List<Details>> getData = DatabaseHelper.getValueToObject();
      getData.then((value){
        setState(() {
          this.listData = value;
          this.count = value.length;
        });
      });
    });
  }

  void DialogBox(BuildContext context , int index)
  {
    var dialog = Dialog(
      child: Container(
        width: 200.0,
        height: 200.0,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.only(top: 20 )),
              Icon(Icons.delete ,size: 50,color: Colors.blue,),
              Padding(padding: EdgeInsets.only(top: 5)),
              Text("Delete?",style: TextStyle(fontSize: 17),),
              Padding(padding: EdgeInsets.only(top: 30 )),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 20, right: 10),
                      child: FlatButton(
                          child: Text("Delete",style: TextStyle(
                            color: Colors.white
                          ),),
                          color: Colors.blue,
                          splashColor: Colors.black,
                          onPressed: () {
                            deletData(listData[index].id);
                            Navigator.pop(context);
                          }
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10, right: 20),
                      child: FlatButton(
                        child: Text("Cancel"),
                        onPressed: () => Navigator.pop(context),
                        color: Colors.grey.shade100,
                        splashColor: Colors.black,
                      ),
                    ),
                  ),
                ]
              )
            ],
          )
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      elevation: 5.0,
    );
    showDialog(context: context, builder: (context) => dialog,barrierDismissible: false);
  }


}



