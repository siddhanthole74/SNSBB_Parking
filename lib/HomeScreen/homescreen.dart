import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> demoVehicleTypes = ["Two Wheeler 🏍️", "Three Wheeler 🛺", "Four Wheeler 🚔", "Others 🚚"];
  List<int> demoCounts = [200, 300, 500, 600];
  CollectionReference _collectionRef = FirebaseFirestore.instance.collection('VehicleInfo');
  // List<Map<String, dynamic>> data = [];
  int totalVehicles = 0;
  int twoWheeler = 0;
  int threeWheeler = 0;
  int fourWheeler = 0;
  int others = 0;
  int inVehicles = 0;
  int outVehicles = 0;
  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    debugPrint("-----------------------------------------------------------");
    // List<Map<String, dynamic>> mp = allData as List<Map<String, dynamic>>;
    print(allData[0].runtimeType);
    // print((allData[0] as Map<String, dynamic>)['name']);
    // print(mp['name']);

    setState(() {
      for (int i = 0; i < allData.length; i++) {
        Map<String, dynamic> mp = allData[i] as Map<String, dynamic>;
        if (mp['type'] == "Three Wheeler 🛺") {
          threeWheeler++;
        } else if (mp['type'] == "Two Wheeler 🏍️") {
          twoWheeler++;
        } else if (mp['type'] == "Four Wheeler 🚔") {
          fourWheeler++;
        } else if (mp['type'] == "Others 🚚") {
          others++;
        }

        if (mp["status"] == "Out") {
          outVehicles++;
        } else {
          inVehicles++;
        }
      }
      // data = allData as List<Map<String, dynamic>>;
      totalVehicles = allData.length;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Color(0xFF2094AC),
        body: SafeArea(
            //backgroundColor: Color(0xFF2094AC)
            child: CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(height: 340, child: _head(totalVehicles, inVehicles, outVehicles)),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Types of Vehicles',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 19,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        // SliverList(
        //   delegate: SliverChildBuilderDelegate(
        //     (context, index) {
        //       history = box.values.toList()[index];
        //       return getList(history, index);
        //     },
        //     childCount: box.length,
        //   ),
        // )

        SliverToBoxAdapter(
          child: SizedBox(
            height: 310, // Adjust the height based on your needs
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: 4, // Number of cards you want
              itemBuilder: (context, index) {
                // Adjust the data based on your requirement
                String vehicleType = demoVehicleTypes[index];
                int count = demoCounts[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: 250, // Adjust the width based on your needs
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFF92d6e5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicleType,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF12191F),
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (index == 0)
                            Text(
                              'Count: $twoWheeler',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF12191F),
                              ),
                            ),
                          if (index == 1)
                            Text(
                              'Count: $threeWheeler',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF12191F),
                              ),
                            ),
                          if (index == 2)
                            Text(
                              'Count: $fourWheeler',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF12191F),
                              ),
                            ),
                          if (index == 3)
                            Text(
                              'Count: $others',
                              style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF12191F),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    )));
  }
}

Widget _head(int total, int inVehicles, int outVehicles) {
  return Stack(
    children: [
      Column(
        children: [
          Container(
            width: double.infinity,
            height: 240,
            decoration:const BoxDecoration(
              color: Color(0xFF2094AC),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 35,
                  left: 340,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: GestureDetector(
                      onTap: () {
                        // Replace the coordinates (latitude and longitude) with your desired location

                        // Create the maps link
                        String mapsLink = 'https://maps.app.goo.gl/JtfWSvwQH4kS6Rgw5';

                        // Open the maps link using the url_launcher package
                        launch(mapsLink);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Container(
                          height: 40,
                          width: 40,
                          color:const  Color.fromRGBO(250, 250, 250, 0.1),
                          child: const Icon(
                            Icons.location_on,
                            size: 30,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding:  EdgeInsets.only(top: 35, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome ',

                        ///
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color.fromARGB(255, 224, 223, 223),
                        ),
                      ),
                      Text(
                        'Sant Nirankari Mission Samagam, Baramati.',

                        ///
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      Positioned(
        top: 140,
        left: 37,
        child: Container(
          height: 170,
          width: 320,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(47, 125, 121, 0.3),
                offset: Offset(0, 6),
                blurRadius: 12,
                spreadRadius: 6,
              ),
            ],
            color: Color(0xFF92d6e5),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total   🚘',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                    Icon(
                      Icons.more_horiz,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 7),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text(
                      '$total',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 13,
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                            size: 19,
                          ),
                        ),
                        SizedBox(width: 7),
                        Text(
                          'In $inVehicles',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 13,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                            size: 19,
                          ),
                        ),
                        SizedBox(width: 7),
                        Text(
                          'Out $outVehicles',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    ],
  );
}
