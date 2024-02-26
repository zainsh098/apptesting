import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QRHistoryScreen extends StatefulWidget {
  const QRHistoryScreen({Key? key}) : super(key: key);

  @override
  State<QRHistoryScreen> createState() => _QRHistoryScreenState();
}

class _QRHistoryScreenState extends State<QRHistoryScreen> {
  final List<String> tabs = ['Today', 'All'];
  int _selectedIndex = 0;

  // Sample data for History and All lists
  List<String> historyData = [
    'History Item 1',
    'History Item 2',
    'History Item 3'
  ];
  List<String> allData = ['All Item 1', 'All Item 2', 'All Item 3'];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.06,
              ),
              Divider(
                indent: 130,
                endIndent: 130,
                thickness: 3,
                color: Colors.grey.shade400,
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Center(
                child: Text('Scanning History',
                    style: GoogleFonts.poppins(
                        wordSpacing: 2,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w700,
                        fontSize: height * 0.027,
                        color: Colors.black)),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildTabButton(0),
                  SizedBox(
                    width: width * 0.03,
                  ),
                  buildTabButton(1),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                height: height * 0.80,
                width: width * 0.85, // Adjust the width as needed
                child: buildBody(),
              ),
              SizedBox(
                height: 3,
              )
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton buildTabButton(int index) {
    final isSelected = index == _selectedIndex;
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(Size(140, 45)),
        backgroundColor: MaterialStateProperty.all(
          isSelected ? Colors.blue.shade300 : Colors.grey.shade300,
        ),
      ),
      onPressed: () => setState(() {
        _selectedIndex = index;
      }),
      child: Text(tabs[index],
          style: GoogleFonts.poppins(
              wordSpacing: 2,
              letterSpacing: 1,
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Colors.white)),
    );
  }

  Widget buildBody() {
    return _selectedIndex == 0 ? buildHistoryList() : buildAllList();
  }

  Widget buildHistoryList() {
    // Static data for the history list
    List<String> staticHistoryData = [
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

    return ListView.builder(
      itemCount: staticHistoryData.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 10,
          color: Colors.blue.shade300,
          child: ListTile(


            leading: const Icon(
              Icons.qr_code_2,
              color: Colors.white,
            ),
            trailing:const  Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),

            title: Text(staticHistoryData[index],
                style: GoogleFonts.poppins(
                    wordSpacing: 2,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.white)),
            // Add other relevant content for each item
          ),
        );
      },
    );
  }

  Widget buildAllList() {
    return Column(
      children: List.generate(
        allData.length,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          // Set the desired space between tiles
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue.shade300,
            ),
            child: ListTile(
              shape: const StadiumBorder(),
              tileColor: Colors.transparent,
              // Set to transparent to avoid double background
              title: Text(allData[index]),
              // Add other relevant content for each item
            ),
          ),
        ),
      ),
    );
  }
}
