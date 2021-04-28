import 'package:flutter/material.dart';
import 'package:flutter_sqlite/DatabaseClass/Details.dart';
import './DatabaseClass/DatabaseHelper.dart';
import 'package:toast/toast.dart';
import 'main.dart';

class SaveData extends StatefulWidget {
  String appTitle;
  int id;
  Details data;

  SaveData({String title ,  Details data}) {
    this.appTitle = title;
    this.data = data;
  }


  @override
  _SaveDataState createState() => _SaveDataState(title: appTitle , data: data);
}

class _SaveDataState extends State<SaveData> {
  String appTitle;
  Details allData;
  _SaveDataState({String title , Details data}) {
    this.appTitle = title;
    this.allData = data;
  }

  String buttonName;


  var spell = TextEditingController();
  var meaning = TextEditingController();
  var synonyms = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      if(appTitle == "Add Data")
      {
        buttonName = "Save";
      }
      else if(appTitle == "Edit Data")
      {
        buttonName = "Update";
        spell.text = allData.spell;
        meaning.text = allData.meaning;
        synonyms.text = allData.synonyms;
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: Container(
          child: Center(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 20 , left: 20 , right: 20),
                child: TextField(
                  controller: spell,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Spelling",
                    hintText: "eg.Support",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(10.0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                )),
            Padding(
                padding:
                    EdgeInsets.only(top: 15, right: 20, left: 20),
                child: TextField(
                  controller: meaning,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Meaning",
                    hintText: "eg.આધાર(you can use any language)",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(10.0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                )),
            Padding(
                padding:
                EdgeInsets.only(top: 15, right: 20, left: 20, bottom: 30),
                child: TextField(
                  controller: synonyms,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Synonyms",
                    hintText: "eg.hold up , carry",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(10.0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                )),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 10),
                    child: FlatButton(
                        child: Text(buttonName,style: TextStyle(color: Colors.white),),
                        splashColor: Colors.black,
                        color: Colors.blue,
                        onPressed: () {
                          if(buttonName == "Save")
                            {
                              setState(() {
                                if(spell.text.isNotEmpty && meaning.text.isNotEmpty)
                                {
                                  if(synonyms.text.isEmpty)
                                    {
                                      synonyms.text = "NA";
                                    }
                                  Details data = Details(spell.text , meaning.text , synonyms.text);
                                  insertDataClass(data, context);
                                }
                                Toast.show("You must fill spelling and meaning",context);
                              });
                            }
                          else if(buttonName == "Update")
                            {
                              setState(() {
                                Details data = Details(spell.text,meaning.text
                                ,synonyms.text);
                                updataData(data);
                              });
                            }

                        }),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 20),
                    child: FlatButton(
                      child: Text("Cancel"),
                      color: Colors.grey.shade300,
                      splashColor: Colors.blue,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }

  void updataData(Details data) async
  {
    int result = await DatabaseHelper.update_Data(data , allData.id);
    if (result != 0) {
      Toast.show("Successful",context);
      debugPrint("Successful");
      Navigator.pop(context);
    } else {
      Toast.show("UnSuccessful",context);
      debugPrint("UnSuccessful");
    }
  }

  void insertDataClass(Details data, BuildContext context) async {
    int result = await DatabaseHelper.insert_Data(data);
    if (result != 0) {
      Toast.show("Successful",context);
      debugPrint("Successful");
      Navigator.pop(context);
    } else {
      Toast.show("UnSuccessful",context);
      debugPrint("UnSuccessful");
    }
  }

}
