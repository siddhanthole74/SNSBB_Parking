import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:snm_parking_final/HomeScreen/homescreen.dart';
import 'package:snm_parking_final/custom_surfix_icon.dart';
import 'package:snm_parking_final/widgets/bottomnavigationbar.dart';

class AddVehicle extends StatefulWidget {
  const AddVehicle({super.key});

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  //final box = Hive.box<Add_data>('data');
  DateTime date = new DateTime.now();
  TimeOfDay startTime = new TimeOfDay.now();
  //DateTime date = new DateTime.now();

  TimeOfDay endTime = new TimeOfDay.now();
  String? selctedItem;
  String? selctedItemi;
  final TextEditingController expalin_C = TextEditingController();
  FocusNode ex = FocusNode();
  final TextEditingController amount_c = TextEditingController();
  FocusNode amount_ = FocusNode();

  //
  final List<String> _item = ["Two Wheeler 🏍️", "Three Wheeler 🛺", "Four Wheeler 🚔", "Others 🚚"];
  //
  final List<String> _itemei = [
    'In',
    "Out",
  ];

  // for number plate
  final controllerName = TextEditingController();

  // Entry timewe
  //TimeOfDay startTime = new TimeOfDay.now();

  // for backend database variable
  final controllerMobileNo = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            background_container(context),
            Positioned(
              top: 120,
              child: main_container(),
            ),
          ],
        ),
      ),
    );
  }

  Container main_container() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        height: 600,
        width: 340,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    imagePick(0), // photo capture
                    // SizedBox(width: 10),
                    // imagePick(1),
                    // SizedBox(width: 10),
                    // imagePick(2),
                  ],
                ),
              ),
              SizedBox(height: 30),
              TypeVehicle(), // type of vehicle
              SizedBox(height: 30),
              //explain(),
              TakeName(), // Mobile no of driver
              SizedBox(height: 30),
              TakeMobileNo(),
              SizedBox(height: 30),
              Name(),
              SizedBox(height: 30),
              StatusVehicle(), // in out status
              SizedBox(height: 30),
              //date_time(),  //
              //Spacer(),
              save(),
              SizedBox(height: 20),
            ],
          ),
        ));
  }

  // in order to take pic of driver
  GestureDetector Image1() {
    return GestureDetector(
      onTap: () {
        ImagePicker();
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.deepOrangeAccent,
        ),
        width: 120,
        height: 50,
        child: Text(
          'Pick image 1',
          style: TextStyle(
            fontFamily: 'f',
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  List<String> imageUrls = [];

  void imageFromCamera(int ind) async {
    String imageUrl = '';
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      print(image.path);
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImage = referenceRoot.child('image');
      Reference referenceImageToUpload = referenceDirImage.child('${DateTime.now().millisecondsSinceEpoch}.png');

      try {
        await referenceImageToUpload.putFile(File(image.path));
        imageUrl = await referenceImageToUpload.getDownloadURL();
        imageUrls.add(imageUrl);
      } catch (e) {
        print(e);
        print("Zala Bhau");
      }
    }

    print("ewkjnfkjnff");
    print(imageUrls);
    print(imageUrl);
    setState(() {});
  }

  GestureDetector imagePick(int ind) {
    return GestureDetector(
      onTap: () => imageFromCamera(ind),
      child: imageUrls.length < ind + 1
          ? DottedBorder(
              color: Colors.black,
              borderType: BorderType.Circle,
              radius: const Radius.circular(15),
              dashPattern: const [10, 4],
              strokeCap: StrokeCap.round,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.camera_alt,
                      size: 20,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Capture Photo",
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                    )
                  ],
                ),
              ),
            )
          : Stack(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  child: Image.network(
                    imageUrls[ind],
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
    );
  }
// Future<void> imageFromGallary(int ind, {bool isCamera = false}) async {
//   final picker = ImagePicker();
//   final pickedFile = await pick+er.getImage(
//     source: isCamera ? ImageSource.camera : ImageSource.gallery,
//   );

//   if (pickedFile != null) {
//     // Handle the picked image file here
//     // Update the UI, e.g., set the image URL in the 'imageUrls' list
//     setState(() {
//       imageUrls[ind] = pickedFile.path;
//     });
//   }
// }

  GestureDetector save() {
    return GestureDetector(
      onTap: () {
        final products = Products(
          vehicleNumner: controllerName.text,
          ownerName: nameController.text,
          type: selctedItem ?? "",
          status: selctedItemi!,
          //product: selctedItem!,
          //Quantity: controllerQuantity.text,
          imageUrls: imageUrls,
          mobileno: controllerMobileNo.text,
          //startBidingDate: entrydate,
          //endBidingDate: endBidingDate,
          startTime: startTime.format(context),
          endTime: endTime.format(context),
          //location: widget.txt,
          //dealDate: date,
          // userId: userId,
          //price: []
        );
        createProduct(products);

        // Navigator.of(context).pop();  // home screen la

        Navigator.push(context, MaterialPageRoute(builder: (context) => Bottom()));
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xFF2094AC),
        ),
        width: 120,
        height: 50,
        child: Text(
          'Save',
          style: TextStyle(
            fontFamily: 'f',
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  // for no plate
  Padding Name() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        //focusNode: ex,
        //controller: expalin_C,// here for storing the name of farmer modify code later
        controller: controllerName,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          labelText: 'Enter Vehicle Number',
          labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 2, color: Colors.deepOrangeAccent)),
          suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
        ),
      ),
    );
  }

  Widget date_time() {
    return Container(
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), border: Border.all(width: 2, color: Color(0xffC5C5C5))),
      width: 300,
      child: TextButton(
        onPressed: () async {
          DateTime? newDate = await showDatePicker(
              context: context, initialDate: date, firstDate: DateTime(2020), lastDate: DateTime(2100));
          if (newDate == Null) return;
          setState(() {
            date = newDate!;
          });
        },
        child: Text(
          'Approximate deal date :  ${date.day}/${date.month}/${date.year}',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget ReturnTime() {
    return GestureDetector(
      onTap: () async {
        TimeOfDay? newtime = await showTimePicker(
          context: context,
          initialTime: stringToTimeOfDay(endTime.format(context)),
        );
        if (newtime != null) {
          endTime = stringToTimeOfDay(newtime.format(context));
        }
      },
      child: Container(
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), border: Border.all(width: 2, color: Color(0xffC5C5C5))),
        width: 300,
        child: TextButton(
          onPressed: () {},
          child: Text(
            'Return Time :  ${endTime.format(context)}',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Padding StatusVehicle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: Color(0xffC5C5C5),
          ),
        ),
        child: DropdownButton<String>(
          value: selctedItemi,
          onChanged: ((value) {
            setState(() {
              selctedItemi = value!;
            });
          }),
          items: _itemei
              .map((e) => DropdownMenuItem(
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Text(
                            e,
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                    value: e,
                  ))
              .toList(),
          selectedItemBuilder: (BuildContext context) => _itemei
              .map((e) => Row(
                    children: [Text(e)],
                  ))
              .toList(),
          hint: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              'Status',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          dropdownColor: Colors.white,
          isExpanded: true,
          underline: Container(),
        ),
      ),
    );
  }

  // take mobile no
  Padding TakeMobileNo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controllerMobileNo,
        keyboardType: TextInputType.number,
        //focusNode: ex,
        //controller: expalin_C,// here for storing the name of farmer modify code later
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          labelText: 'Enter Mobile No',
          labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 2, color: Colors.deepOrangeAccent)),
          suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
        ),
      ),
    );
  }

  //Name
  TextEditingController nameController = TextEditingController();
  Padding TakeName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: nameController,
        keyboardType: TextInputType.name,
        //focusNode: ex,
        //controller: expalin_C,// here for storing the name of farmer modify code later
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          labelText: 'Enter Your name',
          labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 2, color: Colors.deepOrangeAccent)),
          // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
        ),
      ),
    );
  }

  // In time
  Widget startDealTime() {
    return GestureDetector(
      onTap: () async {
        TimeOfDay? newTime = await showTimePicker(
          context: context,
          initialTime: stringToTimeOfDay(startTime.format(context)),
        );
        if (newTime != null) {
          setState(() {
            startTime = stringToTimeOfDay(newTime.format(context));
          });
        }
      },
      child: Container(
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), border: Border.all(width: 2, color: Color(0xffC5C5C5))),
        width: 300,
        child: TextButton(
          onPressed: () {},
          child: Text(
            'Starting Deal Time :  ${startTime.format(context)}',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Padding amount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        keyboardType: TextInputType.number,
        focusNode: amount_,
        controller: amount_c,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          labelText: 'amount',
          labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 2, color: Colors.deepOrangeAccent)),
        ),
      ),
    );
  }

  // for In time

  Padding explain() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        focusNode: ex,
        controller: expalin_C,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          labelText: 'explain',
          labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 2, color: Colors.deepOrangeAccent)),
        ),
      ),
    );
  }

  Widget startBidingTime() {
    return Container(
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), border: Border.all(width: 2, color: Color(0xffC5C5C5))),
      width: 300,
      child: TextButton(
        onPressed: () async {
          TimeOfDay? newTime = await showTimePicker(
            context: context,
            initialTime: stringToTimeOfDay(startTime.format(context)),
          );
          if (newTime != null) {
            setState(() {
              startTime = stringToTimeOfDay(newTime.format(context));
            });
          }
        },
        child: Text(
          'Starting Biding Time :  ${startTime.format(context)}',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm(); //"6:00 AM"

    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  Padding TypeVehicle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: Color(0xffC5C5C5),
          ),
        ),
        child: DropdownButton<String>(
          value: selctedItem,
          onChanged: ((value) {
            setState(() {
              selctedItem = value!;
            });
          }),
          items: _item
              .map((e) => DropdownMenuItem(
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Text(
                            e,
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                    value: e,
                  ))
              .toList(),
          selectedItemBuilder: (BuildContext context) => _item
              .map((e) => Row(
                    children: [
                      // Container(
                      //   width: 42,
                      //   child: Image.asset('assets/images/${e}.png'),
                      // ),
                      SizedBox(width: 5),
                      Text(e)
                    ],
                  ))
              .toList(),
          hint: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              'Type of vehicle',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          dropdownColor: Colors.white,
          isExpanded: true,
          underline: Container(),
        ),
      ),
    );
  }

  Column background_container(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 240,
          decoration: BoxDecoration(
            color: Color(0xFF2094AC),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Text(
                      'Vehicle Details',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    Icon(
                      Icons.attach_file_outlined,
                      color: Colors.white,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // query in order to add entry in the database
  Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection('VehicleInfo');

      var doc = await collectionRef.doc(docId).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  Future createProduct(Products user) async {
    final json = user.toJson();
    final docUser = FirebaseFirestore.instance.collection('VehicleInfo').doc(user.vehicleNumner);
    if (await checkIfDocExists(user.vehicleNumner)) {
      print("0---------------------00430-========--------------------------");
      await docUser.update({"status": user.status});
    }
    //user.id=docUser.id;

    await docUser.set(json).then(
          (value) => Fluttertoast.showToast(msg: "Notified Succesfully")
              .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => Bottom()))),
        );
  }
}

