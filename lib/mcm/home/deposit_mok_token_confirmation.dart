import 'package:flutter/material.dart';
import 'package:mcm/shared/common_methods.dart';
import 'package:mcm/shared/constants.dart';

class DepositMokTokenConfirmation extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          child: AppBar(backgroundColor: colorBgLighter),
          preferredSize: Size.fromHeight(0),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(bottom: 10.0),
          color: colorBgMain,
          child: Column(
              children: [
                Divider(color: colorBlue, thickness: 0.5, height: 1.0),
                Spacer(flex: 1),
                Container(
                  width: 120.0,
                  height: 120.0,
                  child: Image.asset('assets/images/confirm.png'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Text('Your account has been credited successfully.',
                    style: TextStyle(fontSize: 16.0, color: colorWhite),),
                ),
                Spacer(flex: 2,),
                buttonHome(context),
              ] ),
        )
    );
  }


  Widget buttonHome(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50.0,
      child: ElevatedButton(
        child: Text('Return to HomePage', style: TextStyle(
            color: colorWhite, fontSize: 16.0),),
        style: ElevatedButton.styleFrom(
          primary: colorRed,
          onSurface: colorGrey2,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          elevation: 2,
        ),
        onPressed: () {
          returnToHomePage(context);
        },
      ),
    );
  }


}
