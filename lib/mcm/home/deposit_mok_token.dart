import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcm/mcm/home/deposit_mok_token_two.dart';
import 'package:mcm/shared/constants.dart';
import 'package:mcm/shared/mcm_logo.dart';
import 'package:mcm/shared/toast.dart';

class DepositMokToken extends StatefulWidget {
  @override
  _DepositMokTokenState createState() => _DepositMokTokenState();
}

class _DepositMokTokenState extends State<DepositMokToken> {

  String _amountToDeposit = "";

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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text("Fund your Monkey Cloud Mining account",
                    style: TextStyle(fontSize: 14.0, color: colorGold, fontWeight: FontWeight.bold)
                  ),
                ),
                Container (
                  height: 55.0,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 30.0),
                  padding: EdgeInsets.only(top: 3.0),
                  decoration: new BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: colorGrey1),
                  ),
                  child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.numberWithOptions(
                      signed: false,
                      decimal: false,
                    ),
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: 'amount to deposit',
                      hintStyle: TextStyle(color: Colors.white60, fontSize: 14.0),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 15.0, color: colorWhite),
                    onChanged: (value){
                      setState(() {
                        _amountToDeposit = value;
                      });
                    },
                  ),
                ),
                Spacer(flex: 2),
                proceedButton(),
              ] ),
        )
    );
  }

  Widget proceedButton() {
    return Container(
      height: 50.0,
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton(
        child: Text('Proceed', style: TextStyle(
            color: colorWhite, fontSize: 16.0),),
        style: ElevatedButton.styleFrom(
          primary: colorBlue,
          onSurface: colorGrey2,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          elevation: 2,
        ),
        onPressed: () {
          if (_amountToDeposit.isNotEmpty) {
            Get.to(
              DepositMokTokenTwo(_amountToDeposit),
              transition: Transition.rightToLeft,
              duration: Duration(milliseconds: 500),
            );
          } 
          else {
            toastError("amount cannot be empty");
          }
          
        },
      ),
    );
  }


}
