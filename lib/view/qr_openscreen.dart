
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';

class QrOpenScreen extends StatelessWidget {
  final String scannedData;
  const QrOpenScreen({super.key, required this.scannedData});



  Future<void> shareText(String test)
  async {



    Share.share(test,subject: 'Eke');


  }





  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height * 0.03,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Icon(
                    Icons.arrow_back_sharp,
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: width * 0.28,
                ),
                Text('Scanned',
                    style: GoogleFonts.poppins(
                        wordSpacing: 2,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600,
                        fontSize: height * 0.022,
                        color: Colors.black)),
              ],
            ),
            SizedBox(height:  height * 0.05,),
            Center(child: Image.asset('assets/correct.png',fit:BoxFit.cover,height: height * 0.13,)),
            SizedBox(height: height * 0.02,),
            Center(
              child: Text('Scanning successful',
                  style: GoogleFonts.poppins(
                      wordSpacing: 2,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w500,
                      fontSize: height * 0.022,
                      color: Colors.black)),
            ),
            SizedBox(height:  height * 0.05,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text('Scanned QR Code',
                  style: GoogleFonts.poppins(
                      wordSpacing: 2,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w700,
                      fontSize: height * 0.021,
                      color: Colors.black)),
            ),
            SizedBox(height:  height * 0.03,),

            Stack(
              children: [

                Center(
                  child: Card.filled(
                    elevation: 5,
                    color: Colors.blue.shade50.withOpacity(0.9),

                    shadowColor: Colors.grey,

                    margin: const EdgeInsets.only(left: 15,right: 15),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SizedBox(
                      height:  height* 0.2,
                      width:width * 0.96 ,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(scannedData, textAlign: TextAlign.center, style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400
                          )),

                        ],
                      ),
                    ),

                  ),
                ),

                Positioned(
                    top: 6,
                    right:20,
                    child:IconButton(onPressed: () {

                    }, icon: const Icon(Icons.copy,color: Colors.black,size: 32,)))



              ],


            ),

            SizedBox(height:  height* 0.07,),
            Center(
              child: ElevatedButton(

                  style: ButtonStyle(

                    minimumSize: MaterialStatePropertyAll(Size(width * 0.6 , height * 0.07)),

                    backgroundColor: const MaterialStatePropertyAll(Colors.blue),
                    overlayColor: const MaterialStatePropertyAll(Colors.green),
                    elevation: const MaterialStatePropertyAll(3),

                  ),
                  onPressed: () async {
                    if (Platform.isAndroid) {
                      await shareText(scannedData);
                    } else {
                      // Handle sharing on other platforms or provide alternative functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Sharing is not supported on this platform.'),
                        ),
                      );
                    }
                  },
                   child: const Text('Share ',style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,fontWeight: FontWeight.w500


              ),)),
            ),




          ],
        ),
      ),
    );
  }
}
