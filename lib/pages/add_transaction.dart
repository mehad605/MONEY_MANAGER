import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:MONEY_MANAGER/controllers/db_helper.dart';
import 'package:MONEY_MANAGER/static.dart' as Static;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({Key? key}) : super(key: key);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  //declaring variables to use later
  DateTime sdate = DateTime.now();
  int? amonunt;
  String types = "Income";
  String note = "Expence";
  String subtype = "Other";
//creates a list with first three letter of every month to show on date row
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: sdate,
        //defines the limit to from how early to how late the date can be
        firstDate: DateTime(1990, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != sdate) {
      setState(() {
        sdate = picked; //sets date
      });
    }
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      body: ListView(
        //creates a list view
        padding: EdgeInsets.all(12.0),
        children: [
          SizedBox(
            height: 20.0,
          ),
          Text(
            //title of the page
            "Add Transaction",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w700,
                color: Static.PrimaryMaterialColor),
          ),
          //
          SizedBox(
            //for spacing
            height: 20.0,
          ),
          Row(
            //creates a row to show related information next to each other
            //user enters ammount of money
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Static.PrimaryMaterialColor,
                    borderRadius: BorderRadius.circular(16.0)),
                padding: EdgeInsets.all(12.0),
                child: Icon(
                  Icons.attach_money,
                  size: 24.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "৳",
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                  onChanged: (val) {
                    try {
                      amonunt = int.parse(val);
                    } catch (e) {}
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ], //makes it so that only digits can be entered and no strings
                  keyboardType: TextInputType
                      .number, //makes the popup keyboard be a number keyboard
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
////////------------------------2nd row
          Row(
            //user gives notes on the expense or income
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Static.PrimaryMaterialColor,
                    borderRadius: BorderRadius.circular(16.0)),
                padding: EdgeInsets.all(12.0),
                child: Icon(
                  Icons.description,
                  size: 24.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Note on Transaction",
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                  onChanged: (val) {
                    note = val;
                  },
                ),
              ),
            ],
          ),

          SizedBox(
            height: 20.0,
          ),
