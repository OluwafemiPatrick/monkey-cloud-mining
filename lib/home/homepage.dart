import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mcm/mcm/game/home_game.dart';
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

  SharedPreferences prefs;

  double _iconSize = 25.0;
  double _textSize = 12.0;

  bool isHomeButton = true;
  bool isLogButton = false;
  bool isGameButton = false;
  bool isMenuButton = false;
  bool _isConnected = false;

  String _mokTokenBalance, _miningSessionFromDB, _dayCount, _referralCode;

  @override
  void initState() {
    _getConnectionStatus();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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
              Column(
                children: [
                  Expanded(
                    child: Visibility(
                      visible: _isConnected,
                      child: _switchNavigationButtons()
                    ),
                  ),
                  bottomNavigationButtons(),
                ],
              ),
              _noConnectionDisplay(),
            ],
          )
      ),
    );
  }


  Widget _switchNavigationButtons() {

    if (isLogButton == true) {
      return HomeLog();
    }
    if (isGameButton == true) {
      return HomeGame();
    }
    if (isMenuButton == true) {
      return HomeMenu(_referralCode);
    }
    else {
      return HomeHome(_miningSessionFromDB, _dayCount, _referralCode, _mokTokenBalance);
    }
  }

  Widget bottomNavigationButtons() {
    return Container(
      color: colorBgLighter,
      padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _homeButton(text: "Home", iconName: Icons.home),
          _logButton(text: "Log", iconName: Icons.store),
          _gameButton(text: 'Game', iconName: Icons.games_outlined),
          _menuButton(text: "Menu", iconName: Icons.menu),
        ],
      ),
    );
  }


  _homeButton({String text, IconData iconName}) {
    return Expanded(
      child: FlatButton(
        onPressed: () {
          setState(() {
            isHomeButton = true;
            isLogButton = false;
            isGameButton = false;
            isMenuButton = false;
          });
        },
        child: Column(
          children: <Widget>[
            Icon(iconName, size: _iconSize, color: isHomeButton ? colorBlue : colorWhite),
            SizedBox(height: 5.0),
            isHomeButton
                ? Text(text, style: TextStyle(fontSize: _textSize, color: isHomeButton ? colorBlue : colorWhite))
                : Container()
          ],
        ),
      ),
    );
  }

  _logButton({String text, IconData iconName}) {
    return Expanded(
      child: FlatButton(
        onPressed: () {
          setState(() {
            isHomeButton = false;
            isLogButton = true;
            isGameButton = false;
            isMenuButton = false;
          });
        },
        child: Column(
          children: <Widget>[
            Icon(iconName, size: _iconSize, color: isLogButton ? colorBlue : colorWhite),
            SizedBox(height: 5.0),
            isLogButton
                ? Text(text, style: TextStyle(fontSize: _textSize, color: isLogButton ? colorBlue : colorWhite))
                : Container()
          ],
        ),
      ),
    );
  }

  _gameButton({String text, IconData iconName}) {
    return Expanded(
      child: FlatButton(
        onPressed: () {
          setState(() {
            isHomeButton = false;
            isLogButton = false;
            isGameButton = true;
            isMenuButton = false;
          });
        },
        child: Column(
          children: <Widget>[
            Icon(iconName, size: _iconSize, color: isGameButton ?colorBlue : colorWhite),
            SizedBox(height: 5.0),
            isGameButton
                ? Text(text, style: TextStyle(fontSize: _textSize, color: isGameButton ? colorBlue : colorWhite))
                : Container()
          ],
        ),
      ),
    );
  }

  _menuButton({String text, IconData iconName}) {
    return Expanded(
      child: FlatButton(
        onPressed: () {
          setState(() {
            isHomeButton = false;
            isLogButton = false;
            isGameButton = false;
            isMenuButton = true;
          });
        },
        child: Column(
          children: <Widget>[
            Icon(iconName, size: _iconSize, color: isMenuButton ? colorBlue : colorWhite ),
            SizedBox(height: 5.0),
            isMenuButton
                ? Text(text, style: TextStyle(fontSize: _textSize, color: isMenuButton ? colorBlue : colorWhite))
                : Container()
          ],
        ),
      ),
    );
  }


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


  Future _fetchDataAndUpdateLoginTime() async {
    DatabaseReference profileRef = FirebaseDatabase.instance.reference().child("user_profile");
    DateTime now = DateTime.now();
    prefs = await SharedPreferences.getInstance();

    String currentTime = DateFormat('H:m, MMM d ''yyyy.').format(now);
    String userId = prefs.getString("currentUser");

    profileRef.child(userId).once().then((DataSnapshot snapshot) {

      setState(() {
        _referralCode = snapshot.value['referralCode'];
        _mokTokenBalance = snapshot.value['mokTokenBalance'];
        _miningSessionFromDB = snapshot.value['totalMiningSessions'];
        _dayCount = snapshot.value['dayCount'];
      });

      prefs.setString("tokenBalance", snapshot.value['mokTokenBalance']);

      print('CURRENT MOK BALANCE IS : $_mokTokenBalance');
      print('CURRENT REFERRAL CODE IS : $_referralCode');
      print('CURRENT MINING SESSION : $_miningSessionFromDB');
      print('CURRENT DAY COUNT IS : $_dayCount');

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
      _fetchDataAndUpdateLoginTime();
    }
    else {
      _isConnected = false;
    }
  }


}
