import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class QrHistory extends StatefulWidget {
  const QrHistory({Key? key}) : super(key: key);

  @override
  State<QrHistory> createState() => _QrHistoryState();
}

class _QrHistoryState extends State<QrHistory> {
  int selectedIndex = 0;

  List<String> staticHistoryData = [
    'History Item 1',
    'History Item 2',
    'History Item 3',
    'History Item 4',
    'History Item 5',
    'History Item 6',
  ];
  List<String> staticHistoryData1 = [
    'History Item 1',
    'History Item 2',
    'History Item 3',
    'History Item 4',
    'History Item 5',
    'History Item 6',
    'History Item 7',
    'History Item 8',
    'History Item 9',
    'History Item 10',
    'History Item 11',
    'History Item 12',
  ];

  void setSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(


           backgroundColor: Colors.blue,
      title: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: Text('Scanning History',
            style: GoogleFonts.poppins(
                wordSpacing: 2,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
                fontSize: height * 0.035,
                color: Colors.white)),
      ),




            snap: true,
            floating: true,




            centerTitle: true,
            automaticallyImplyLeading: false,




            expandedHeight: height * 0.1,



          ),

          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height:  height * 0.15,),

                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(140, 45)),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                      if (selectedIndex == 0) {
                        return Colors.blue;
                      }
                      return Colors.grey;
                    }),
                  ),
                  onPressed: () {
                    setSelectedIndex(0);
                  },
                  child: Text(
                    'History',
                    style: GoogleFonts.poppins(
                        wordSpacing: 2,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
                SizedBox(width:width * 0.08),
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(140, 45)),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                      if (selectedIndex == 1) {
                        return Colors.blue;
                      }
                      return Colors.grey;
                    }),
                  ),
                  onPressed: () {
                    setSelectedIndex(1);
                  },
                  child: Text(
                    'All',
                    style: GoogleFonts.poppins(
                        wordSpacing: 2,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
              ],
            ),

          ),


          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(left: 10,right: 10),
                  child: Card.filled(



                    shadowColor: Colors.amber,
                    elevation: 5,

                    color: selectedIndex == 0 ? Colors.blueGrey : Colors.blue,
                    child: ListTile(

                      leading: const Icon(
                        Icons.qr_code_2,
                        color: Colors.white,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                      title: Text(
                        selectedIndex == 0 ? staticHistoryData[index] : staticHistoryData1[index],
                        style: GoogleFonts.poppins(
                            wordSpacing: 2,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
              childCount: selectedIndex == 0 ? staticHistoryData.length : staticHistoryData1.length,
            ),
          ),
        ],
      ),
    );
  }
}
