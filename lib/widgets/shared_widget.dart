
import 'dart:ui';

import 'package:flutter/material.dart';

class SharedWidget {

  static TextStyle blodTextStyle(){
    return const TextStyle(
      color:  Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins'
    );
  }

   static TextStyle headLineTextStyle(){
    return const TextStyle(
      color:  Colors.black,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins'
    );
  }
     static TextStyle lightTextStyle(){
    return const TextStyle(
      color:  Colors.black38,
      fontSize: 15,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins'
    );
  }
       static TextStyle semiBoldtTextStyle(){
    return const TextStyle(
      color:  Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins'
    );
  }
}