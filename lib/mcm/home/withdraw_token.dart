import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcm/mcm/home/withdraw_two.dart';
import 'package:mcm/shared/constants.dart';
import 'package:mcm/shared/mcm_logo.dart';
import 'package:mcm/shared/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WithdrawToken extends StatefulWidget {
  @override
  _WithdrawTokenState createState() => _WithdrawTokenState();
}

class _WithdrawTokenState extends State<WithdrawToken> {

  SharedPreferences prefs;

  String _mokAddress='', _amountToWithdraw='', _mokTotalBalance='';

  @override
  void initState() {
    _getTokenBal();
    super.initState();
  }

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
              children: [
                Divider(color: colorBlue, thickness: 0.5, height: 1.0),
                accountBalance(),
                Spacer(flex: 1),
                info(),
                Spacer(flex: 1),
                withdrawContainers(),
                Spacer(flex: 1),
                withdrawButton(),
              ] ),
        )
    );
  }

  Widget accountBalance() {
    double usdEarning = double.parse(_mokTotalBalance) * 0.001;
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 5.0, right: 5.0),
      padding: EdgeInsets.only(top: 20.0, bottom: 12.0, left: 10.0, right: 10.0),
      decoration: new BoxDecoration(
          color: colorBlue,
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: Image.asset('assets/icons/logo.png', height: 50.0, width: 50.0,)
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('MOK Token Balance', style: TextStyle(fontSize: 13.0, color: colorWhite),),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text('$_mokTotalBalance MOK',
                              style: TextStyle(fontSize: 20.0, color: colorWhite)),
                        ),
                        Text('\$' + usdEarning.toStringAsFixed(4) + ' USD',
                            style: TextStyle(fontSize: 12.0, color: colorWhite)),

                      ],),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: null,
                  ),
                ] ),
          ]),
    );
  }

  Widget info() {
    var text = 'Withdrawal requests are processed manually. Please allow up to 24h to receive your MOK.'
        '\n \nWe recommend withdrawing to a BEP-20 supported wallet like TrustWallet.'
        '\n \nBlockchain transactions cannot be cancelled or reversed after you submit them. Please make sure that'
        'your details are correct';
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      decoration: new BoxDecoration(
          color: colorBgLighter,
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: Text(text, style: TextStyle(fontSize: 14.0, color: colorWhite),),
    );
  }

  Widget withdrawContainers() {
    return Column(
      children: [
        Container(
          height: 55.0,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0, bottom: 15.0),
          padding: EdgeInsets.only(top: 3.0, left: 15.0),
          decoration: new BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: colorGrey1),
          ),
          child: TextField(
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: InputDecoration(
              hintText: 'Enter MOK address',
              hintStyle: TextStyle(color: Colors.white60, fontSize: 14.0),
              border: InputBorder.none,
            ),
            style: TextStyle(fontSize: 15.0, color: colorWhite),
            onChanged: (value){
              setState(() {
                _mokAddress = value;
              });
            },
          ),
        ),
        Container(
          height: 55.0,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 30.0),
          padding: EdgeInsets.only(top: 3.0, left: 15.0),
          decoration: new BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: colorGrey1),
          ),
          child: TextField(
            keyboardType: TextInputType.number,
            autofocus: false,
            decoration: InputDecoration(
              hintText: 'Amount to withdraw (min: 15,000 MOK)',
              hintStyle: TextStyle(color: Colors.white60, fontSize: 14.0),
              border: InputBorder.none,
            ),
            style: TextStyle(fontSize: 15.0, color: colorWhite),
            onChanged: (value){
              setState(() => _amountToWithdraw = value );
            },
          ),
        ),
      ]);
  }


  Widget withdrawButton() {
    return Container(
      height: 50.0,
      width: MediaQuery.of(context).size.width * 0.9,
      child: ElevatedButton(
        child: Text('WITHDRAW', style: TextStyle(
            color: colorWhite, fontSize: 16.0),),
        style: ElevatedButton.styleFrom(
          primary: colorBlue,
          onSurface: colorGrey2,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          elevation: 2,
        ),
        onPressed: () {
          var amount = double.parse(_amountToWithdraw);
          var bal = double.parse(_mokTotalBalance);
          if (_mokAddress.isNotEmpty) {
            if (amount >= 15000) {
              if (bal > amount) {
                Get.to(
                  WithdrawTokenTwo(_amountToWithdraw, _mokAddress),
                  transition: Transition.rightToLeft,
                  duration: Duration(milliseconds: 200),
                );
              } else{
                toastError("insufficient funds");
              }
            } else {
              toastError("you cannot withdraw less than 30,000 MOK");
            }
          } else{
            toastError("please enter a valid address");
          }
        },
      ),
    );
  }


  _getTokenBal() async {
    prefs = await SharedPreferences.getInstance();
    setState(() => _mokTotalBalance = prefs.getString("tokenBalance"));
  }

}
