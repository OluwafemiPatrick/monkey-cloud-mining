import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mcm/services/firebase_services.dart';
import 'package:mcm/shared/common_methods.dart';
import 'package:mcm/shared/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MCMAuthService {

  SharedPreferences prefs;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseServices _firebaseServices = new FirebaseServices();


  Stream<User> get user {
    return _auth.authStateChanges();
  }


  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    var profileRef = FirebaseDatabase.instance.reference().child("user_profile");
    prefs = await SharedPreferences.getInstance();
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;

      // update last login time, then get account details
      profileRef.child(user.uid.toString()).update({
        "lastLogin" : getCurrentTime(),
      });
      profileRef.child(user.uid.toString()).once().then((DataSnapshot snapshot) {
        prefs.setString("tokenBalance", snapshot.value["mokTokenBalance"]);
        prefs.setString("totalMiningSessions", snapshot.value["totalMiningSessions"]);
        prefs.setString("totalTokenEarned", snapshot.value["totalTokenEarned"]);
        prefs.setString("referral_code", snapshot.value["referralCode"]);
        prefs.setString("referredByCode", snapshot.value["referredByCode"]);
      });

      prefs.setString("currentUser", user.uid.toString());
      prefs.setInt("last_login", _getCurrentTime());
      prefs.setString("userEmail", email);

      return user;
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }


  // sign up with email and password
  Future signUpWithEmailAndPassword(String email, password, fullName, referralCode, referredByCode) async {
    var refReference = FirebaseDatabase.instance.reference().child("referral_ids");
    prefs = await SharedPreferences.getInstance();

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      String referredByUserId;
      String referredByReferralCount;
      String referralChain;

      if (referredByCode != ''){
        print ("REFERRAL CODE IS NOT NULL, EXECUTING CODE");
        refReference.child(referredByCode).once().then((DataSnapshot snapshot) {
          referredByUserId = snapshot.value["myUserId"];
          referredByReferralCount = snapshot.value["noOfReferrals"];
          referralChain = snapshot.value["referralChain"];
        }).then((value) {

          int newRefCount = int.parse(referredByReferralCount) + 1;
          _firebaseServices.uploadProfileDetailsToDB(fullName, email, password, user.uid.toString(),
              getCurrentDate(), getCurrentTime(), "bnbAddress", "100.0000", referralCode,
              referredByCode, referredByUserId, "0", "0.0000", "0.0000", "0.0000", "0.0000", "1");

          _firebaseServices.uploadChainReferralDetails(referralChain);
          _firebaseServices.uploadReferralDetails(fullName, referralCode, user.uid.toString(), generateNewRefChain(referralChain, referralCode));
          _firebaseServices.updateRefereeReferralCount(referredByCode, newRefCount.toString());
        });
      }
      else {
        print ("REFERRAL CODE IS NULL, UPLOADING PROFILE DETAILS TO DB");
        var newRefCode = '0000-0000-$referralCode';

        _firebaseServices.uploadProfileDetailsToDB(fullName, email, password, user.uid.toString(),
            getCurrentDate(), '', "bnbAddress", "100.0000", referralCode,
            "", "", "0", "0.0000", "0.0000", "0.0000", "0.0000", "1");

        _firebaseServices.uploadReferralDetails(fullName, referralCode, user.uid.toString(), newRefCode);
      }

      prefs.setString("currentUser", user.uid.toString());
      prefs.setString("tokenBalance", "100.0000");
      prefs.setString("totalMiningSessions", "0");
      prefs.setString("totalTokenEarned", "0.0000");
      prefs.setString("referredByCode", referredByCode);
      prefs.setInt("last_login", _getCurrentTime());
      prefs.setString("userEmail", email);

      return user;
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }


  String generateNewRefChain (String referralChain, myRefCode) {
    var chainSplit = referralChain.split("-");
    String ref1 = chainSplit[1];
    String ref2 = chainSplit[2];

    String newReferralChain = "$ref1-$ref2-$myRefCode";
    return newReferralChain;
  }


  Future forgotPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email).then((value) {
      toastMessage("Success: kindly check your email for recovery instructions");
    });
  }

  // sign out
  Future signOut() async {
    prefs = await SharedPreferences.getInstance();
    try {
      prefs.remove("currentUser");
      prefs.remove("counterValue");
      prefs.remove("referral_code");
      prefs.remove("tokenBalance");
      prefs.remove("totalMiningSessions");
      prefs.remove("totalTokenEarned");
      prefs.remove("last_login");
      prefs.remove("referredByCode");
      prefs.remove("userEmail");

      prefs.clear();
      return await _auth.signOut();
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }


  int _getCurrentTime() {
    var ms = (new DateTime.now()).microsecondsSinceEpoch;
    return (ms / 1000).round();
  }


}