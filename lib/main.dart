import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Widget/TextFiled.dart';
import 'model/data_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: StoreData(),
    );
  }
}

class StoreData extends StatefulWidget {
  const StoreData({Key? key}) : super(key: key);

  @override
  _StoreDataState createState() => _StoreDataState();
}

class _StoreDataState extends State<StoreData> {
  List totalData = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _phoneNumberController =
      new TextEditingController();

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    final SharedPreferences dataStore = await SharedPreferences.getInstance();
    // dataStore.clear();
    var data = dataStore.getString("dataStore");
    if (data != null && data.isNotEmpty) {
      totalData = jsonDecode(data);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Project"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Card(
                elevation: 3,
                child: TextFormField(
                  autofocus: false,

                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Name',
                  ),
                  keyboardType: TextInputType.text,
                  validator: validateName,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Card(
                elevation: 3,
                child: TextFormField(

                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Phone Number',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: validateMobile,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => submit(_nameController, _phoneNumberController),
              child: Text("Save"),
            ),
            totalData.length == 0
                ? Center(child: Text(""))
                : Expanded(
                    child: ListView.builder(
                      // future: totalData,
                      itemCount: totalData.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(

                            child: Column(
                              children: [
                                Text(totalData[index]['userName'] ?? ''),
                                Text(totalData[index]["number"] ?? ''),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  submit(name, number) async {
    if (_formKey.currentState!.validate()) {
      final SharedPreferences dataStore = await SharedPreferences.getInstance();

      if (totalData.isNotEmpty) {
        var contain = totalData.where((element) =>
            element['userName'].toLowerCase() ==
            _nameController.text.trim().toLowerCase());
        if (contain.isEmpty) {
          //value not exists
          totalData.add(DataModel(
              userName: name.text.trim(), number: number.text.trim()));

          dataStore.setString("dataStore", jsonEncode(totalData));
          getData();
          setState(() {});
          _phoneNumberController.clear();
          _nameController.clear();

        } else {
          //value exists
          final snackBar = SnackBar(
            content: const Text('User Name already exist!'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }


      } else {
        totalData.add(
            DataModel(userName: name.text.trim(), number: number.text.trim()));

        dataStore.setString("dataStore", jsonEncode(totalData));
        getData();
        setState(() {});
        _phoneNumberController.clear();
        _nameController.clear();
      }
    }
  }

  String? validateName(String? value) {
    if (value!.length < 1)
      return 'User Name required';
    else
      return null;
  }

  String? validateMobile(String? value) {
    if (value!.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }
}
