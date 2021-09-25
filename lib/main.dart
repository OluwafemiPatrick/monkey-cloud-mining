import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mcm/home/wrapper.dart';
import 'package:mcm/services/auth.dart';
import 'package:mcm/shared/constants.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: MCMAuthService().user,
      child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Monkey Cloud Mining',
          theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primaryColor: colorBgLighter,
            accentColor: colorWhite,
          ),
          home: SplashScreen()
      ),
    );
  }
}


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Timer timer;

  @override
  void initState() {
    timer = new Timer(
        Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Wrapper()));
    } );
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.5),
          child: AppBar(backgroundColor: colorBgLighter)
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: colorBgMain,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150.0,
                height: 150.0,
                child: Image.asset('assets/icons/logo.png'),
              ),
              SizedBox(height: 10.0,),
              Text('Monkey Cloud Mining', style: TextStyle(fontSize: 20.0, color: colorWhite, fontStyle: FontStyle.italic),)
            ] ),
        ),
      ),
    );
  }
}