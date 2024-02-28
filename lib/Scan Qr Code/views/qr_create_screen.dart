

import 'dart:ui' as ui;

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';

import 'package:flutter/services.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../build_button.dart';

class CreateQRScreen extends StatefulWidget {
  const CreateQRScreen({super.key});

  @override
  State<CreateQRScreen> createState() => _CreateQRScreenState();
}

class _CreateQRScreenState extends State<CreateQRScreen> {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


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
    final height=MediaQuery.sizeOf(context).height *1;
    final width=MediaQuery.sizeOf(context).width *1;
    return Scaffold(
      backgroundColor: Colors.white,
     
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height:  height * 0.03,),

                const Text('QR Generator ',style: TextStyle(letterSpacing: 2,wordSpacing:2,fontSize: 22,fontWeight: ui.FontWeight.w400,),),


                SizedBox(height: height * 0.02,),
                RepaintBoundary(

                  key: _globalKey,
                  child: showQRcode(),
                ),
                // const Align(
                //   alignment: Alignment.centerLeft,
                //   child: Text(
                //     'Enter your content',
                //     style: titleStyle,
                //   ),
                // ),
                SizedBox(height: height * 0.03,),
                Column(
                  children: [
                    Card. filled(
                      elevation: 2,
                      shadowColor: Colors.blue,
                      color: Colors.blue.shade50,




                      shape: RoundedRectangleBorder(

                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(

                        style:  const TextStyle(
                          fontSize: 20,
                         letterSpacing: 1,
                          fontWeight: FontWeight.w400,






                        ),
                        textAlign: TextAlign.center,

                      cursorColor: Colors.black,

                        keyboardType: TextInputType.text,
                        controller: _textController,
                        decoration: InputDecoration(

                          hintTextDirection: TextDirection.ltr,



                          hintText: 'Enter your content here',

                          hintStyle:   const TextStyle(
                            height: 3,
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,

                        ),


                               // Use a lighter color for the field background
                          border: OutlineInputBorder(
                              // Remove borderSide from here
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none
                              // Remove this line to remove side border
                              ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none),
                          errorText: _isSubmitted ? _errorMessage : null,
                        ),

                        minLines: 3,


                        maxLines: 7,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [

                        BuildButton(
                          imageAsset:
                          'assets/qr-code.png',

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
                        BuildButton(
                            imageAsset: 'assets/arrow.png',


                            onPressed: _isShowQR ? _capturePng : null),
                      ],
                    )
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
    final height=MediaQuery.sizeOf(context).height *1;
    final width=MediaQuery.sizeOf(context).width *1;
    return ClipRRect(

      borderRadius: BorderRadius.circular(9),
      child: Card.filled(
        elevation: 2,

       color: Colors.amber,

       shadowColor: Colors.blue,

        child: Container(
            width: width * 0.6,
            height:height* 0.3,

            decoration: BoxDecoration(

              borderRadius: BorderRadius.circular(10),
              border: Border.fromBorderSide(BorderSide(
                color: Colors.white.withOpacity(0.09),
                style: BorderStyle.solid,
                 width: 2,


              )),
              color: Colors.grey.shade50,
              // gradient:
            ),
            alignment: Alignment.center,
            child: AnimatedCrossFade(


              firstChild:  const Text('Create your QR code'),
              secondChild: QrImageView(

        dataModuleStyle: const QrDataModuleStyle(
          color: Colors.pink,
          dataModuleShape: QrDataModuleShape.circle

        ),







                eyeStyle: const QrEyeStyle(



                  color: Colors.blue,




                  eyeShape: QrEyeShape.square,



                ),
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

