
import 'package:flutter/material.dart';
import 'package:snm_parking_final/Add/addvehicle.dart';
import 'package:snm_parking_final/HomeScreen/customersupport.dart';
import 'package:snm_parking_final/HomeScreen/homescreen.dart';
import 'package:snm_parking_final/Subtract/removevehicle.dart';

class Bottom extends StatefulWidget {
  static String routeName = "/bottomnavigationbar";
  const Bottom({Key? key}) : super(key: key);

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int index_color = 0;
  List Screen = [HomeScreen(), CustomerSupportScreen(whatsappNumber: '+919322734789',)];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screen[index_color],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddVehicle()));
        },
        child: Icon(Icons.park_outlined, color: Colors.white,),
        backgroundColor: Color(0xFF2094AC),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.only(top: 7.5, bottom: 7.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 0;
                  });
                },
                child: Icon(
                  Icons.home,
                  size: 30,
                  color: index_color == 0 ? Color(0xFF2094AC) : Colors.grey,
                ),
              ),
              
              SizedBox(width: 10),
              
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 1;
                  });
                },
                child: Icon(
                  Icons.support_agent,
                  size: 30,
                  color: index_color == 1 ? Color(0xFF2094AC) : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
  