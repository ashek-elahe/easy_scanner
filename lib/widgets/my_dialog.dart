import 'package:easyscanner/model/code.dart';
import 'package:flutter/material.dart';
 
class MyDialog extends StatelessWidget {

  final int _type;
  final String _title;
  final String _result;
  final bool isView;
  final Function onSavePressed;
  MyDialog(this._type, this._title, this._result, this.isView, this.onSavePressed);

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = _title;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[

          Container(
            height: 100,
            width: 100,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black),
            child: Icon(_type == 0 ? Icons.text_fields : _type == 1 ? Icons.code : Icons.label, color: Colors.white, size: 50),
          ),
          SizedBox(height: 10),

          isView ? Text(_title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)) 
          : TextField(controller: _controller, autofocus: true, decoration: InputDecoration(labelText: 'Title', hintText: 'Enter title')),
          SizedBox(height: 10),

          Container(color: Colors.grey[300], height: 100, width: 250, child: SingleChildScrollView(child: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(_result),
          ))),
          SizedBox(height: 10),

          isView ? Container() 
          : Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            RaisedButton(
              color: Colors.red, 
              child: Text('Cancel', style: TextStyle(color: Colors.white)), 
              onPressed: () => Navigator.pop(context)
            ),
            SizedBox(width: 10),
            RaisedButton(
              color: Colors.green,
              child: Text('Save', style: TextStyle(color: Colors.white)),
              onPressed: (){
                if(_controller.text.isNotEmpty){
                  onSavePressed(Code(_type, _controller.text, _result));
                  Navigator.pop(context);
                }
              },
            ),
          ]),
        ]),
      ),
    );
  }
}