import 'package:flutter/foundation.dart';

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
}
