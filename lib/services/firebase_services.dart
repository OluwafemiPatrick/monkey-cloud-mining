import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseServices {


  SharedPreferences prefs;

  Future uploadProfileDetailsToDB(String fullName, email, password, userId, accountCreationDate,
      lastLogin, bnbAddress, mokTokenBalance, referralCode, referredByCode, referredByUserId, totalMiningSessions,
      totalTokenEarned, totalTokenWithdrawn, totalTokenStaked, totalTokenDeposit, dayCount) async {

    prefs = await SharedPreferences.getInstance();
    DatabaseReference profileDatabase = FirebaseDatabase.instance.reference().child("user_profile");

    profileDatabase.child(prefs.getString("currentUser")).set({
      "fullName" : fullName,
      "email" : email,
      "password" : password,
      "userId" : userId,
      "accountCreationDate" : accountCreationDate,
      "lastLogin" : lastLogin,
      "bnbAddress" : bnbAddress,
      "mokTokenBalance" : mokTokenBalance,
      "referralCode" : referralCode,
      "referredByCode" : referredByCode,
      "referredByUserId" : referredByUserId,
      "totalMiningSessions" : totalMiningSessions,
      "totalTokenEarned" : totalTokenEarned,
      "totalTokenWithdrawn" : totalTokenWithdrawn,
      "totalTokenStaked" : totalTokenStaked,
      "totalTokenDeposit" : totalTokenDeposit,
      "dayCount" : dayCount,
    });
  }


  Future uploadReferralDetails(String fullName, referralId, userId, referralChain) async {

    DatabaseReference profileDatabase = FirebaseDatabase.instance.reference().child("referral_ids");

    profileDatabase.child(referralId).set({
      "fullName" : fullName,
      "myReferralCode" : referralId,
      "referralChain" : referralChain,
      "myUserId" : userId,
      "noOfReferrals" : '0',
      "users_earned_two" : '0',
      "users_earned_five" : '0',
      "users_earned_ten" : '0',
      "subLevelRefEarning" : '0.0000',
      "subLevelRefCount" : '0',
    });
  }


  Future updateRefereeReferralCount(String referralId, newReferralCount) async {
    DatabaseReference profileDatabase = FirebaseDatabase.instance.reference().child("referral_ids");

    profileDatabase.child(referralId).update({
      "noOfReferrals" : newReferralCount,
    });
  }


  Future uploadMCMDetailsToDB(String totalTokenMined, totalWithdrawal, totalDeposit,
      totalStake, availableTokenBalance) async {

    DatabaseReference mcmRef = FirebaseDatabase.instance.reference().child("mcm_details");

    mcmRef.set({
      "totalTokenMined" : totalTokenMined,
      "totalWithdrawal" : totalWithdrawal,
      "totalDeposit" : totalDeposit,
      "totalNetStake" : totalStake,
      "availableTokenBalance" : availableTokenBalance,
    });

  }


  /// Note to future self
  /// most part of the function below works on assumption, because as it is, I am too lazy to properly test things out.
  /// so if you find it difficult to debug, kindly take a deep sleep, then work on it with a clear mind when you wake up.
  /// Thank you.
  Future uploadChainReferralDetails(String referralChain) async {
    DatabaseReference profileRef = FirebaseDatabase.instance.reference().child("user_profile");
    DatabaseReference refReference = FirebaseDatabase.instance.reference().child("referral_ids");

    // split the chain id
    // for each id fetch the current balance
    // update the balance for each id with the current amount
    var chainSplit = referralChain.split("-");
    String ref0 = chainSplit[0];
    String ref1 = chainSplit[1];
    String ref2 = chainSplit[2];

    if (ref0.length == 8) {
      String ref0UserId, ref0RefCount, ref0RefEarning, ref0TokenBalance;
      refReference.child(ref0).once().then((DataSnapshot snapshot) {
        ref0UserId = snapshot.value["myUserId"];
        ref0RefCount = snapshot.value["subLevelRefCount"];
        ref0RefEarning = snapshot.value["subLevelRefEarning"];
      }).then((value) {
        print ("SUB-LEVEL REFERRAL DETAILS FETCHED: UPLOADING PROFILE DETAILS");
        double newRefEarning = double.parse(ref0RefEarning) + 25;
        int newRefCount = int.parse(ref0RefCount) + 1;

        refReference.child(ref0).update({
          "subLevelRefEarning" : newRefEarning.toStringAsFixed(4),
          "subLevelRefCount" : newRefCount.toString(),
        });

        profileRef.child(ref0UserId).once().then((DataSnapshot snapshot) {
          ref0TokenBalance = snapshot.value["mokTokenBalance"];
        }).then((value) {
          double newTokenBalance = double.parse(ref0TokenBalance) + 25;
          profileRef.child(ref0UserId).update({
            "mokTokenBalance" : newTokenBalance
          });
        });
      });
    }

    if (ref1.length == 8) {
      String ref1UserId, ref1RefCount, ref1RefEarning, ref1TokenBalance;
      refReference.child(ref1).once().then((DataSnapshot snapshot) {
        ref1UserId = snapshot.value["myUserId"];
        ref1RefCount = snapshot.value["subLevelRefCount"];
        ref1RefEarning = snapshot.value["subLevelRefEarning"];
      }).then((value) {
        print ("SUB-LEVEL REFERRAL DETAILS FETCHED: UPLOADING PROFILE DETAILS");
        double newRefEarning = double.parse(ref1RefEarning) + 50;
        int newRefCount = int.parse(ref1RefCount) + 1;

        refReference.child(ref1).update({
          "subLevelRefEarning" : newRefEarning.toStringAsFixed(4),
          "subLevelRefCount" : newRefCount.toString(),
        });

        profileRef.child(ref1UserId).once().then((DataSnapshot snapshot) {
          ref1TokenBalance = snapshot.value["mokTokenBalance"];
        }).then((value) {
          double newTokenBalance = double.parse(ref1TokenBalance) + 50;
          profileRef.child(ref1UserId).update({
            "mokTokenBalance" : newTokenBalance
          });
        });
      });
    }

    if (ref2.length == 8) {
      String ref2UserId, ref2RefCount, ref2RefEarning, ref2TokenBalance;
      refReference.child(ref2).once().then((DataSnapshot snapshot) {
        ref2UserId = snapshot.value["myUserId"];
        ref2RefCount = snapshot.value["subLevelRefCount"];
        ref2RefEarning = snapshot.value["subLevelRefEarning"];
      }).then((value) {
        print ("SUB-LEVEL REFERRAL DETAILS FETCHED: UPLOADING PROFILE DETAILS");
        double newRefEarning = double.parse(ref2RefEarning) + 100;
        int newRefCount = int.parse(ref2RefCount) + 1;

        refReference.child(ref2).update({
          "subLevelRefEarning" : newRefEarning.toStringAsFixed(4),
          "subLevelRefCount" : newRefCount.toString(),
        });

        profileRef.child(ref2UserId).once().then((DataSnapshot snapshot) {
          ref2TokenBalance = snapshot.value["mokTokenBalance"];
        }).then((value) {
          double newTokenBalance = double.parse(ref2TokenBalance) + 100;
          profileRef.child(ref2UserId).update({
            "mokTokenBalance" : newTokenBalance
          });
        });
      });
    }

  }



}