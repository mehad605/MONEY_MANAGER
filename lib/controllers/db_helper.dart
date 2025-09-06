import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:MONEY_MANAGER/pages/homepage.dart';

class DbHelper {
  //defines a Dbhelper class which is later used in various parts of other pages.
  late Box box;
  late SharedPreferences preferences;

  DbHelper() {
    openBox(); //simply calls the openBox funtion
  }

  openBox() {
    box = Hive.box('money'); //uses hive.box to storage purposes
  }

  void addData(int amount, DateTime date, String type, String note,
      String subtype) async {
    //stores the information given in the add_transaction page in hive
    var value = {
      'amount': amount,
      'date': date,
      'type': type,
      'note': note,
      'subtype': subtype
    };
    box.add(value);
  }

  Future deleteData(
    //deletes a specific entry
    int index,
  ) async {
    await box.deleteAt(index);
  }

  Future cleanData() async {
    //clears all the data stored
    await box.clear();
  }

  addName(String name) async {
    //adds the name into sharedpreferences for future use
    preferences = await SharedPreferences.getInstance();
    preferences.setString('name', name);
  }

  getName() async {
    //returns username from shared preferences
    preferences = await SharedPreferences.getInstance();
    return preferences.getString('name');
  }
}
