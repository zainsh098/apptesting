import 'package:apptesting/QR%20Provider/qr_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';

import 'package:another_flushbar/flushbar.dart';

class QrHistory extends StatelessWidget {
  const QrHistory({Key? key}) : super(key: key);

  @override

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.blue,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Scanning History',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: height * 0.04,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: height * 0.02),
                ],
              ),
            ),
            SizedBox(height: height * 0.02),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                margin: EdgeInsets.symmetric(horizontal: width * 0.04),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Consumer<QrHomeProvider>(
                  builder: (context, provider, child) {
                    return FutureBuilder(
                      future: provider.openBox(),
                      builder: (context, AsyncSnapshot<Box<dynamic>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (!snapshot.hasData || snapshot.data == null) {
                            return const Center(
                              child: Text(
                                'No data available.',
                                style:
                                TextStyle(fontSize: 18, color: Colors.black),
                              ),
                            );
                          }

                          var box = snapshot.data!;
                          List<String> qrData = provider.getQrData(box);

                          return ListView.builder(
                            padding: const EdgeInsets.only(bottom: 5),
                            itemCount: qrData.length,
                            itemBuilder: (BuildContext context, int index) {
                              final String qrText = qrData[qrData.length - 1 - index];
                              return Dismissible(
                                key: Key(qrText),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                onDismissed: (direction) {
                                  provider.deleteItemAt(box, qrData.length - 1 - index);
                                  Flushbar(
                                    flushbarPosition: FlushbarPosition.BOTTOM,
                                    backgroundColor: Colors.green,
                                    message: 'Deleted',
                                    duration: const Duration(seconds: 2),
                                  ).show(context);
                                },
                                child: GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(text: qrText));
                                    Flushbar(
                                      message: 'Text copied: $qrText',
                                      duration: const Duration(seconds: 2),
                                    ).show(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      elevation: 0,
                                      color: Colors.blue.shade50,
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.qr_code_2,
                                          color: Colors.blue,
                                        ),
                                        trailing: const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.blue,
                                        ),
                                        title: Text(
                                          qrText,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blue,
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
