import 'package:fluttertoast/fluttertoast.dart';

import 'constants.dart';

toastMessage(String toastmessage){

  Fluttertoast.showToast(
      msg: toastmessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: colorWhite,
      textColor: colorBlack,
      fontSize: 16.0
  );
}


toastError(String toastmessage){

  Fluttertoast.showToast(
      msg: toastmessage,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 5,
      backgroundColor: colorWhite,
      textColor: colorRed,
      fontSize: 16.0
  );
}
