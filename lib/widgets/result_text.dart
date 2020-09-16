import 'package:easyscanner/model/code.dart';
import 'package:easyscanner/utils/database_helper.dart';
import 'package:easyscanner/utils/type.dart';
import 'package:easyscanner/widgets/my_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mlkit/mlkit.dart';

class ResultText<T> extends StatelessWidget {

  final BuildContext context;
  final List<T> result;
  final Type _scannerType;
  ResultText(this.context, this.result, this._scannerType);

  final StringBuffer stringBuffer = StringBuffer();
  final DatabaseHelper helper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    if (result.length == 0) {
      return Center(child: Text('Nothing detected', style: Theme.of(context).textTheme.subtitle1));
    }else {
      int _type;
      if(_scannerType == Type.TEXT){
        _type = 0;
      }else if(_scannerType == Type.BARCODE){
        _type = 1;
      }else {
        _type = 2;
      }

      return Stack(children: <Widget>[
        getResult(),
        Positioned(
          bottom: 5,
          right: 5,
          child: Column(children: <Widget>[
            FloatingActionButton(child: Icon(Icons.content_copy), onPressed: _copyContent),
            SizedBox(height: 5),
            FloatingActionButton(child: Icon(Icons.save), onPressed: () => showDialog(
              context: context, 
              builder: (context) => MyDialog(_type, '', stringBuffer.toString().trim(), false, _save),
            )),
          ]),
        ),
      ]);
    }
  }

  void _copyContent() {
    ClipboardData clipboardData = ClipboardData(text: stringBuffer.toString().trim());
    Clipboard.setData(clipboardData).then((value) => 
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Copied to clipboard')))
    );
  }

  Widget getResult(){
    return ListView.builder(
      padding: EdgeInsets.all(1.0),
      itemCount: result.length,
      itemBuilder: (context, i) {
        String text;
        stringBuffer.clear();
        final barcode = result[i];
        switch (_scannerType) {
          case Type.BARCODE:
            VisionBarcode res = barcode as VisionBarcode;
            text = res.rawValue;
            stringBuffer.writeln(text);
            break;
          case Type.LABEL:
            VisionLabel res = barcode as VisionLabel;
            text = '${i+1}: ${res.label}';
            stringBuffer.writeln(text);
            break;
          case Type.TEXT:
            VisionText res = barcode as VisionText;
            text = res.text;
            stringBuffer.writeln(text);
            break;
        }
        return Padding(
          padding: const EdgeInsets.all(3),
          child: SelectableText(text, style: TextStyle(fontSize: 15)),
        );
      },
    );
  }

  void _save(Code code) async {
    int result = await helper.insertCode(code);
    if(result != 0){ // Success
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Data saved successfully')));
    }else{ // Failed
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Problem saving data')));
    }
  }
}