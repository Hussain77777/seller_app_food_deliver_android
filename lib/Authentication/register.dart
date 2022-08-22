import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:io';import 'package:shared_preferences/shared_preferences.dart';
import 'package:seller_app_food_deliver/global/global.dart';
import 'package:flutter/foundation.dart';
import 'package:seller_app_food_deliver/mainScreens/home_screen.dart';
import 'package:seller_app_food_deliver/widgets/error_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../widgets/customTextField.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

import '../widgets/loading_dialog.dart';

class Register extends StatefulWidget {
  const Register({
    Key? key,
  }) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      imageXFile;
    });
  }

  String sellerImageUrl = "";
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

//  List<Placemark> placemarks = await placemarkFromCoordinates(52.2165157, 6.9437819);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController name_controller = TextEditingController();
  TextEditingController pass_controller = TextEditingController();
  TextEditingController confirmpass_controller = TextEditingController();
  TextEditingController phone_controller = TextEditingController();

  TextEditingController location_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController address_controller = TextEditingController();
  double lat = 0;
  double lng = 0;

  getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      lat = position.latitude;
      lng = position.longitude;
      print("latitude = ${lat}");
      print("longitude= ${lng}");
      List<Placemark> placemarks =
          await placemarkFromCoordinates(lat, lng);
      print(placemarks[0].name);
      address_controller.text =
          "${placemarks[0].name} ${placemarks[0].street} ${placemarks[0].country} ";
      print(address_controller.text);
      return;
    } else if (permission == LocationPermission.deniedForever) {
      await Geolocator.openLocationSettings();

      return;
    } else {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      lat = position.latitude;
      lng = position.longitude;
      print("latitude = ${lat}");
      print("longitude= ${lng}");
      List<Placemark> placemarks =
          await placemarkFromCoordinates(lat, lng);

      address_controller.text =
          "${placemarks[0].name} ${placemarks[0].street} ${placemarks[0].country} ";
      print(address_controller.text);
    }
  }

  Future<void> formValidation() async {
    if (imageXFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please select an image",
            );
          });
    } else {
      if (pass_controller.text == confirmpass_controller.text) {
        if (pass_controller.text.isNotEmpty &&
            confirmpass_controller.text.isNotEmpty &&
            email_controller.text.isNotEmpty &&
            address_controller.text.isNotEmpty &&
            phone_controller.text.isNotEmpty &&
            name_controller.text.isNotEmpty) {
          showDialog(
              context: context,
              builder: (c) {
                return LoadingDialog(
                  message: "Registering Account",
                );
              });
          String fileName = DateTime.now().microsecondsSinceEpoch.toString();
          Reference reference =
              FirebaseStorage.instance.ref().child("sellers").child(fileName);
          UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
          TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
          await taskSnapshot.ref.getDownloadURL().then((url) {
            sellerImageUrl = url;
            authenticaandsignup();
          });
        } else {
          showDialog(
              context: context,
              builder: (c) {
                return ErrorDialog(
                  message: "Please write the required info",
                );
              });
        }
      } else {
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "Password do not match",
              );
            });
      }
    }
  }

  void authenticaandsignup() async {
    User? currentUser;
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .createUserWithEmailAndPassword(
            email: email_controller.text.trim(),
            password: pass_controller.text.trim())
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error)
    {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    });
    if (currentUser != null) {
      saveDataToFirestore(currentUser!).then((value) {
        Navigator.pop(context);
        Route newroute=MaterialPageRoute(builder: (c)=>HomeScreen());
        Navigator.pushReplacement(context,newroute);

      });
    }
  }

  Future saveDataToFirestore(User currentuser) async {
    FirebaseFirestore.instance.collection("sellers").doc(currentuser.uid).set({
      "SellerUID": currentuser.uid,
      "SellerEmail": currentuser.email,
      "SellerName": name_controller.text.trim(),
      "SellerAvatorUrl": sellerImageUrl,
      "SellerPhone": phone_controller.text.trim(),
      "SellerAddress": address_controller.text.trim(),
      "Status": "approved",
      "earning": 0.0,
      "lat": lat,
      "lng": lng,
    });
    print(currentuser.uid);
    print(name_controller.text.trim());
 SharedPreferences prefs=await SharedPreferences.getInstance();
    await prefs.setString("uid", currentuser.uid);
    prefs.setString("name", name_controller.text.trim());
    await prefs.setString("photourl", sellerImageUrl);
    print("123");
    print(prefs.getString("name"));
    print(prefs.getString("photourl"));
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              _getImage();
            },
            child: CircleAvatar(
              radius: size.width * 0.20,
              backgroundColor: Colors.white,
              backgroundImage:
                  imageXFile == null ? null : FileImage(File(imageXFile!.path)),
              child: imageXFile == null
                  ? Icon(
                      Icons.add_photo_alternate,
                      size: size.width * 0.2,
                      color: Colors.grey,
                    )
                  : null,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Custom_TextField(
                  data: Icons.person,
                  controller: name_controller,
                  hintText: "Name",
                  isObsecure: false,
                ),
                Custom_TextField(
                  data: Icons.email,
                  controller: email_controller,
                  hintText: "Email",
                  isObsecure: false,
                ),
                Custom_TextField(
                  data: Icons.lock,
                  controller: pass_controller,
                  hintText: "Password",
                  isObsecure: true,
                ),
                Custom_TextField(
                  data: Icons.lock,
                  controller: confirmpass_controller,
                  hintText: "Confirm Password",
                  isObsecure: true,
                ),
                Custom_TextField(phonetype: true,
                  data: Icons.phone,
                  controller: phone_controller,
                  hintText: "Phone",
                  isObsecure: false,
                ),
                Custom_TextField(
                  data: Icons.my_location,
                  controller: address_controller,
                  hintText: "Cafe/Restaurant Address",
                  isObsecure: false,
                  enabled: false,
                ),
                Container(
                  width: 400,
                  height: 40,
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    label: Text(
                      "Get my Current Location",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      getLocation();
                      //     await getCurrentLocation();
                    },
                    icon: Icon(Icons.location_on),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.amber,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30))),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {

              formValidation();
              print("Clicked");
            },
            child: Text(
              "sign Up",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(primary: Colors.purple),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
