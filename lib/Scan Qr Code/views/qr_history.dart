import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class QrHistory extends StatefulWidget {
  const QrHistory({Key? key}) : super(key: key);

  @override
  State<QrHistory> createState() => _QrHistoryState();
}

class _QrHistoryState extends State<QrHistory> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    // Set system overlay style
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.blue, // Set status bar color to match app's blue color
      statusBarIconBrightness: Brightness.light, // Set status bar text color to light
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
                color: Colors.blue, // Updated to Material Design 3 blue color
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
                      color: Colors.white, // Updated text color to white
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
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),

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
                child: FutureBuilder(
                  future: Hive.openBox('DB-QR'),
                  builder: (context, AsyncSnapshot<Box<dynamic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(
                          child: Text(
                            'No data available.',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        );
                      }

                      var box = Hive.box('DB-QR');
                      List<String> qrData =
                      box.values.map((item) => item.toString()).toList().reversed.toList();



                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 5),
                        itemCount: qrData.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String qrText = qrData[index];
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
                              box.deleteAt(index);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 0,
                                color: Colors.blue.shade50, // Updated to Material Design 3 blue shade
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.qr_code_2,
                                    color: Colors.blue, // Updated to Material Design 3 blue color
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.blue, // Updated to Material Design 3 blue color
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
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue, // Updated to Material Design 3 blue color
                          ),
                        ),
                      );
                    }
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
