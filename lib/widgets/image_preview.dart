import 'dart:io';
import 'package:easyscanner/decorations/barcode_decoration.dart';
import 'package:easyscanner/decorations/text_decoration.dart';
import 'package:easyscanner/utils/type.dart';
import 'package:flutter/material.dart';
import 'package:mlkit/mlkit.dart';
 
class ImagePreview extends StatelessWidget {

  final File _file;
  final Type _scannerType;
  final Function _getImageSize;
  final List<VisionText> _currentTextLabels;
  final List<VisionBarcode> _currentBarcodeLabels;
  ImagePreview(this._file, this._scannerType, this._getImageSize, this._currentTextLabels, this._currentBarcodeLabels);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.black),
      child: Center(
        child: _file == null
        ? Text('No Image', style: TextStyle(color: Colors.white))
        : FutureBuilder<Size>(
          future: _getImageSize(Image.file(_file, fit: BoxFit.fitWidth)),
          builder: (BuildContext context, AsyncSnapshot<Size> snapshot) {
            if (snapshot.hasData) {
              return Container(
                foregroundDecoration: (_scannerType == Type.TEXT) ? TextDetectDecoration( _currentTextLabels, snapshot.data)
                  : BarcodeDetectDecoration(_currentBarcodeLabels, snapshot.data),
                child: Image.file(_file, fit: BoxFit.fitWidth)
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}