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
      child: Column(
          children: [
            mcmLogo(),
            Divider(color: colorBlue, thickness: 0.5, height: 1.0),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                  child: Text('COMING SOON',
                    style: TextStyle(fontSize: 40.0, color: colorRed, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ] ),
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
