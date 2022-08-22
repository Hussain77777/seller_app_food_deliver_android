import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

circularProgress(){
  return Container(alignment: Alignment.center,
  padding:const  EdgeInsets.all(12),
    child:const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.amber),
    ),

  );

}