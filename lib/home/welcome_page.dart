import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mcm/shared/constants.dart';

import 'log_in_page.dart';
import 'sign_up_page.dart';


class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.5),
          child: AppBar(backgroundColor: colorBgLighter)
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: colorBgLighter,
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              children: [
                Container(
                  width: 150.0,
                  height: 150.0,
                  margin: EdgeInsets.only(top: 10.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/icons/logo.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 00.0),
                  child: Text('Welcome to Monkey Cloud Mining', style: TextStyle(
                      fontStyle: FontStyle.italic, fontSize: 18.0, color: colorBlue ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Spacer(flex: 1),
                logInWithEmailAndPassword(),
                SizedBox(height: 20.0,),
                signUpWithEmailAndPassword(),
              ],),
          ),
        ),
      ),
    );
  }


  Widget logInWithEmailAndPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25.0),
      child: ElevatedButton(
        child: SizedBox(
            height: 50.0,
            width: MediaQuery.of(context).size.width,
            child: Center(child: Text('Log in with email and password', style: TextStyle(
                color: colorBlue, fontWeight: FontWeight.bold, fontSize: 15.0),),
            )),
        style: ElevatedButton.styleFrom(
          primary: colorWhite,
          onSurface: Colors.grey,
          shadowColor: colorBgMain,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          side: BorderSide(color: colorBlue, width: 1),
          elevation: 2,
        ),
        onPressed: () {
          Get.to(
            LogInPage(),
            transition: Transition.rightToLeft,
            duration: Duration(milliseconds: 500),
          );
        },
      ),
    );
  }

  Widget signUpWithEmailAndPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25.0),
      child: ElevatedButton(
        child: SizedBox(
            height: 50.0,
            width: MediaQuery.of(context).size.width,
            child: Center(child: Text('Sign up with email and password', style: TextStyle(
                color: colorWhite, fontWeight: FontWeight.bold, fontSize: 15.0),),
            )),
        style: ElevatedButton.styleFrom(
          primary: colorBlue,
          onSurface: Colors.grey,
          shadowColor: colorBgMain,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          elevation: 2,
        ),
        onPressed: () {
          Get.to(
            SignUpPage(),
            transition: Transition.rightToLeft,
            duration: Duration(milliseconds: 500),
          );
        },
      ),
    );

  }

}
