import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../view/qr_openscreen.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({Key? key}) : super(key: key);

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String? scannedData;
  bool isScanning = true;
  bool isFlashOn = false; // Flag to track flash state

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final halfHeight = height * 1;
    return Scaffold(
      body: Stack(
        children: [
          if (isScanning)
            QRView(
              key: qrKey,
              cameraFacing: CameraFacing.back,
              overlay: QrScannerOverlayShape(
                overlayColor: Colors.white.withOpacity(0.7),
                borderRadius: 20,
                borderWidth: 20,
                borderLength: 35,
                borderColor: Colors.blue,
                cutOutSize: halfHeight * 0.38,
              ),
              onQRViewCreated: _onQRViewCreated,

            ), // Conditionally build QRView based on scanning state
          // Flash button
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: Icon(
                isFlashOn ? Icons.flash_on : Icons.flash_off,
                color: isFlashOn ? Colors.yellow : Colors.white,
              ),
              onPressed: _toggleFlash,
            ),
          ),
          // Text display

        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    bool scanHandled = false; // Flag to track if scan event has been handled

    controller.scannedDataStream.listen((scanData) {
      // Ensure scan event is handled only once
      if (!scanHandled) {
        setState(() {
          scannedData = scanData.code;
        });

        setState(() {
          isScanning = false; // Pause scanning when QR code is scanned
        });

        _navigateToNextScreen();
        scanHandled = true; // Set flag to true after handling scan event
      }
    });
  }

  Future<void> _navigateToNextScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QrOpenScreen(scannedData: scannedData.toString()),
      ),
    );

    setState(() {
      isScanning = true; // Resume scanning when returning to this screen
    });
  }

  void _toggleFlash() {
    controller.toggleFlash(); // Toggle flash using QRViewController
    setState(() {
      isFlashOn = !isFlashOn; // Toggle flash state
    });
  }
}