//3rd row
          Row(
            //user selects if it is of type income or expense
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Static.PrimaryMaterialColor,
                    borderRadius: BorderRadius.circular(16.0)),
                padding: EdgeInsets.all(12.0),
                child: Icon(
                  Icons.moving_sharp,
                  size: 24.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 12.0,
              ),
              ChoiceChip(
                label: Text(
                  "Income",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: types == "Income" ? Colors.white : Colors.black,
                  ),
                ),
                selectedColor: Static.PrimaryMaterialColor,
                selected: types == "Income" ? true : false,
                onSelected: (val) {
                  if (val) {
                    setState(() {
                      types = "Income";
                      if (note.isEmpty || note == "Income") {
                        note = 'Income';
                      }
                    });
                  }
                },
              ),
              SizedBox(
                width: 12.0,
              ),
              ChoiceChip(
                label: Text(
                  "Expense",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: types == "Expense" ? Colors.white : Colors.black,
                  ),
                ),
                selectedColor: Static.PrimaryMaterialColor,
                selected: types == "Expense" ? true : false,
                onSelected: (val) {
                  if (val) {
                    setState(() {
                      types = "Expense";
                      if (note.isEmpty || note == "Expense") {
                        note = 'Expense';
                      }
                    });
                  }
                },
              ),
            ],
          ),

          //subtype
          SizedBox(
            height: 20.0,
          ),
          if (types == "Expense")
            Wrap(
              //gives sub categories according to users choice of expense of income
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Static.PrimaryMaterialColor,
                      borderRadius: BorderRadius.circular(16.0)),
                  padding: EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.subdirectory_arrow_right_sharp,
                    size: 24.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 12.0,
                ),
                ChoiceChip(
                  label: Text(
                    "Food",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: subtype == "Food" ? Colors.white : Colors.black,
                    ),
                  ),
                  selectedColor: Static.PrimaryMaterialColor,
                  selected: subtype == "Food" ? true : false,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        subtype = "Food";
                      });
                    }
                  },
                ),
                SizedBox(
                  width: 12.0,
                ),
                ChoiceChip(
                  label: Text(
                    "Transport",
                    style: TextStyle(
                      fontSize: 16.0,
                      color:
                          subtype == "Transport" ? Colors.white : Colors.black,
                    ),
                  ),
                  selectedColor: Static.PrimaryMaterialColor,
                  selected: subtype == "Transport" ? true : false,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        subtype = "Transport";
                      });
                    }
                  },
                ),
                SizedBox(
                  width: 12.0,
                ),
                ChoiceChip(
                  label: Text(
                    "Rent",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: subtype == "Rent" ? Colors.white : Colors.black,
                    ),
                  ),
                  selectedColor: Static.PrimaryMaterialColor,
                  selected: subtype == "Rent" ? true : false,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        subtype = "Rent";
                      });
                    }
                  },
                ),
                SizedBox(
                  width: 12,
                ),
                ChoiceChip(
                  label: Text(
                    "Education",
                    style: TextStyle(
                      fontSize: 16.0,
                      color:
                          subtype == "Education" ? Colors.white : Colors.black,
                    ),
                  ),
                  selectedColor: Static.PrimaryMaterialColor,
                  selected: subtype == "Education" ? true : false,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        subtype = "Education";
                      });
                    }
                  },
                ),
                SizedBox(
                  width: 12.0,
                ),
                ChoiceChip(
                  label: Text(
                    "Repairs",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: subtype == "Repairs" ? Colors.white : Colors.black,
                    ),
                  ),
                  selectedColor: Static.PrimaryMaterialColor,
                  selected: subtype == "Repairs" ? true : false,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        subtype = "Repairs";
                      });
                    }
                  },
                ),
                SizedBox(
                  width: 12.0,
                ),
                ChoiceChip(
                  label: Text(
                    "Other",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: subtype == "Other" ? Colors.white : Colors.black,
                    ),
                  ),
                  selectedColor: Static.PrimaryMaterialColor,
                  selected: subtype == "Other" ? true : false,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        subtype = "Other";
                      });
                    }
                  },
                ),
              ],
            ),
          if (types == "Income")
            Wrap(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Static.PrimaryMaterialColor,
                      borderRadius: BorderRadius.circular(16.0)),
                  padding: EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.subdirectory_arrow_right_sharp,
                    size: 24.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 12.0,
                ),
                ChoiceChip(
                  label: Text(
                    "Salary",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: subtype == "Salary" ? Colors.white : Colors.black,
                    ),
                  ),
                  selectedColor: Static.PrimaryMaterialColor,
                  selected: subtype == "Salary" ? true : false,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        subtype = "Salary";
                      });
                    }
                  },
                ),
                SizedBox(
                  width: 12.0,
                ),
                ChoiceChip(
                  label: Text(
                    "Gift",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: subtype == "Gift" ? Colors.white : Colors.black,
                    ),
                  ),
                  selectedColor: Static.PrimaryMaterialColor,
                  selected: subtype == "Gift" ? true : false,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        subtype = "Gift";
                      });
                    }
                  },
                ),
                SizedBox(
                  width: 12.0,
                ),
                ChoiceChip(
                  label: Text(
                    "Interest",
                    style: TextStyle(
                      fontSize: 16.0,
                      color:
                          subtype == "Interest" ? Colors.white : Colors.black,
                    ),
                  ),
                  selectedColor: Static.PrimaryMaterialColor,
                  selected: subtype == "Interest" ? true : false,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        subtype = "Interest";
                      });
                    }
                  },
                ),
                SizedBox(
                  width: 12,
                ),
                ChoiceChip(
                  label: Text(
                    "Prize money",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: subtype == "Prize money"
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  selectedColor: Static.PrimaryMaterialColor,
                  selected: subtype == "Prize money" ? true : false,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        subtype = "Prize money";
                      });
                    }
                  },
                ),
                SizedBox(
                  width: 12.0,
                ),
                ChoiceChip(
                  label: Text(
                    "Other",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: subtype == "Other" ? Colors.white : Colors.black,
                    ),
                  ),
                  selectedColor: Static.PrimaryMaterialColor,
                  selected: subtype == "Other" ? true : false,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        subtype = "Other";
                      });
                    }
                  },
                ),
              ],
            ),

          SizedBox(
            height: 20.0,
          ),
          SizedBox(
            height: 50.0,
            child: TextButton(
              onPressed: () {
                _selectDate(context); //gives option to select date
              },
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero)),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Static.PrimaryMaterialColor,
                      borderRadius: BorderRadius.circular(
                        16.0,
                      ),
                    ),
                    padding: EdgeInsets.all(
                      12.0,
                    ),
                    child: Icon(
                      Icons.date_range,
                      size: 24.0,
                      // color: Colors.grey[700],
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Text(
                    //shows the selected date of the user
                    "${sdate.day} ${months[sdate.month - 1]}",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(
            height: 20.0,
          ),

          SizedBox(
            height: 50.0,
            child: ElevatedButton(
              onPressed: () {
                if (amonunt != null) {
                  //if ammount is not null then adds the data in hive using addData function from db_helper.dart
                  DbHelper dbHelper = DbHelper();
                  dbHelper.addData(amonunt!, sdate, types, note, subtype);
                  Navigator.of(context).pop();
                } else {
                  //when the ammount is invalid asks user to give valid value
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red[700],
                      content: Text(
                        "Please enter a valid Amount !",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }
              },
              child: Text(
                "Add",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
