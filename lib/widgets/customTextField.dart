import 'package:flutter/material.dart';

class Custom_TextField extends StatelessWidget {
  Custom_TextField(
      {Key? key, this.phonetype,this.hintText,this.controller, this.data, this.enabled, this.isObsecure})
      : super(key: key);
  final TextEditingController? controller;
  final IconData? data;
  final String?hintText;
  bool? isObsecure = true;
  bool? enabled = true;
bool? phonetype=false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: enabled,
        keyboardType: phonetype==true?TextInputType.number:TextInputType.name,
        controller: controller,
        obscureText: isObsecure!,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(border: InputBorder.none,prefixIcon: Icon(data,color: Colors.cyan,
        ),focusColor:Theme.of(context).primaryColor,hintText: hintText ),
      ),
    );
  }
}
