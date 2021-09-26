import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mcm/home/email_verification.dart';
import 'package:mcm/mcm/game/home_chart.dart';
import 'package:mcm/mcm/home/home_home.dart';
import 'package:mcm/mcm/log/home_log.dart';
import 'package:mcm/mcm/menu/home_menu.dart';
import 'package:mcm/shared/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  SharedPreferences prefs;
  bool _isConnected = false;

  @override
  void initState() {
    _getConnectionStatus();
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
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Visibility(
                visible: _isConnected,
                child: _widgetOptions.elementAt(_selectedIndex)
              ),
              _noConnectionDisplay(),
            ],
          )
      ),

      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
            canvasColor: colorBgLighter,
        ),
        child: new BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          elevation: 2.0,
          selectedItemColor: colorBlue,
          unselectedItemColor: colorWhite,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store),
              label: 'Log',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.games_outlined),
              label: 'Game',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Menu',
            ),
          ] ),
      ),
    );
  }


  List<Widget> _widgetOptions = <Widget>[
    HomeHome(),
    HomeLog(),
    HomeGame(),
    HomeMenu(),
  ];


  Widget _noConnectionDisplay() {
    return Visibility(
      visible: !_isConnected,
      child: Container(
        color: colorBgMain,
        child: Column(
          children: [
            Spacer(flex: 1,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              margin: EdgeInsets.symmetric(horizontal: 25.0),
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: new BoxDecoration(
                  color: colorWhite,
                  borderRadius: BorderRadius.circular(10.0)
              ),
              child: Column(
                children: [
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_outlined, color: colorRed, size: 24.0,),
                      SizedBox(width: 12.0,),
                      Text("No Internet Connection", style: TextStyle(fontSize: 18.0, color: colorRed),),
                    ],
                  ),
                  Spacer(flex: 1,),
                  Text("App requires internet connection to launch. Kindly turn on your mobile data or connect to a wifi network to enjoy the features of Monkey Cloud Mining",
                    style: TextStyle(fontSize: 14.0, color: colorBlack),
                    textAlign: TextAlign.center,
                  ),
                  Spacer(flex: 2),
                  Container(
                    height: 35.0,
                    child: TextButton(
                      child: Text("Close", style: TextStyle(fontSize: 15.0, color: colorBlue, fontWeight: FontWeight.normal),),
                      onPressed: () {
                        if(Platform.isAndroid){
                          exit(0);
                        }
                      },
                    ),
                  ),
                ]),
            ),
            Spacer(flex: 1,),
          ] ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  Future _getBalanceAndLoginTime() async {
    DatabaseReference profileRef = FirebaseDatabase.instance.reference().child("user_profile");
    DateTime now = DateTime.now();
    prefs = await SharedPreferences.getInstance();
    String currentTime = DateFormat('H:m, MMM d ''yyyy.').format(now);
    String userId = prefs.getString("currentUser");

    profileRef.child(userId).once().then((DataSnapshot snapshot) {
      prefs.setString("tokenBalance", snapshot.value['mokTokenBalance']);
      print('CURRENT MOK BALANCE IS : ' + snapshot.value['mokTokenBalance']);
    }).then((value) {
      profileRef.child(userId).update({
        "lastLogin" : currentTime,
      });
    });

  }


  _getConnectionStatus() async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult==ConnectivityResult.mobile || connectivityResult==ConnectivityResult.wifi) {
      // I am connected to a network.
      setState(() => _isConnected = true);
      _checkEmailVerification();
    }
    else {
      _isConnected = false;
    }
  }

  Future _checkEmailVerification() async {
    User userVer = FirebaseAuth.instance.currentUser;
    prefs = await SharedPreferences.getInstance();

    String email = prefs.getString("userEmail");
    await userVer.reload();

    if (userVer.emailVerified) {
      _getBalanceAndLoginTime();
    } else {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (BuildContext context) => EmailVerification(email),
      ), (route) => false,
      );
    }
  }


}
