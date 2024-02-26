import 'package:apptesting/view/qr_openscreen.dart';
import 'package:flutter/material.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScannerScreen extends StatefulWidget {


  const QrScannerScreen({Key? key }) : super(key: key);

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String? scannedData;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // QR Scanner overlay
          _buildQrView(context),
          // Text display
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text(
                scannedData ?? "Scan a QR code",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final halfHeight = height * 1;
    return QRView(
      cameraFacing: CameraFacing.back,
      overlay: QrScannerOverlayShape(
        overlayColor: Colors.white.withOpacity(0.7),
        borderRadius: 20,
        borderWidth: 20,
        borderLength: 35,
        borderColor: Colors.blue,
        cutOutSize: halfHeight * 0.38,
      ),
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        scannedData = scanData.code;
      });

      // Navigate to the next screen when QR code is scanned
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QrOpenScreen(scannedData: scannedData.toString()),
        ),
      ).then((value) => (value) {
        controller.pauseCamera();
      });
    });
  }

}
