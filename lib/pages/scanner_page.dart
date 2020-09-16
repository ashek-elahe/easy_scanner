import 'package:easyscanner/widgets/image_pick.dart';
import 'package:easyscanner/utils/type.dart';
import 'package:easyscanner/widgets/image_preview.dart';
import 'package:easyscanner/widgets/result_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:mlkit/mlkit.dart';

class ScannerPage extends StatefulWidget {

  final Type _scannerType;
  File _file;
  ScannerPage(this._file, this._scannerType);

  @override
  State<StatefulWidget> createState() {
    return _ScannerPageState();
  }
}

class _ScannerPageState extends State<ScannerPage> {

  FirebaseVisionTextDetector textDetector = FirebaseVisionTextDetector.instance;
  FirebaseVisionBarcodeDetector barcodeDetector = FirebaseVisionBarcodeDetector.instance;
  FirebaseVisionLabelDetector labelDetector = FirebaseVisionLabelDetector.instance;
  List<VisionText> _currentTextLabels = <VisionText>[];
  List<VisionBarcode> _currentBarcodeLabels = <VisionBarcode>[];
  List<VisionLabel> _currentLabelLabels = <VisionLabel>[];

  Stream sub;
  StreamSubscription<dynamic> subscription;

  @override
  void initState() {
    super.initState();
    sub = new Stream.empty();
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if(widget._file == null){
      _currentBarcodeLabels = <VisionBarcode>[];
      _currentLabelLabels = <VisionLabel>[];
      _currentTextLabels = <VisionText>[];
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: <Widget>[

        Expanded(
          flex: 2, 
          child: ImagePreview(widget._file, widget._scannerType, _getImageSize, _currentTextLabels, _currentBarcodeLabels),
        ),
        SizedBox(height: 10),

        Expanded(flex: 1, child: Container(
          color: Colors.grey[300],
          padding: EdgeInsets.all(5),
          child: widget._scannerType == Type.TEXT ? ResultText(context, _currentTextLabels, widget._scannerType)
          : widget._scannerType == Type.BARCODE ? ResultText(context, _currentBarcodeLabels, widget._scannerType)
          : ResultText(context, _currentLabelLabels, widget._scannerType),
        )),
        SizedBox(height: 5),

        ImagePick(onPressed: onPressed),
      ]),
    );
  }

  onPressed(String type) async {
    try {
      ImageSource source;
      if(type == 'camera'){
        source = ImageSource.camera;
      }else{
        source = ImageSource.gallery;
      }
      PickedFile pickedFile = await ImagePicker().getImage(source: source);
      widget._file = File(pickedFile.path);
      if (widget._file == null) {
        throw Exception('File is not available');
      }

      subscription = sub.listen((_) => _getImageSize)..onDone(analyzeLabels);

    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void analyzeLabels() async {
    try {
      var currentLabels;
      if (widget._scannerType == Type.TEXT) {
        currentLabels = await textDetector.detectFromPath(widget._file.path);
        if (this.mounted) {
          _currentTextLabels = currentLabels;
        }
      } else if (widget._scannerType == Type.BARCODE) {
        currentLabels = await barcodeDetector.detectFromPath(widget._file.path);
        if (this.mounted) {
          _currentBarcodeLabels = currentLabels;
        }
      } else if (widget._scannerType == Type.LABEL) {
        currentLabels = await labelDetector.detectFromPath(widget._file.path);
        if (this.mounted) {
          _currentLabelLabels = currentLabels;
        }
      }
      setState(() {});
    } catch (e) {
      print("MyEx: " + e.toString());
    }
  }

  Future<Size> _getImageSize(Image image) {
    Completer<Size> completer = Completer<Size>();
    image.image.resolve(ImageConfiguration()).addListener(ImageStreamListener(
      (ImageInfo info, bool _) => completer.complete(Size(info.image.width.toDouble(), info.image.height.toDouble()))
    ));
    return completer.future;
  }
}