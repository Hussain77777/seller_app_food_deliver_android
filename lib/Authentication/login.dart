import 'package:flutter/material.dart';
import 'package:seller_app_food_deliver/mainScreens/home_screen.dart';
import 'package:seller_app_food_deliver/widgets/error_widget.dart';
import 'package:seller_app_food_deliver/widgets/loading_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../global/global.dart';
import '../widgets/customTextField.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController pass_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  User ?currentUser;
  formValidation() {
    if (pass_controller.text.isNotEmpty && email_controller.text.isNotEmpty) {
      loginNow();
    }
    else {
      showDialog(context: context, builder: (c) {
        return ErrorDialog(message: "Please write email/password",);
      });
    }
    if(currentUser!=null){

    }

  }
  loginNow() async {
    showDialog(context: context, builder: (c) {
      return LoadingDialog(message: "Checking Credentials",);
    });

    await firebaseAuth.signInWithEmailAndPassword(
        email: email_controller.text.trim(),
        password: pass_controller.text.trim()).then((auth) {
      currentUser= auth.user!;

    }).catchError((error){
      Navigator.pop(context);
      showDialog(context: context, builder: (c) {
        return ErrorDialog(message: error.message.toString(),);
      });
    });
    if(currentUser!=null){
readDataAndSetDataLocally(currentUser!).then((value) {
  Navigator.pop(context);
  Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
});
    }

  }
Future readDataAndSetDataLocally(User currentUser)async{
    await FirebaseFirestore.instance.collection("sellers").doc(currentUser.uid).get().then((snapshot) async {

      SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
      await sharedPreferences.setString("uid", currentUser.uid);
      await sharedPreferences.setString("name", snapshot.data()!["SellerName"]);
      await sharedPreferences.setString("email", snapshot.data()!["SellerEmail"]);
      await sharedPreferences.setString("photoUrl", snapshot.data()!["SellerAvatorUrl"]);
      print(sharedPreferences.getString("photoUrl",));
      print(sharedPreferences.getString("email",));
    });

}
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.all(15),
            child: Image.asset(
              "images/seller.png",
              height: 270,
            ),
          ),
          Form(
            child: Column(
              children: [
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
              ],
            ),
            key: _formKey,
          ),
          ElevatedButton(
            onPressed: () {
              formValidation();
              print("Clicked");
            },
            child: Text(
              "Login",
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
