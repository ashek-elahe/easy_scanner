import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:easyscanner/model/code.dart';
import 'package:easyscanner/widgets/my_dialog.dart';
import '../utils/database_helper.dart';
 
class ListPage extends StatefulWidget {

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Code> codeList = List<Code>();
  List<Code> filteredList = List<Code>();
  int id;
  String text = '';
  bool hasData = true;

  @override
  void initState() {
    super.initState();

    updateListView();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(3),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search by title...',
              border: OutlineInputBorder(borderSide: BorderSide(width: 5, color: Colors.orange, style: BorderStyle.solid)),
            ),
            onChanged: _filterList,
          ),
        ),
        Expanded(
          child: hasData ? Container(
            padding: EdgeInsets.all(3),
            color: Colors.grey[300],

            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (BuildContext context, int position){
                Code code = filteredList[position];
                return Padding(
                  padding: const EdgeInsets.all(2),

                  child: GestureDetector(
                    child: Card(
                      color: Colors.white,
                      elevation: 3.0,
                      child: Row(children: <Widget>[

                        Container(
                          height: 70,
                          width: 70,
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.black),
                          child: Icon(code.type == 0 ? Icons.text_fields : code.type == 1 ? Icons.code : Icons.label, color: Colors.white, size: 40),
                        ),

                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                            Text(code.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), maxLines: 1),
                            SizedBox(height: 5),
                            Text(code.result, maxLines: 1),
                          ]),
                        ),

                        Container(width: 1,height: 90, color: Colors.grey[400], padding: EdgeInsets.all(5)),

                        Column(children: <Widget>[
                          IconButton(icon: Icon(Icons.edit),
                            onPressed: (){
                              id = code.id;
                              showDialog(context: context, builder: (context) => MyDialog(code.type, code.title, code.result, false, _update));
                            },
                          ),
                          IconButton(icon: Icon(Icons.delete),
                            onPressed: (){
                              _delete(code);
                            },
                          ),
                        ]),

                      ]),
                    ),
                    onTap: () {
                      showDialog(context: context, builder: (context) => MyDialog(code.type, code.title, code.result, true, (){}));
                    },
                  ),
                );
              }
            ),
          ) : Center(child: Text('No saved data', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        ),
      ],
    );
  }

  void _filterList(String newString) {
    text = newString;
    filteredList = List<Code>();
    if(newString != null && newString.length > 0){
      for (Code code in codeList) {
        if(code.title.toLowerCase().contains(newString.trim().toLowerCase())){
          filteredList.add(code);
        }
      }
    }else {
      filteredList = codeList;
    }
    hasData = filteredList.length > 0;
    setState(() {});
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Code>> codeListFuture = databaseHelper.getCodeList();

      codeListFuture.then((codeList){
        this.codeList = codeList;
        _filterList(text);
      });
    });
  }

  void _update(Code code) async {
    int result = await databaseHelper.updateCode(Code.withId(id, code.type, code.title, code.result));
    if(result != 0){ // Success
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Data updated successfully')));
      updateListView();
    }else{ // Failed
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Problem updating data')));
    }
  }

  void _delete(Code code) async {
    int result = await databaseHelper.deleteCode(code.id);
    if(result != 0){ // Success
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Data deleted successfully')));
      updateListView();
    }else{ // Failed
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Problem deleting data')));
    }
  }
}