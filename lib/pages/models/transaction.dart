class TransactionModel {
  //class that contains all the details of a transaction
  int amount;
  final String note;
  final DateTime date;
  final String type;
  final String subtype;

  addAmount(int amount) {
    this.amount = this.amount + amount;
  }

  TransactionModel(this.amount, this.note, this.date, this.type, this.subtype);
}
