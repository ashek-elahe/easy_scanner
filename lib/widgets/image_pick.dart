import 'package:flutter/material.dart';

class ImagePick extends StatelessWidget {
  
  final Function onPressed;
  ImagePick({@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: RaisedButton(
              color: Colors.green,
              textColor: Colors.white,
              splashColor: Colors.blueGrey,
              onPressed: (){
                onPressed('camera');
              },
              child: Text('Camera')),
        )),
        Expanded(child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: RaisedButton(
              color: Colors.green,
              textColor: Colors.white,
              splashColor: Colors.blueGrey,
              onPressed: () {
                onPressed('gallery');
              },
              child: Text('Gallery')),
        ))
      ],
    );
  } 
}