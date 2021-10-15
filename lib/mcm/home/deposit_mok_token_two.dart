import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mcm/mcm/home/deposit_mok_token_confirmation.dart';
import 'package:mcm/shared/common_methods.dart';
import 'package:mcm/shared/constants.dart';
import 'package:mcm/shared/mcm_logo.dart';
import 'package:mcm/shared/spinner.dart';
import 'package:mcm/shared/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DepositMokTokenTwo extends StatefulWidget {

  final String amount;
  DepositMokTokenTwo(this.amount);

  @override
  _DepositMokTokenTwoState createState() => _DepositMokTokenTwoState();
}

class _DepositMokTokenTwoState extends State<DepositMokTokenTwo> {

  SharedPreferences prefs;
  String _oldWalletBalance, _amountToFund;
  bool _isLoading = false;

  @override
  void initState() {
    // get current balance
    _timeStampCheck();
    setState(() => _amountToFund = widget.amount);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String amount = widget.amount;
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
          child: ListView(
              children: [
                Divider(color: colorBlue, thickness: 0.5, height: 1.0),
                SizedBox(height: 20.0),
                Text("Scan the code below to make a payment of $amount MOK.",
                  style: TextStyle(fontSize: 13.5, color: colorWhite),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 8.0),
                  child: Text("After transfer, click on 'Confirm Transaction' to auto-verify your payment on the Blockchain network.",
                    style: TextStyle(fontSize: 13, color: colorWhite),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 40.0),
                Container(
                  height: 300.0,
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  margin: EdgeInsets.symmetric(horizontal: 40.0),
                  decoration: BoxDecoration(
                    color: colorWhite,
                    borderRadius: BorderRadius.circular(12.0)
                  ),
                  child: Column(
                    children: [
                      Expanded(child: Image.asset("assets/images/qr-code.png")),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Text(MY_BNB_ADDRESS,
                          style: TextStyle(fontSize: 14.0, color: colorGold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          width: 110.0,
                          padding: EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: [
                              Text('Copy Address  ', style: TextStyle(color: colorBlue, fontSize: 14.0),),
                              Icon(Icons.copy, size: 16.0, color: colorBlue,),
                            ] ),
                        ),
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: MY_BNB_ADDRESS));
                          toastMessage("address copied to clipboard");
                        },
                      )
                    ] ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: Text('Send only MOK token to this address. Sending any other token may result in permanent loss.',
                    style: TextStyle(fontSize: 13.0, color: colorGold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 50.0),
                verifyTransactionButton(),
              ] ),
        )
    );
  }


  Widget verifyTransactionButton() {
    return Container(
      height: 50.0,
      width: MediaQuery.of(context).size.width * 0.8,
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      child: _isLoading ? SpinnerMain() : ElevatedButton(
        child: Text('Confirm Transaction', style: TextStyle(
            color: colorWhite, fontSize: 16.0),),
        style: ElevatedButton.styleFrom(
          primary: colorBlue,
          onSurface: colorGrey2,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          elevation: 2,
        ),
        onPressed: () {
          setState(() => _isLoading = true);
          _getDataFromApi2();
        },
      ),
    );
  }


  Future<String> _getDataFromApi() async {
    prefs = await SharedPreferences.getInstance();
    String _api = 'https://api.bscscan.com/api?module=account&action=tokenbalance&contractaddress=0x56871514686bdd3627729ed03fcd6da1d1dab1c5&address=$MY_BNB_ADDRESS&tag=latest&apikey=$MCM_BSC_KEY_ONE';
  //  String _api = 'https://api.bscscan.com/api?module=account&action=balance&address=$MY_BNB_ADDRESS&tag=latest&apikey=$MCM_BSC_KEY_ONE';

    http.Response response = await http.get(_api, headers: {'Accept': 'application/json'});
    print("QUERY RESPONSE : " + response.body);

    var parsedJson = json.decode(response.body);
    double oldBal = double.parse(parsedJson['result']) / 1000000000000000000;
    var ms = (new DateTime.now()).microsecondsSinceEpoch;
    var currentTime = (ms / 1000).round().toString();

    print ("OLD BALANCE IS :" + oldBal.toStringAsFixed(6));

    setState(() => _oldWalletBalance = oldBal.toStringAsFixed(6));
    prefs.setString("timestamp_last_balance", oldBal.toStringAsFixed(6));
    prefs.setString("timestamp_last_checked", currentTime);

  }


  Future<String> _getDataFromApi2() async {
    String _api = 'https://api.bscscan.com/api?module=account&action=tokenbalance&contractaddress=0x56871514686bdd3627729ed03fcd6da1d1dab1c5&address=$MY_BNB_ADDRESS&tag=latest&apikey=$MCM_BSC_KEY_TWO';

    http.Response response = await http.get(_api, headers: {'Accept': 'application/json'});
    print("QUERY RESPONSE : " + response.body);

    var parsedJson = json.decode(response.body);
    double newBal = double.parse(parsedJson['result']) / 1000000000000000000;
    double oldBal = double.parse(_oldWalletBalance);

    if ((newBal-oldBal) >= double.parse(_amountToFund)) {
      // update account balance
      _sendDepositDetailsToDB();
    }
    else {
      paymentNotReceivedDialog(context);
    }

  }


  _timeStampCheck () async {
    prefs = await SharedPreferences.getInstance();
    var ms = (new DateTime.now()).microsecondsSinceEpoch;

    String lastChecked = prefs.getString("timestamp_last_checked");

    if (lastChecked!=null) {
      int lastCheckedTime = int.parse(lastChecked);
      int currentTime = (ms / 1000).round();
      int timeDiff = currentTime - lastCheckedTime;
      print ("TIME DIFFERENCE IS : " + timeDiff.toString());

      if ((currentTime - lastCheckedTime) > 900000) {
        // _fetch new balance
        _getDataFromApi();
      }
      else {
        // retrieve old balance from shared preferences
        setState(() => _oldWalletBalance = prefs.getString("timestamp_last_balance"));
      }
    }
    else {
      // fetch new balance
      _getDataFromApi();
    }

  }


  Future _sendDepositDetailsToDB() async {
    DatabaseReference profileRef = FirebaseDatabase.instance.reference();
    prefs = await SharedPreferences.getInstance();

    var ms = (new DateTime.now()).microsecondsSinceEpoch;
    String currentTime = (ms / 1000).round().toString();
    var availableTokenBalance;
    var totalDeposit;

    // update details on user account
    profileRef.child("user_profile").child(prefs.getString("currentUser")).once().then((DataSnapshot snapshot) {
      totalDeposit = snapshot.value["totalTokenDeposit"];
      availableTokenBalance = snapshot.value["mokTokenBalance"];
    }).then((value) {
      var newTotalTokenDeposit = double.parse(totalDeposit) + double.parse(_amountToFund);
      var newAvailableTokenBal = double.parse(availableTokenBalance) + double.parse(_amountToFund);
      prefs.setString("tokenBalance", newAvailableTokenBal.toStringAsFixed(4));
      profileRef.child("user_profile").child(prefs.getString("currentUser")).update({
        "totalTokenDeposit" : newTotalTokenDeposit.toStringAsFixed(4),
        "mokTokenBalance" : newAvailableTokenBal.toStringAsFixed(4),
      });
      print ("ACCOUNT DETAILS UPDATED SUCCESSFULLY");
    });

    // update details on mcm account
    profileRef.child("mcm_details").once().then((DataSnapshot snapshot) {
      totalDeposit = snapshot.value["totalDeposit"];
      availableTokenBalance = snapshot.value["availableTokenBalance"];
    }).then((value) {
      var newTotalTokenWithdrawn = double.parse(totalDeposit) + double.parse(_amountToFund);
      var newAvailableTokenBal = double.parse(availableTokenBalance) - double.parse(_amountToFund);
      profileRef.child("mcm_details").update({
        "totalDeposit" : newTotalTokenWithdrawn.toStringAsFixed(4),
        "availableTokenBalance" : newAvailableTokenBal.toStringAsFixed(4),
      });
      print ("EXITING MOK BALANCE UPDATE METHOD");
    });

    // send withdrawal_log info to database
    profileRef.child("withdrawal").child(prefs.getString("currentUser")).child(currentTime).set({
      "amount" : _amountToFund,
      "time" : getCurrentTime(),
      "status" : "Deposit",
      "address" : "",
      "isDisbursed" : "false",
    }).then((value) {
      setState(() => _isLoading = false);
      Get.to(
        DepositMokTokenConfirmation(),
        transition: Transition.rightToLeft,
        duration: Duration(milliseconds: 500),
      );
    });

  }


  Future paymentNotReceivedDialog(BuildContext context){
    setState(() => _isLoading = false);
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: Container(
              padding: const EdgeInsets.all(6.0),
              height: 140.0,
              child: Column(
                  children: <Widget>[
                    SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.warning_outlined, color: colorGold, size: 24.0,),
                        SizedBox(width: 12.0,),
                        Text("Warning", style: TextStyle(fontSize: 20.0, color: colorGold),),
                      ],
                    ),
                    Spacer(flex: 1,),
                    Text("You have no new deposits",
                      style: TextStyle(fontSize: 16.0, color: colorBlack),
                    ),
                    Spacer(flex: 2),
                    Container(
                      height: 30.0,
                      child: FlatButton(
                        child: Text("Dismiss", style: TextStyle(fontSize: 15.0, color: colorBlue, fontWeight: FontWeight.normal),),
                        color: Colors.transparent,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ]),
            ),
          );
        }
    );
  }


}
