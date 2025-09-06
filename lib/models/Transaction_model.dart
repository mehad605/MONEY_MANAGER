class TransactionData {
  //a class to to store all teh details associated with a transaction
  final int amount;
  final DateTime date;
  final String note;
  final String type;
  final String subtype;

  TransactionData(this.amount, this.date, this.note, this.type, this.subtype);

  int get day {
    return date.day;
  }

  int get month {
    return date.month;
  }
}
