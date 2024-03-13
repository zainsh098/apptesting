import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class QrHomeProvider extends ChangeNotifier {
  int _myIndex = 0;

  int get myIndex => _myIndex;

  void setIndex(int index) {
    _myIndex = index;
    notifyListeners();
  }

  bool _isShowQr = false;
  bool get isShowQR => _isShowQr;

  String _qrData = '';
  String get qrData => _qrData;

  bool _isSubmitted = false;
  bool get isSubmitted => _isSubmitted;


  void  showQr(bool showQR) {
    _isShowQr = showQR;

    notifyListeners();
  }

  void submit(bool isSubmitData) {
    _isSubmitted = isSubmitData;

    notifyListeners();
  }

  void showQrData(String qrDataShow) {
    _qrData = qrDataShow;

    notifyListeners();
  }


  Future<Box<dynamic>> openBox() async {
    return await Hive.openBox('DB-QR');
  }

  void deleteItemAt(Box<dynamic> box, int index) {
    box.deleteAt(index);
    notifyListeners();
  }

  List<String> getQrData(Box<dynamic> box) {
    return box.values.map((item) => item.toString()).toList();
  }




  String? _scannedData;


  String? get scannedData=>_scannedData;
  void setScannedData(String setScanData)
  {
    _scannedData=setScanData;
    notifyListeners();

  }

  bool _isScanning = true;
  bool get isScanning=>_isScanning;
  void setisScanning(bool setIsScan)
  {

    _isScanning=setIsScan;
    notifyListeners();

  }


  bool _isFlashOn = false;
  bool get isFlashOn=>_isFlashOn;
  void setFlash(bool setIsFlash)
  {

    _isFlashOn=setIsFlash;
    notifyListeners();

  }







}


