import 'package:flutter/material.dart';
import 'package:seller_app_food_deliver/Authentication/auth_screen.dart';
import 'package:seller_app_food_deliver/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  String name="";
Future loadlocaldata()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
name=await prefs.getString("name")!;
setState(() {

});
print("name $name");
}
  void initState() {
    loadlocaldata();
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.cyan, Colors.amber],
                begin: const FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        title: Text(name),centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(child: ElevatedButton(child: Text("Logout"),
style: ElevatedButton.styleFrom(primary: Colors.cyan),

      onPressed: () async {
firebaseAuth.signOut();
 sharedPreferences?.clear();
SharedPreferences prefs=await SharedPreferences.getInstance();
prefs.clear();
Navigator.push(context, MaterialPageRoute(builder: (c)=>Auth_screen()));
      },),),
    );
  }
}
