import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mcm/home/homepage.dart';


String getCurrentTime() {
  DateTime now = DateTime.now();
  String currentTime = DateFormat('H:m, MMM d ''yyyy.').format(now);
  return currentTime;
}


String getCurrentDate() {
  DateTime now = DateTime.now();
  String creationDate = DateFormat('EEE, MMM, d, ''yy').format(now);
  return creationDate;
}



void returnToHomePage(BuildContext context) {
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
    builder: (BuildContext context) => HomePage(),
  ), (route) => false,
  );
}