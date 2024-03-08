import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CreateQRScreen extends StatefulWidget {
  const CreateQRScreen({Key? key}) : super(key: key);

  @override
  State<CreateQRScreen> createState() => _CreateQRScreenState();
}

class _CreateQRScreenState extends State<CreateQRScreen> {
  final GlobalKey _globalKey = GlobalKey();
  final TextEditingController _textController = TextEditingController();
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

  Future<void> _capturePng() async {
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Download successful'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.03),
                const Text(
                  'QR Generator',
                  style: TextStyle(
                    letterSpacing: 2,
                    wordSpacing: 2,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: height * 0.02),
                RepaintBoundary(
                  key: _globalKey,
                  child: showQRcode(),
                ),
                SizedBox(height: height * 0.03),
                Card(
                  elevation: 0,
                  shadowColor: Colors.white,
                  color: Colors.blue.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    style: const TextStyle(
                      fontSize: 20,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.text,
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Enter your content here',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      errorText: _isSubmitted ? _errorMessage : null,
                    ),
                    minLines: 3,
                    maxLines: 7,
                  ),
                ),
                SizedBox(height: height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      style: const ButtonStyle(


                          backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                      onPressed: () {
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
                      icon: const Icon(Icons.qr_code,color: Colors.white,),
                      label: const Text('Generate QR',style: TextStyle(color: Colors.white),),

                    ),
                    ElevatedButton.icon(
                      style: ButtonStyle(


                          backgroundColor: MaterialStatePropertyAll(_isShowQR?Colors.green:Colors.grey)),
                      onPressed: _isShowQR ? _capturePng : null,
                      icon: const Icon(Icons.download,color: Colors.white,),
                      label: const Text('Save QR',style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showQRcode() {
    return Card(
      elevation: 1,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.blue.withOpacity(0.5),
            width: 2,
          ),
          color: Colors.grey.shade50,
        ),
        alignment: Alignment.center,
        child: AnimatedCrossFade(
          firstChild: const Text('Create your QR code'),
          secondChild: QrImageView(
            eyeStyle: QrEyeStyle(  color: Colors.blue,

            eyeShape:QrEyeShape.square
            ),
            dataModuleStyle:  QrDataModuleStyle(

              color: Colors.pink,
              dataModuleShape: QrDataModuleShape.circle

            ),


            data: _qrData,


            version: QrVersions.auto,
            size: 200,
            errorStateBuilder: (context, error) => const Text(
              'Uh oh! Something went wrong...',
              textAlign: TextAlign.center,
            ),
          ),
          duration: const Duration(milliseconds: 300),
          crossFadeState: _isShowQR
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
