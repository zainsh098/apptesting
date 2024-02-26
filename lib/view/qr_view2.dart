import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrView2 extends StatefulWidget {
  const QrView2({super.key});

  @override
  State<QrView2> createState() => _QrView2State();
}

class _QrView2State extends State<QrView2> {
  final _globalKey = GlobalKey();
  final _textController = TextEditingController();
  String _qrData = '';
  bool _isShowQR = false;
  bool _isSubmitted = false;

  String? get _errorMessage {
    String text = _textController.text.trim();
    if (text.isEmpty) {
      return 'Content is empty';
    } else {
      return null;
    }
  }

  Future _capturePng() async {
    var devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    RenderRepaintBoundary? boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    ui.Image image = await boundary!.toImage(pixelRatio: devicePixelRatio);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    // Request permissions if not already granted
    if (!(await Permission.storage.status.isGranted)) {
      await Permission.storage.request();
    }

    await ImageGallerySaver.saveImage(
      Uint8List.fromList(pngBytes),
      name: 'QR code',
      quality: 100,
    );

    Flushbar(
      message: 'Download successfully',
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(milliseconds: 1500),
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      borderRadius: BorderRadius.circular(10),
      icon: const Icon(
        Icons.download_done,
        color: Colors.green,
      ),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RepaintBoundary(
                  key: _globalKey,
                  child: showQRcode(),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Enter your content',
                    style: titleStyle,
                  ),
                ),
                Card(
                  elevation: 3,
                  shape: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _textController,
                    decoration: InputDecoration(
                      enabled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      filled: true,
                      fillColor: Colors.blueGrey.shade50,
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      errorText: _isSubmitted ? _errorMessage : null,
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                    minLines: 3,
                    maxLines: 5,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                buildButton(
                  iconData: Icons.sync,
                  text: 'Generate QR',
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    setState(() {
                      _isSubmitted = true;
                      _qrData = _textController.text.trim();
                      if (_qrData.isEmpty) {
                        _isShowQR = false;
                      } else {
                        _isShowQR = true;
                      }
                    });
                  },
                ),
                const SizedBox(
                  height: 6,
                ),
                buildButton(
                    iconData: Icons.download,
                    text: 'Download QR',
                    onPressed: _isShowQR ? _capturePng : null),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton({
    required IconData iconData,
    required String text,
    required onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        iconData,
        color: blackColor,
      ),
      label: Text(
        text,
        style: titleStyle,
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
    );
  }

  Widget showQRcode() {
    return Container(
      width: 280,
      height: 250,
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff052be5),
            Color(0xffc511c0),
          ],
        ),
      ),
      alignment: Alignment.center,
      child: Container(
        height: 220,
        width: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: whiteColor,
          // gradient:
        ),
        alignment: Alignment.center,
        child: AnimatedCrossFade(
          firstChild: const Text('Create your QR code'),
          secondChild: QrImageView(
            data: _qrData,
            version: QrVersions.auto,
            errorStateBuilder: (ctx, error) => const Text(
              "Uh oh! Something went wrong...",
              textAlign: TextAlign.center,
            ),
          ),
          duration: const Duration(milliseconds: 300),
          crossFadeState:
              _isShowQR ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }
}

const yellowColor = Color(0xffFFBD35);
const blackColor = Color(0xff0C0E0D);
const whiteColor = Color(0xffFDFDFD);

const titleStyle = TextStyle(
  fontSize: 18,
  color: blackColor,
  fontWeight: FontWeight.w500,
);
