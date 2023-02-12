import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

import '../utilities/assets_name.dart';
import '../utilities/styles/textstyles.dart';

class SearchUserProfileScreen extends StatefulWidget {
  SearchUserProfileScreen({Key? key}) : super(key: key);

  @override
  State<SearchUserProfileScreen> createState() =>
      _SearchUserProfileScreenState();
}

class _SearchUserProfileScreenState extends State<SearchUserProfileScreen> {
  final Client client = Client();
  final String baseUrl = 'http://43.205.196.71/';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  bool isVisible = false;
  List data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff181a20),
      body: ListView(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              PngAssets.design2,
              scale: 0.2,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
            ),
          ),
          const SizedBox(
            height: 35,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: GestureDetector(
              onTap: () async {
                // Navigator.pop(context);
                if (nameController.text.isEmpty || ageController.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: 'Either name or age field is empty.');
                } else {
                  String extraUrl =
                      'users/search?name=${nameController.text}&age=${ageController.text}';
                  var res = await client.get(Uri.parse(baseUrl + extraUrl));
                  print(res.body);
                  print(res.body.length);
                  if (res.body.length > 2) {
                    setState(() {
                      isVisible = true;
                    });
                    print(data);
                    setState(() {
                      data = jsonDecode(res.body);
                      print("data length is ${data.length}");
                    });
                  } else {
                    Fluttertoast.showToast(msg: 'No user found.');
                  }
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
                    'Search',
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
              onTap: () {
                Navigator.pop(context);
              },
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
          data.length == 0
              ? Container()
              : Visibility(
                  visible: isVisible,
                  child: Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        print("table was made");
                        return Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          // width: double.maxFinite,
                          width: 300,
                          decoration: BoxDecoration(
                            color: Color(0xff08348A),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Table(
                            border: TableBorder.all(
                              color: Colors.white,
                            ),
                            children: [
                              TableRow(
                                children: [
                                  Text(
                                    'Name',
                                    style: w400.size14.colorWhite,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(data[index]['name'] ?? 'null',
                                      textAlign: TextAlign.center,
                                      style: w400.size14.colorWhite),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Text(
                                    'Age',
                                    style: w400.size14.colorWhite,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(data[index]['age'].toString(),
                                      textAlign: TextAlign.center,
                                      style: w400.size14.colorWhite),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Text(
                                    'Gender',
                                    style: w400.size14.colorWhite,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(data[index]['gender'] ?? 'null',
                                      textAlign: TextAlign.center,
                                      style: w400.size14.colorWhite),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Text(
                                    'State',
                                    style: w400.size14.colorWhite,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(data[index]['state'] ?? 'null',
                                      textAlign: TextAlign.center,
                                      style: w400.size14.colorWhite),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Text(
                                    'Phone number',
                                    style: w400.size14.colorWhite,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(data[index]['phone_number'].toString(),
                                      textAlign: TextAlign.center,
                                      style: w400.size14.colorWhite),
                                ],
                              ),
                              // TableRow(
                              //   children: [
                              //     Text(
                              //       'Email',
                              //       style: w400.size14.colorWhite,
                              //       textAlign: TextAlign.center,
                              //     ),
                              //     Text(
                              //       plotPoints[displayIndex].email ?? 'null',
                              //       textAlign: TextAlign.center,
                              //       style: w400.size14.colorWhite,
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        );
                      },
                    ),
                    // Text(
                    //   displayIndex == -1 ? '':
                    //   plotPoints[displayIndex].name!,
                    //   style: w400.size18.colorWhite,
                    // ),
                  ),
                ),
        ],
      ),
    );
  }
}
