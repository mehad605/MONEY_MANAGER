import 'dart:ffi';

import 'package:MONEY_MANAGER/controllers/db_helper.dart';
import 'package:MONEY_MANAGER/pages/add_transaction.dart';
import 'package:MONEY_MANAGER/pages/models/transaction.dart';
import 'package:MONEY_MANAGER/pages/settings.dart';
import 'package:MONEY_MANAGER/pages/widgets/confirm_dialog.dart';
import 'package:MONEY_MANAGER/pages/widgets/info_snackbar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MONEY_MANAGER/static.dart' as Static;
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
//imports all necessary components

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //all the vaiables that are going to be used laer on
  late Box box;
  late SharedPreferences preferences;
  DbHelper dbHelper = DbHelper();
  Map? data;
  int totalBalance = 0;
  int totalIncome = 0;
  int totalExpense = 0;
  int count = 0;
  //expenses subcategories total
  int transport = 0;
  int food = 0;
  int rent = 0;
  int education = 0;
  int other = 0;
  int repairs = 0;
  //income subcategoris total
  int salary = 0;
  int gift = 0;
  int interest = 0;
  int prize_money = 0;
  int others = 0;

  //variables to control graph
  bool curveGraph = true;
  bool graphBorder = false;
  bool showAll = true;
  String types = "All";
  //data for graph or chart and also date and time
  List<FlSpot> dataSet = [];
  DateTime today = DateTime.now();
  DateTime now = DateTime.now();
  int index = 1;
  int date_count = 0;
  //a list to show date in a formatted way instead of 22-11-2022
  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  @override
  void initState() {
    //to use hive
    super.initState();
    getPreference();
    box = Hive.box('money');
    fetch();
  }

  getPreference() async {
    //for shared preferences
    preferences = await SharedPreferences.getInstance();
  }

  Future<List<TransactionModel>> fetch() async {
    if (box.values.isEmpty) {
      return Future.value([]);
    } else {
      // return Future.value(box.toMap());
      List<TransactionModel> items = [];
      box.toMap().values.forEach((element) {
        // print(element);
        items.add(
          TransactionModel(element['amount'] as int, element['note'],
              element['date'] as DateTime, element['type'], element['subtype']),
        );
      });
      return items;
    }
  }

  List<TransactionModel> getSortedModel(List<TransactionModel> entireData) {
    List<TransactionModel> tempdataSet = [];

    for (TransactionModel item in entireData) {
      if (item.date.month == today.month) {
        tempdataSet.add(item);
      }
    }
    // Sorting the list as per the date
    //(after sorting) i need to find someway to add expenses of same dates together and remove other duplicates.
    tempdataSet.sort((a, b) => b.date.day.compareTo(a.date.day));
    date_count = 0;
    for (var i = 0; i < tempdataSet.length; i++) {
      if (i == 0) date_count = 0;
      if (tempdataSet[i].date.day != tempdataSet[0].date.day) date_count++;
    }
    return tempdataSet;
  }

  List<FlSpot> getPlotPoints(List<TransactionModel> entireData) {
    dataSet = [];
    List<TransactionModel> tempdataSet = [];

    for (TransactionModel item in entireData) {
      if (item.date.month == today.month && item.type == "Expense") {
        tempdataSet.add(item);
      }
    }
    // Sorting the list as per the date
    tempdataSet.sort((a, b) => a.date.day.compareTo(b.date.day));
    date_count = 0;
    for (var i = 0; i < tempdataSet.length; i++) {
      if (i == 0) date_count = 0;
      if (tempdataSet[i].date.day != tempdataSet[0].date.day) date_count++;
    }

    num d = 0;
    DateTime x = today;

    Map<int, double> chartData = Map();
    for (var element in tempdataSet) {
      //adds up the expences and income of a particular day
      num amount = 0;
      int day = 0;
      amount = element.amount;
      day = element.date.day;
      chartData.update(
        day,
        (value) => value + amount.toDouble(),
        ifAbsent: () => amount.toDouble(),
      );
    }
    chartData.forEach((key, value) {
      dataSet.add(FlSpot(key.toDouble(), value.toDouble()));
    });

    return dataSet;
  }

  getTotalBalance(List<TransactionModel> entireData) {
    //adds up all expenses for each respective subcategories
    totalBalance = 0;
    totalIncome = 0;
    totalExpense = 0;
    transport = 0;
    food = 0;
    rent = 0;
    education = 0;
    other = 0;
    repairs = 0;
    salary = 0;
    gift = 0;
    interest = 0;
    prize_money = 0;
    others = 0;
    for (TransactionModel data in entireData) {
      if (data.date.month == today.month) {
        if (data.type == "Income") {
          totalBalance += data.amount;
          totalIncome += data.amount;
          if (data.subtype == "Salary")
            salary += data.amount;
          else if (data.subtype == "Gift")
            gift += data.amount;
          else if (data.subtype == "Prize money")
            prize_money += data.amount;
          else if (data.subtype == "Interest")
            interest += data.amount;
          else if (data.subtype == "Other") others += data.amount;
        } else {
          totalBalance -= data.amount;
          totalExpense += data.amount;
          if (data.subtype == "Food")
            food += data.amount;
          else if (data.subtype == "Rent")
            rent += data.amount;
          else if (data.subtype == "Transport")
            transport += data.amount;
          else if (data.subtype == "Education")
            education += data.amount;
          else if (data.subtype == "Repairs")
            repairs += data.amount;
          else if (data.subtype == "Other") other += data.amount;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //returns scaffold that contains everything of homepage
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerFloat, //centers floating action button
      floatingActionButton: FloatingActionButton(
        //directs to AddTransaction page on pressed
        onPressed: () {
          Navigator.of(context)
              .push(
            CupertinoPageRoute(
              builder: (context) => AddTransaction(),
            ),
          )
              .whenComplete(() {
            setState(() {});
          });
        },
        backgroundColor: Static.PrimaryMaterialColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Icon(
          Icons.add,
          size: 32.0,
        ),
      ),
      body: FutureBuilder<List<TransactionModel>>(
        future: fetch(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              //shows error message if data is something unexpected or if other errors are present
              child: Text(
                "Oopssss !!! There is some error !",
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            );
          }
          if (snapshot.hasData) {
            //calls upon two function and also contains the other datas that are to be showed
            getTotalBalance(snapshot.data!);
            getPlotPoints(snapshot.data!);
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(
                    12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //shows a default photo for user
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                32.0,
                              ),
                              border: Border.all(),
                              color: Colors.blue[200],
                            ),
                            child: CircleAvatar(
                              maxRadius: 32.0,
                              child: Image.asset(
                                "assets/face.png",
                                width: 64.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            //shows a welcome message for user
                            "Welcome, ${preferences.getString('name')}",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700,
                              color: Static.PrimaryMaterialColor[800],
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                      Container(
                        //contains the settings icon
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ),
                          color: Colors.white70,
                        ),
                        padding: EdgeInsets.all(
                          12.0,
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => Settings(),
                              ),
                            )
                                .then((value) {
                              setState(() {});
                            });
                          },
                          child: Icon(
                            Icons.settings,
                            size: 32.0,
                            color: Color(0xff3E454C),
                          ),
                        ),
                      ), //may need to edit inkwell to iconbutton
                    ],
                  ),
                ),
                selectMonth(), //the select month function is called which is defined below and allows user to select from the recent three months

                Container(
                  //sets the background color and size of the area that contains users current money and also shows the total expenses and income of that month
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.all(
                    12.0,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Static.PrimaryMaterialColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          24.0,
                        ),
                      ),
                      border: Border.all(),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            24.0,
                          ),
                        ),
                        //border: Border.all()
                        // color: Static.PrimaryColor,
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        vertical: 18.0,
                        horizontal: 9.0,
                      ),
                      child: Column(
                        children: [
                          //creates the circular area around the toal balance section
                          CircleAvatar(
                            backgroundColor: Colors.blue[100],
                            radius: MediaQuery.of(context).size.width / 3.8,
                            child: CircleAvatar(
                              backgroundColor: Static.PrimaryColor,
                              radius:
                                  MediaQuery.of(context).size.width / 3.8 - 10,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Total Balance',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      // fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  Text(
                                    'BDT $totalBalance',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            // shows the toatal expense and total income of a specific month
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                cardIncome(
                                  totalIncome.toString(),
                                ),
                                cardExpense(
                                  totalExpense.toString(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  //shows the current month or the selected month
                  padding: const EdgeInsets.all(
                    12.0,
                  ),
                  child: Text(
                    "${months[today.month - 1]} ${today.year}",
                    style: TextStyle(
                      fontSize: 32.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      //shows a switch that allows the graph to be curved or a stright line graph
                      children: [
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          'Curve',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Switch(
                          value: curveGraph,
                          onChanged: (bool newValue) {
                            setState(() {
                              curveGraph = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                date_count < 1 //checks if there is only data on a single date
                    //if so then says that there is not enough data to draw a graph
                    //otherwise shows a graph
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 40.0,
                          horizontal: 20.0,
                        ),
                        margin: EdgeInsets.all(
                          12.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            8.0,
                          ),
                          border: Border.all(),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Text(
                          "Not Enough Data to render Chart",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      )
                    : Container(
                        height: 400.0,
                        padding: EdgeInsets.symmetric(
                          vertical: 40.0,
                          horizontal: 12.0,
                        ),
                        margin: EdgeInsets.all(
                          12.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          border: Border.all(),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: LineChart(
                          LineChartData(
                            borderData: FlBorderData(
                              show: graphBorder, //shows box around the graph
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: getPlotPoints(snapshot.data!),
                                isCurved: curveGraph, //curve the graph
                                // preventCurveOverShooting: false,
                                barWidth: 3.0,
                                colors: [
                                  Static.PrimaryMaterialColor,
                                ],

                                showingIndicators: [200, 200, 90, 10],
                                dotData: FlDotData(
                                  show: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                Padding(
                  //shows a text saying Transaction
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Transactions",
                    style: TextStyle(
                      fontSize: 32.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                //here choice chip option is implemented so that user can see all the transaction or see it as a categorised verson
                //this allows the user to get an idea where most of the expense is happening
                Row(
                  children: [
                    SizedBox(
                      width: 12,
                    ),
                    ChoiceChip(
                      label: Text(
                        "All",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: types == "All" ? Colors.white : Colors.black,
                        ),
                      ),
                      selectedColor: Static.PrimaryMaterialColor,
                      selected: types == "All" ? true : false,
                      onSelected: (val) {
                        if (val) {
                          setState(() {
                            types = "All";
                          });
                        }
                      },
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    ChoiceChip(
                      label: Text(
                        "Categorised",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: types == "Categorised"
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      selectedColor: Static.PrimaryMaterialColor,
                      selected: types == "Categorised" ? true : false,
                      onSelected: (val) {
                        if (val) {
                          setState(() {
                            types = "Categorised";
                          });
                        }
                      },
                    ),
                  ],
                ),
                if (types ==
                    "All") //if user chooses all then a listview of all transactions will be given
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length + 1,
                    itemBuilder: (context, index) {
                      TransactionModel dataAtIndex;
                      try {
                        dataAtIndex = snapshot.data![index];
                      } catch (e) {
                        // deletes that key and value,
                        // hence makign it null here., as we still build on the length.
                        return Container();
                      }

                      if (dataAtIndex.date.month == today.month) {
                        //here transaction is shown in different types depending if it is of type income or expense
                        if (dataAtIndex.type == "Income") {
                          return incomeTile(
                            dataAtIndex.amount,
                            dataAtIndex.note,
                            dataAtIndex.date,
                            index,
                          );
                        } else {
                          return expenseTile(
                            dataAtIndex.amount,
                            dataAtIndex.note,
                            dataAtIndex.date,
                            index,
                          );
                        }
                      } else {
                        return Container();
                      }
                    },
                  ),
                if (types == "Categorised")
                  //shows expense based on category if user chooses this option
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 12,
                    itemBuilder: (context, count) {
                      if (count == 0) {
                        return categorytile("Food", food, count);
                      } else if (count == 1) {
                        return categorytile("Transportation", transport, count);
                      } else if (count == 2) {
                        return categorytile("Rent", rent, count);
                      } else if (count == 3) {
                        return categorytile("Education", education, count);
                      } else if (count == 4) {
                        return categorytile("Repairs", repairs, count);
                      } else if (count == 5) {
                        return categorytile("Others", other, count);
                      } else if (count == 6) {
                        return categorytile("Salary", salary, count);
                      } else if (count == 7) {
                        return categorytile("Gift", gift, count);
                      } else if (count == 8) {
                        return categorytile("Interest", interest, count);
                      } else if (count == 9) {
                        return categorytile("Prize Money", prize_money, count);
                      } else if (count == 10) {
                        return categorytile("Ohters", others, count);
                      } else {
                        return Container();
                      }
                    },
                  ),

                //
                SizedBox(
                  height: 60.0,
                ),
              ],
            );
          } else {
            return Text(
              "Loading...",
            );
          }
        },
      ),
    );
  }

//
//
//
// Widget
//
//

  Widget cardIncome(String value) {
    //crating a card for income type transactions
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(
              20.0,
            ),
          ),
          padding: EdgeInsets.all(
            6.0,
          ),
          child: Icon(
            Icons.arrow_downward,
            size: 28.0,
            //color: Colors.green[700],
            color: Colors.blue,
          ),
          margin: EdgeInsets.only(
            right: 8.0,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Income",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white70,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget cardExpense(String value) {
    //crating a card for expense type transactions
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(
              20.0,
            ),
          ),
          padding: EdgeInsets.all(
            6.0,
          ),
          child: Icon(
            Icons.arrow_upward,
            size: 28.0,
            //color: Colors.red[700],
            color: Colors.blue,
          ),
          margin: EdgeInsets.only(
            right: 8.0,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Expense",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white70,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget expenseTile(int value, String note, DateTime date, int index) {
    //creates the actual placeholder where the related information abot a expense type transaction is shoed
    return InkWell(
      splashColor: Static.PrimaryMaterialColor[400],
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          deleteInfoSnackBar,
        );
      },
      onLongPress: () async {
        //shows a confirmation message before deletion
        bool? answer = await showConfirmDialog(
          context,
          "WARNING",
          "This will delete this record. This action is irreversible. Do you want to continue ?",
        );
        if (answer != null && answer) {
          await dbHelper.deleteData(index);
          setState(() {});
        }
      },
      child: Container(
        padding: const EdgeInsets.all(18.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(
            8.0,
          ),
          border: Border.all(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.arrow_circle_up_outlined,
                          size: 28.0,
                          color: Colors.red[700],
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        Text(
                          "Expense",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),

                    //
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        "${date.day} ${months[date.month - 1]} ",
                        style: TextStyle(
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "- $value",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    //
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        note,
                        style: TextStyle(
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget incomeTile(int value, String note, DateTime date, int index) {
    //creates the actual placeholder where the related information abot a Income type transaction is shoed
    return InkWell(
      splashColor: Static.PrimaryMaterialColor[400],
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          deleteInfoSnackBar,
        );
      },
      onLongPress: () async {
        bool? answer = await showConfirmDialog(
          context,
          "WARNING",
          "This will delete this record. This action is irreversible. Do you want to continue ?",
        );

        if (answer != null && answer) {
          await dbHelper.deleteData(index);
          setState(() {});
        }
      },
      child: Container(
        padding: const EdgeInsets.all(18.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(
            8.0,
          ),
          border: Border.all(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.arrow_circle_down_outlined,
                      size: 28.0,
                      color: Colors.green[700],
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "Income",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
                //
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    "${date.day} ${months[date.month - 1]} ",
                    style: TextStyle(
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                //
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "+ $value",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                //
                //
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    note,
                    style: TextStyle(
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

//the function which was called above to select the month
//this funcition allows the user to select form the recent three months
//thereby they can see transactions of recent 3 months
  Widget selectMonth() {
    return Padding(
      padding: EdgeInsets.all(
        8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                index =
                    3; //index helps to keep tack of which month was selected
                today = DateTime(now.year, now.month - 2, today.day);
              });
            },
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
                border: Border.all(),
                color:
                    index == 3 ? Static.PrimaryMaterialColor : Colors.blue[50],
              ),
              alignment: Alignment.center,
              child: Text(
                months[now.month - 3],
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color:
                      index == 3 ? Colors.white : Static.PrimaryMaterialColor,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                index = 2;
                today = DateTime(now.year, now.month - 1, today.day);
              });
            },
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
                border: Border.all(),
                color:
                    index == 2 ? Static.PrimaryMaterialColor : Colors.blue[50],
              ),
              alignment: Alignment.center,
              child: Text(
                months[now.month - 2],
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color:
                      index == 2 ? Colors.white : Static.PrimaryMaterialColor,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                index = 1;
                today = DateTime.now();
              });
            },
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
                border: Border.all(),
                color:
                    index == 1 ? Static.PrimaryMaterialColor : Colors.blue[50],
              ),
              alignment: Alignment.center,
              child: Text(
                months[now.month - 1],
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color:
                      index == 1 ? Colors.white : Static.PrimaryMaterialColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//this part is created to show the information when user selects teh categorised option under the Transaction text
  Widget categorytile(String category, int value, int count) {
    return InkWell(
      splashColor: Static.PrimaryMaterialColor[400],
      child: Container(
        padding: const EdgeInsets.all(18.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(
            8.0,
          ),
          border: Border.all(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        if (count >= 0 && count <= 5)
                          Icon(
                            Icons.arrow_circle_up_outlined,
                            size: 28.0,
                            color: Colors.red[
                                700], //color and icon for expense type subcategory
                          ),
                        if (count > 5)
                          Icon(
                            Icons.arrow_circle_down_outlined,
                            size: 28.0,
                            color: Colors.green[
                                700], //color and icon for income type subcategory
                          ),
                        SizedBox(
                          width: 4.0,
                        ),
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),

                    //
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      " $value",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    //
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
