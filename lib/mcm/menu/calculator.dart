import 'package:flutter/material.dart';
import 'package:mcm/shared/constants.dart';
import 'package:mcm/shared/mcm_logo.dart';

class MOKTokenCalculator extends StatefulWidget {
  @override
  _MOKTokenCalculatorState createState() => _MOKTokenCalculatorState();
}

class _MOKTokenCalculatorState extends State<MOKTokenCalculator> {

  double usdEquivalent = 0;
  double mokEquivalent = 0;
  double exchangeRate = 0.001;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          child: AppBar(
            backgroundColor: colorBgLighter,
            title: mcmLogo(),
            centerTitle: true,
          ),
          preferredSize: Size.fromHeight(50),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(bottom: 10.0),
          color: colorBgMain,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Divider(color: colorBlue, thickness: 0.5, height: 1.0),
                Spacer(flex: 1),
                Container(
                  height: 80.0,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: new BoxDecoration(
                    color: colorBlue,
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60.0,
                        height: 60.0,
                        margin: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Image.asset('assets/images/mok-token.png')),
                      Text ('1 MOK = \$$exchangeRate USD', style: TextStyle(fontSize: 25.0, color: colorWhite)),
                    ],
                  ),
                ),
                Spacer(flex: 1,),
                _mokToUsd(),
                SizedBox(height: 20.0),
                _usdToMok(),
                Spacer(flex: 2),
              ] ),
        )
    );
  }

  Widget _mokToUsd() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      decoration: new BoxDecoration(
          color: colorBgLighter,
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('From MOK to USD', style: TextStyle(fontSize: 14.0, color: colorBlueIcon)),
          Container(
            height: 55.0,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 3.0, left: 15.0),
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
            decoration: new BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: colorGrey1),
            ),
            child: TextField(
              keyboardType: TextInputType.number,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Enter MOK amount',
                hintStyle: TextStyle(color: Colors.white60, fontSize: 14.0),
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 15.0, color: colorWhite),
              onChanged: (value){
                setState(() {
                  usdEquivalent = double.parse(value) * exchangeRate;
                });
              },
            ),
          ),
          Text(' = \$$usdEquivalent USD', style: TextStyle(fontSize: 16.0, color: colorWhite),)

        ],
      ),
    );
  }

  Widget _usdToMok() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      decoration: new BoxDecoration(
          color: colorBgLighter,
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('From USD to MOK', style: TextStyle(fontSize: 14.0, color: colorBlueIcon)),
          Container(
            height: 55.0,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 3.0, left: 15.0),
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
            decoration: new BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: colorGrey1),
            ),
            child: TextField(
              keyboardType: TextInputType.number,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Enter USD amount',
                hintStyle: TextStyle(color: Colors.white60, fontSize: 14.0),
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 15.0, color: colorWhite),
              onChanged: (value){
                setState(() {
                  mokEquivalent = double.parse(value) / exchangeRate;
                });
              },
            ),
          ),
          Text(' = $mokEquivalent MOK', style: TextStyle(fontSize: 16.0, color: colorWhite),)

        ],
      ),
    );
  }


}
