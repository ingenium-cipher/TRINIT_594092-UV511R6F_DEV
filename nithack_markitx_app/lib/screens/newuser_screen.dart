import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:nithack_marketx_app/model/new_user_model.dart';
import 'package:nithack_marketx_app/utilities/assets_name.dart';

import '../utilities/styles/textstyles.dart';

class NewUserScreen extends StatefulWidget {
  NewUserScreen({Key? key}) : super(key: key);

  @override
  State<NewUserScreen> createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  String dropdownvalue = 'Gender';
  String dropdownvalue2 = 'States';
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  var items2 = [
    "States",
    "Andhra Pradesh",
    "Arunachal Pradesh ",
    "Assam",
    "Bihar",
    "Chhattisgarh",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jammu and Kashmir",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal",
    "Andaman and Nicobar Islands",
    "Chandigarh",
    "Dadra and Nagar Haveli",
    "Daman and Diu",
    "Lakshadweep",
    "National Capital Territory of Delhi",
    "Puducherry"
  ];

  // List of items in our dropdown menu
  var items = [
    'Gender',
    'Male',
    'Female',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff181a20),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              PngAssets.design1,
              scale: 0.2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'marketX',
                style: w600.size28.copyWith(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      labelText: 'Name',
                      hintText: 'Enter name',
                      hintStyle: w700.size15.colorWhite,
                      labelStyle: w700.size15.colorWhite,
                    ),
                    style: w600.size15.colorWhite,
                  ),
                ),
                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      labelText: 'Phone No.',
                      hintText: 'Enter phone no.',
                      hintStyle: w700.size15.colorWhite,
                      labelStyle: w700.size15.colorWhite,
                    ),
                    keyboardType: TextInputType.number,
                    style: w600.size15.colorWhite,
                    maxLength: 10,
                  ),
                ),
                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      labelText: 'Email',
                      hintText: 'Enter email',
                      hintStyle: w700.size15.colorWhite,
                      labelStyle: w700.size15.colorWhite,
                    ),
                    style: w600.size15.colorWhite,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: DropdownButton(
                      // Initial Value
                      value: dropdownvalue,
                      dropdownColor: Colors.black,

                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),

                      // Array list of items
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(
                            items,
                            style: w600.size15.colorWhite,
                          ),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: TextField(
                    controller: ageController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      labelText: 'Age',
                      hintText: 'Enter age',
                      hintStyle: w700.size15.colorWhite,
                      labelStyle: w700.size15.colorWhite,
                    ),
                    style: w600.size15.colorWhite,
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: DropdownButton(
                      // Initial Value
                      value: dropdownvalue2,
                      dropdownColor: Colors.black,

                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),

                      // Array list of items
                      items: items2.map((String items2) {
                        return DropdownMenuItem(
                          value: items2,
                          child: Text(
                            items2,
                            style: w600.size15.colorWhite,
                          ),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue2 = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: GestureDetector(
                    onTap: () async {
                      if (nameController.text != '' &&
                          ageController.text != '' &&
                          phoneController.text != '' &&
                          emailController != '' &&
                          dropdownvalue != 'Gender' &&
                          dropdownvalue2 != 'States') {
                        NewUserModel newUser = NewUserModel(
                          age: int.parse(ageController.text),
                          email: emailController.text,
                          gender: dropdownvalue,
                          name: nameController.text,
                          phoneNumber: int.parse(phoneController.text),
                          state: dropdownvalue2,
                        );
                        final String baseUrl = 'http://43.205.196.71/';
                        Client client = Client();
                        print(newUser.toJson().toString());
                        var res = await client.post(
                          Uri.parse(baseUrl + 'users/'),
                          headers: {
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                          body: json.encode(newUser.toJson()),
                        );
                        print(res.body);
                        if (res.statusCode != 200) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(res.body),
                            duration:
                                const Duration(seconds: 2, milliseconds: 500),
                          ));
                        } else {
                          Fluttertoast.showToast(
                              msg: 'User registered successfully');
                          Navigator.pop(context);
                        }

                        // List data = jsonDecode(res.body);
                        // print(data);
                        // plotPoints = [];
                        // data.forEach((element) {
                        //   plotPoints.add(PersonModel.fromJson(element));
                        // });
                        // chartData.clear();
                        // plotPoints.forEach((element) {
                        //   chartData.add(ChartData(
                        //       element.coordinates!.x!,
                        //       element.coordinates!.y!,
                        //       arrayColor[element.cluster!]));
                        // });
                        // setState(() {
                        //   print('i was called');
                        // });
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Some field might be empty');
                      }
                    },
                    child: Container(
                      height: 45,
                      width: 300,
                      decoration: BoxDecoration(
                          color: const Color(0xff4d5dfa),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          'Register',
                          style: w700.size15.colorWhite,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 45,
                      width: 300,
                      decoration: BoxDecoration(
                          color: const Color(0xff4d5dfa),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          'Go back',
                          style: w700.size15.colorWhite,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
