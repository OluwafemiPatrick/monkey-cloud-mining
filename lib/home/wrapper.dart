import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mcm/home/email_verification.dart';
import 'package:mcm/home/homepage.dart';
import 'package:mcm/shared/common_methods.dart';
import 'package:provider/provider.dart' ;
import 'package:shared_preferences/shared_preferences.dart';

import 'welcome_page.dart';


class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return WelcomePage();
    } else {
      return HomePage();
    }
  }




}
