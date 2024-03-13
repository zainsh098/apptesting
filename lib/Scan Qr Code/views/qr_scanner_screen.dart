import 'package:apptesting/QR%20Provider/qr_provider.dart';
import 'package:apptesting/Scan%20Qr%20Code/db_history.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'qr_openscreen.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');



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
      body: Consumer<QrHomeProvider>(builder: (context, value, child) {
        return Stack(
          children: [
            if (value.isScanning)
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
              top: 100,
              right: 180,
              child: Card(
                color: value.isFlashOn ? Colors.grey : Colors.blue,
                child: IconButton(
                  onPressed: _toggleFlash,
                  icon: IconTheme(
                    data: IconThemeData(
                      size: 30,
                      color: value.isFlashOn ? Colors.yellow : Colors.white,
                    ),
                    child: Icon(
                      value.isFlashOn ? Icons.flash_on : Icons.flash_off,
                    ),
                  ),
                ),
              ),
            ),

            // Text display

          ],
        );
      },)
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    bool scanHandled = false; // Flag to track if scan event has been handled
final provider=Provider.of<QrHomeProvider>(context,listen: false);


    controller.scannedDataStream.listen((scanData) {
      // Ensure scan event is handled only once
      if (!scanHandled) {
        provider.setScannedData(scanData.code.toString());



          HistoryDatabase(provider.scannedData.toString()).hiveDatabase();      }



          provider.setisScanning(false) ;// Pause scanning when QR code is scanned


        _navigateToNextScreen();
        scanHandled = true; // Set flag to true after handling scan event

    });
  }

  Future<void> _navigateToNextScreen() async {

    final provider=Provider.of<QrHomeProvider>(context,listen: false);



    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QrOpenScreen(scannedData: provider.scannedData.toString()),
      ),
    );


   provider.setisScanning(true); // Resume scanning when returning to this screen

  }

  void _toggleFlash() {
    controller.toggleFlash(); // Toggle flash using QRViewController
    final provider=Provider.of<QrHomeProvider>(context,listen: false);


    provider.setFlash(!provider.isFlashOn);
      // Toggle flash state

  }
}
