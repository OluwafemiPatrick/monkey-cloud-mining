import 'package:flutter/material.dart';
import 'package:mcm/shared/constants.dart';

class HomeGame extends StatefulWidget {
  @override
  _HomeGameState createState() => _HomeGameState();
}

class _HomeGameState extends State<HomeGame> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorBgMain,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
                'assets/images/game_one.png',
              fit: BoxFit.fill,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text('Coming Soon',
                style: TextStyle(fontSize: 20.0, color: colorBgMain, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }


  Widget mcmLogo(){
    return  Container(
      height: 50.0,
      width: MediaQuery.of(context).size.width,
      color: colorBgLighter,
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Image.asset("assets/icons/logo.png"),
    );
  }


}
