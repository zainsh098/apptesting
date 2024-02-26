

import 'package:apptesting/Scan%20Qr%20Code/home_screen.dart';
import 'package:apptesting/Scan%20Qr%20Code/views/qr_scanner_screen.dart';
import 'package:apptesting/view/qr_openscreen.dart';
import 'package:apptesting/view/scan_qr.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Ui',
      theme: ThemeData(


        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const QrScannerScreen()

    );
  }
}