// bulding a class in order to add In and out entry in the database

class Products {
  final String vehicleNumner;
  final String ownerName;
  final String type;
  //final String product;
  //final String Quantity;
  final List<String> imageUrls;
  final String status;

  ///
  final String mobileno;
  //final String location;
  //final DateTime dealDate;
  //final DateTime startBidingDate;
  // final DateTime endBidingDate;
  //final String startBidingDate;
  //final String endBidingDate;
  final String startTime;
  final String endTime;
  //final String userId;
  //final List price;

  Products({
    required this.vehicleNumner, // for number plate
    required this.ownerName,
    required this.type,
    required this.status,
    //required this.product,
    //required this.Quantity,
    required this.mobileno,
    //required this.location,
    //required this.dealDate,
    //required this.startBidingDate,
    //required this.endBidingDate,
    required this.startTime,
    required this.endTime,
    required this.imageUrls,
    //required this.userId,
    //required this.price
  });

  Map<String, dynamic> toJson() => {
        'vehicle_no': vehicleNumner,
        'name': ownerName,
        'type': type,
        'status': status,
        //'Product': product,
        //'Quantity in KG': Quantity,
        'images': imageUrls,
        'mobile_no': mobileno,
        //'Location': location,
        //'Deal_Date': dealDate.toString(),
        //'Vehicle_In_Date': startBidingDate.toString(),
        //'End_Biding_Date': endBidingDate.toString(),
        'in_time': startTime.toString(),
        'out_time': endTime.toString(),
        //'userId': userId,
        //'price': price
      };
}
