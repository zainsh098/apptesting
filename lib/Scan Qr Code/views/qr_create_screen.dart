import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:apptesting/QR%20Provider/qr_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CreateQRScreen extends StatefulWidget {
  const CreateQRScreen({Key? key}) : super(key: key);

  @override
  State<CreateQRScreen> createState() => _CreateQRScreenState();
}

class _CreateQRScreenState extends State<CreateQRScreen> {
  final GlobalKey _globalKey = GlobalKey();
  final TextEditingController _textController = TextEditingController();


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
                  child: Consumer<QrHomeProvider>(builder: (context, value, child) {
                    return TextFormField(
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
                        errorText: value.isSubmitted ? _errorMessage : null,
                      ),
                      minLines: 3,
                      maxLines: 7,
                    );
                  },)
                ),
                SizedBox(height: height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Consumer<QrHomeProvider>(builder: (context, value, child) {
                      return ElevatedButton.icon(
                        style: const ButtonStyle(


                            backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                        onPressed: () {

                          value.submit(true);

                          value.showQrData(_textController.text.trim());
                          if (value.qrData.isEmpty) {
                            value.showQr(false);
                          } else {
                            value.showQr(true);
                          }
                          value.submit(true);



                        },
                        icon: const Icon(Icons.qr_code,color: Colors.white,),
                        label: const Text('Generate QR',style: TextStyle(color: Colors.white),),

                      );
                    },),
                    Consumer<QrHomeProvider>(builder: (context, value, child) {


                      return ElevatedButton.icon(
                        style: ButtonStyle(


                            backgroundColor: MaterialStatePropertyAll(value.isShowQR?Colors.green:Colors.grey)),
                        onPressed: value.isShowQR ? _capturePng : null,
                        icon: const Icon(Icons.download,color: Colors.white,),
                        label: const Text('Save QR',style: TextStyle(color: Colors.white)),
                      );
                    },)
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
        child: Consumer<QrHomeProvider>(builder: (context, value, child) {
          return AnimatedCrossFade(
            firstChild: const Text('Create your QR code'),
            secondChild: QrImageView(
              eyeStyle: const QrEyeStyle(  color: Colors.blue,

                  eyeShape:QrEyeShape.square
              ),
              dataModuleStyle:  const QrDataModuleStyle(

                  color: Colors.pink,
                  dataModuleShape: QrDataModuleShape.circle

              ),


              data:value.qrData,


              version: QrVersions.auto,
              size: 200,
              errorStateBuilder: (context, error) => const Text(
                'Uh oh! Something went wrong...',
                textAlign: TextAlign.center,
              ),
            ),
            duration: const Duration(milliseconds: 300),
            crossFadeState: value.isShowQR
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          );

        },)
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
