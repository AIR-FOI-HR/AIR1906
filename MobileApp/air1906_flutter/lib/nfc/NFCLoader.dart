import 'package:easy_dialog/easy_dialog.dart';
import 'package:nfc_manager/nfc_manager.dart';
import '../interface/IResourceLoader.dart';
import 'package:flutter/material.dart';

// enum NFCType {
//   borrowResource,
//   returnResource,
// }

class NFCLoader implements IResourceLoader {
  BuildContext context;
  ResourceLoaderType type;
  String title = "NFC";
  NfcTag tag;
  String id;
  Icon icon = Icon(Icons.nfc);

  @override
  Future<String> loadResource() async {
    String nfcResult;
    showNFCDialog();
    nfcResult = await listenNFC().then((x) {
      return x;
    });
    return nfcResult;
  }

  Future<String> listenNFC() async {
    String res;

    try {
      await NfcManager.instance.startTagSession(
        alertMessageIOS: '...',
        pollingOptions: {
          TagPollingOption.iso14443,
          TagPollingOption.iso15693,
          TagPollingOption.iso18092
        },
        onDiscovered: (NfcTag tag) async {
          Ndef ndef = Ndef.fromTag(tag);
          if (ndef == null) {
            print("tag is not ndef");
            return null;
          }
          NdefRecord data = ndef.cachedMessage.records.first;
          String resourceIdFromNFC = String.fromCharCodes(data.payload);
          print("dohvacno $resourceIdFromNFC");
          res = resourceIdFromNFC;

          Navigator.of(context).pop();
        },
      );
    } catch (e) {}
    return await Future.delayed(Duration(seconds: 3)).then((x) {
      return res;
    });
  }

  void showNFCDialog() {
    EasyDialog(
    
        height: MediaQuery.of(context).size.height / 2,
        cornerRadius: 15,
        cardColor: Colors.white,
        contentList: [
          Text(
            "Skeniraj resurs",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Image(
              image: AssetImage("assets/images/NFCImage.png"),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text("Prislonite uređaj na NFC oznaku"),
        ]).show(context);
  }
}
