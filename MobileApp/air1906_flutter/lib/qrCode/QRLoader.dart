import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../interface/IResourceLoader.dart';

class QRLoader implements IResourceLoader {
  @override
  BuildContext context;
  @override
  ResourceLoaderType type;
  @override
  Icon icon = Icon(Icons.code, color: Colors.white, );
  @override
  String title = "QR Code";
  @override
  bool availableIOS = true;

  @override
  Future<String> loadResource() async {
    
    return await FlutterBarcodeScanner.scanBarcode(
      "#00FF00",
      "Cancel",
      true,
      ScanMode.QR,
    );
  }
}
