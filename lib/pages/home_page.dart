import 'package:easyscanner/pages/list_page.dart';
import 'package:easyscanner/pages/scanner_page.dart';
import 'package:easyscanner/utils/type.dart';
import 'package:flutter/material.dart';
 
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Widget child = ScannerPage(null, Type.TEXT);
  int i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Easy Scanner')),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.yellow,
        currentIndex: i,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.text_fields), title: Text('Text Recognize'), backgroundColor: Colors.blue),
          BottomNavigationBarItem(icon: Icon(Icons.code), title: Text('Barcode Scanner'), backgroundColor: Colors.blue),
          BottomNavigationBarItem(icon: Icon(Icons.label), title: Text('Label Recognize'), backgroundColor: Colors.blue),
          BottomNavigationBarItem(icon: Icon(Icons.list), title: Text('List'), backgroundColor: Colors.blue),
        ],
        onTap: (int index) {
          i = index;
          if(index == 0){
            child = ScannerPage(null, Type.TEXT);
          }else if(index == 1){
            child = ScannerPage(null, Type.BARCODE);
          }else if(index == 2){
            child = ScannerPage(null, Type.LABEL);
          }else if(index == 3){
            child = ListPage();
          }
          setState(() {});
        },
      ),

      body: child,
    );
  }
}