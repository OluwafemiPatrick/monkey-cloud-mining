import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mcm/mcm/log/data_model.dart';
import 'package:mcm/shared/constants.dart';
import 'package:mcm/shared/spinner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeLog extends StatefulWidget {
  @override
  _HomeLogState createState() => _HomeLogState();
}

class _HomeLogState extends State<HomeLog> {

  SharedPreferences prefs;
  List<MiningLogDataModel> miningLogList = [];
  List<TransactionLogDataModel> transactionLogList = [];
  DatabaseReference _profileRef = FirebaseDatabase.instance.reference();

  bool _isMiningSelected = true;
  bool _isQueryComplete = false;
  bool _isQuery2Complete = false;

  @override
  void initState() {
    _fetchMiningLogFromDB();
    _fetchTransactionLogFromDB();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorBgMain,
      child: Column(
          children: [
            mcmLogo(),
            tabSwitch(),
            Divider(color: colorBlue, thickness: 0.5, height: 1.0),
            Expanded(child: _isMiningSelected ? showMiningLog() : showTransactionLog()),
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

  Widget tabSwitch() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      color: colorBgLighter,
      child: Row(
          children: [
            Expanded(
              child: Column(
                  children: [
                    SizedBox(
                      height: 39.0,
                      child: TextButton(
                        child: Text('Mining log',
                          style: _isMiningSelected ? TextStyle(fontSize: 17.0,fontWeight: FontWeight.normal, color: colorWhite)
                              : TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: colorWhite) ,
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          setState(() => _isMiningSelected = !_isMiningSelected);
                        },
                      ),
                    ),
                    Divider(color: _isMiningSelected ? colorBlue : Colors.transparent, thickness: 2.0, height: 1.0),
                  ]),
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 39.0,
                    child: TextButton(
                      child: Text('Transaction log',
                        style: !_isMiningSelected ? TextStyle(fontSize: 17.0,fontWeight: FontWeight.normal, color: colorWhite)
                            : TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: colorWhite) ,
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        setState(() => _isMiningSelected = !_isMiningSelected);
                      },
                    ),
                  ),
                  Divider(color: !_isMiningSelected ? colorBlue : Colors.transparent, thickness: 2.0, height: 1.0),
                ],
              ),
            ),
          ]),
    );
  }


  Widget showMiningLog() {
    return Container(
      child: _isQueryComplete ? Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: Text('Here is your daily mining log, showing tokens you have earned.', style: TextStyle(
                fontSize: 14.0, color: colorWhite ), textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              itemCount: miningLogList.length,
              itemBuilder: (_, index) {
                return miningLog(
                  miningLogList[index].amount,
                  miningLogList[index].date,
                );
              },
            ),
          ),
      ]) : SpinnerMain(),
    );
  }

  Widget showTransactionLog() {
    return Container(
      child: _isQuery2Complete ? Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
            child: Text('Here is your MOK token deposit and withdrawal history.', style: TextStyle(
                fontSize: 14.0, color: colorWhite ), textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              itemCount: transactionLogList.length,
              itemBuilder: (_, index) {
                return withdrawalLog(
                  transactionLogList[index].amount,
                  transactionLogList[index].time,
                  transactionLogList[index].status
                );
              },
            ),
          ),
      ]) : SpinnerMain(),
    );
  }

  Widget miningLog(String amount, time) {
    return Container(
      height: 55.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
      decoration: new BoxDecoration(
          color: colorBgLighter,
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: Row(
        children: [
          Spacer(flex: 1),
          Icon(Icons.gavel_outlined, size: 25.0, color: colorGreen,),
          Spacer(flex: 1),
          Text('$amount tokens mined on $time',
            style: TextStyle(fontSize: 14.0, color: colorWhite),),
          Spacer(flex: 2),
        ] ),
    );
  }


  Widget withdrawalLog(String numOfTokens, date, status) {
    return Container(
      height: 55.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
      decoration: new BoxDecoration(
        color: colorBgLighter,
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Row(
        children: [
          Spacer(flex: 1),
          status=='Deposit' ? Icon(Icons.arrow_downward_outlined, size: 25.0, color: colorGreen,)
              : Icon(Icons.arrow_upward_outlined, size: 25.0, color: colorRed,),
          Spacer(flex: 1),
          Text('$status of $numOfTokens MOK on $date',
            style: TextStyle(fontSize: 14.0, color: colorWhite),),
          Spacer(flex: 2),
        ] ),
    );
  }
  
  
  Future _fetchMiningLogFromDB() async {
    prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("currentUser");

    Timer(
      Duration(seconds: 8), () {
        setState(() => _isQueryComplete = true );
      },
    );
    
    _profileRef.child("stakes").child(userId).once().then((DataSnapshot snap) {
      miningLogList.clear();
      var keys = snap.value.keys;
      var values = snap.value;
      for (var key in keys) {
        MiningLogDataModel data = new MiningLogDataModel(
          values [key]["amount"],
          values [key]["time"],
        );
        miningLogList.add(data);
      }
      setState(() => _isQueryComplete = true);
    });
  }

  Future _fetchTransactionLogFromDB() async {
    prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("currentUser");

    Timer(
      Duration(seconds: 8), () {
        setState(() => _isQuery2Complete = true );
      },
    );

    _profileRef.child("withdrawal").child(userId).once().then((DataSnapshot snap) {
      transactionLogList.clear();
      var keys = snap.value.keys;
      var values = snap.value;
      for (var key in keys) {
        TransactionLogDataModel data = new TransactionLogDataModel(
          values [key]["amount"],
          values [key]["status"],
          values [key]["time"],
        );
        transactionLogList.add(data);
      }
      setState(() => _isQuery2Complete = true);

    });

  }



}
