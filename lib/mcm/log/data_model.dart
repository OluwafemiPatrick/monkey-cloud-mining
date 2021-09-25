class MiningLogDataModel {
  String amount;
  String date;

  MiningLogDataModel(this.amount, this.date);

}


class TransactionLogDataModel {
  String amount;
  String status;
  String time;

  TransactionLogDataModel(this.amount, this.status, this.time);
}


class StakingLogDataModel {
  String amount;
  String stakeDate;
  String maturesOn;

  StakingLogDataModel(this.amount, this.stakeDate, this.maturesOn);
}


