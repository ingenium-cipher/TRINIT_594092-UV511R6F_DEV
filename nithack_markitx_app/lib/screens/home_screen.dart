import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nithack_marketx_app/model/person_model.dart';
import 'package:nithack_marketx_app/utilities/assets_name.dart';
import 'package:nithack_marketx_app/widgets/param_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/chart_data_model.dart';
import '../utilities/styles/textstyles.dart';
import 'newuser_screen.dart';
import 'search_user_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool check1 = false, check2 = false, check3 = false, check4 = false;
  final Client client = Client();
  final String baseUrl = 'http://43.205.196.71/';
  List<PersonModel> plotPoints = [];
  List<String> params = [];
  int displayIndex = -1;
  Future apiCall() async {
    String extraUrl = 'clusters/?parameters=';
    if (params.length == 0) {
      setState(() {
        chartData = [];
      });
      return;
    }
    for (int i = 0; i < params.length; i++) {
      if (i == 0) {
        extraUrl += params[0];
      } else {
        extraUrl += ',${params[i]}';
      }
    }
    print(extraUrl);
    var res = await client.get(Uri.parse(baseUrl + extraUrl));
    print(res.body);
    List data = jsonDecode(res.body);
    print(data);
    plotPoints = [];
    data.forEach((element) {
      plotPoints.add(PersonModel.fromJson(element));
    });
    chartData.clear();
    plotPoints.forEach((element) {
      chartData.add(ChartData(element.coordinates!.x!, element.coordinates!.y!,
          arrayColor[element.cluster!]));
    });
    setState(() {
      print('i was called');
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // await apiCall();
    });
    // params = ['age'];
    arrayColor = [
      const Color(0xff800000),
      const Color(0xfffabed4),
      const Color(0xffffe119),
      const Color(0xff3cb44b),
      const Color(0xff000075),
      const Color(0xff911eb4),
      const Color(0xfff58321),
      const Color(0xffaaffc3),
      const Color(0xfff032e6),
      const Color(0xff42d4f4),
      const Color(0xff808000),
    ];
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  late List<Color> arrayColor;
  List<ChartData> chartData = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff181a20),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Parameters',
                  style: w600.size24.colorWhite,
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ParameterWidget(
                      bgColor: const Color(0xff5b2e62),
                      logo: PngAssets.age,
                      logoColor: const Color(0x150054d2),
                      paramName: 'Age',
                      isCheck: check1,
                      onTap: () {
                        if (check1) {
                          params.remove('age');
                          check1 = false;
                        } else {
                          check4 = false;
                          params.remove('state');
                          params.add('age');
                          check1 = true;
                        }
                        setState(() {
                          apiCall();
                        });
                      },
                    ),
                    ParameterWidget(
                      bgColor: const Color(0xff2e624c),
                      logo: PngAssets.gender,
                      logoColor: const Color(0x1500d2d2),
                      paramName: 'Gender',
                      isCheck: check2,
                      onTap: () {
                        if (check2) {
                          params.remove('gender');
                          check2 = false;
                        } else {
                          check4 = false;
                          params.remove('state');
                          params.add('gender');
                          check2 = true;
                        }
                        setState(() {
                          apiCall();
                        });
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ParameterWidget(
                      bgColor: const Color(0xff5e622e),
                      logo: PngAssets.name,
                      logoColor: const Color(0x1570ff00),
                      paramName: 'Name',
                      isCheck: check3,
                      onTap: () {
                        if (check3) {
                          params.remove('name');
                          check3 = false;
                        } else {
                          check4 = false;
                          params.remove('state');
                          params.add('name');
                          check3 = true;
                        }
                        setState(() async {
                          apiCall();
                        });
                      },
                    ),
                    ParameterWidget(
                      bgColor: const Color(0xff330611),
                      logo: PngAssets.state,
                      logoColor: const Color(0x15d200bd),
                      paramName: 'State',
                      isCheck: check4,
                      onTap: () async {
                        if (check4) {
                          params.remove('state');
                          check4 = false;
                        } else {
                          check1 = false;
                          check2 = false;
                          check3 = false;
                          params = [];
                          params.add('state');
                          check4 = true;
                        }
                        var res = await client
                            .get(Uri.parse('${baseUrl}clusters/state'));
                        print(res.body);
                        List data = jsonDecode(res.body);
                        print(data);
                        plotPoints = [];
                        chartData.clear();
                        data.forEach((element) {
                          chartData.add(
                            ChartData(
                              (element['x'] + 0.0),
                              (element['y'] + 0.0),
                              arrayColor[1],
                            ),
                          );
                          // plotPoints.add(PersonModel.fromJson(element));
                        });
                        // plotPoints.forEach((element) {
                        //   chartData.add(ChartData(
                        //       element.coordinates!.x!,
                        //       element.coordinates!.y!,
                        //       arrayColor[element.cluster!]));
                        // });
                        setState(() {
                          print('i was called');
                        });
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Data Clusters',
                  style: w600.size24.colorWhite,
                ),
                const SizedBox(
                  height: 10,
                ),
                SfCartesianChart(
                  series: <ChartSeries>[
                    check4
                        ? LineSeries<ChartData, double>(
                            dataSource: chartData,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            pointColorMapper: (ChartData data, _) => data.color,
                            markerSettings: const MarkerSettings(
                                height: 1,
                                width: 1,
                                // Scatter will render in diamond shape
                                shape: DataMarkerType.diamond),
                          )
                        : ScatterSeries<ChartData, double>(
                            dataSource: chartData,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            pointColorMapper: (ChartData data, _) => data.color,
                            markerSettings: const MarkerSettings(
                                height: 8,
                                width: 8,
                                // Scatter will render in diamond shape
                                shape: DataMarkerType.diamond),
                            onPointTap: (pointInteractionDetails) {
                              setState(() {
                                displayIndex =
                                    pointInteractionDetails.pointIndex!;
                              });
                            },
                          )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                displayIndex == -1
                    ? Container()
                    : Visibility(
                        visible: displayIndex == -1 ? false : true,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
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
                                      Text(
                                          plotPoints[displayIndex].name ??
                                              'null',
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
                                      Text(
                                          plotPoints[displayIndex]
                                              .age
                                              .toString(),
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
                                      Text(
                                          plotPoints[displayIndex].gender ??
                                              'null',
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
                                      Text(
                                          plotPoints[displayIndex].state ??
                                              'null',
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
                                      Text(
                                          plotPoints[displayIndex]
                                              .phoneNumber
                                              .toString(),
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
                              // Text(
                              //   displayIndex == -1 ? '':
                              //   plotPoints[displayIndex].name!,
                              //   style: w400.size18.colorWhite,
                              // ),
                            ),
                          ],
                        ),
                      ),
                SizedBox(
                  height: 10,
                ),
                displayIndex == -1
                    ? Container()
                    : Visibility(
                        visible: displayIndex == -1 ? false : true,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            GestureDetector(
                              onTap: () {
                                launch(
                                    '${baseUrl}clusters/${plotPoints[displayIndex].cluster}/csv');
                                print(
                                    '${baseUrl}clusters/${plotPoints[displayIndex].cluster}/csv');
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                // width: double.maxFinite,
                                width: 300,
                                decoration: BoxDecoration(
                                  color: Color(0xff08348A),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  "Download",
                                  style: w400.size14.colorWhite,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: const Color(0xff181a20),
          child: SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'More Services',
                    style: w600.size24.colorWhite,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SearchUserProfileScreen()));
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color(0xff08348A),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          height: 45,
                          width: 150,
                          child: Center(
                            child: Text(
                              'Search User Profile',
                              style: w400.size14.colorWhite,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            displayIndex = -1;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewUserScreen()));
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color(0xff08348A),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          height: 45,
                          width: 150,
                          child: Center(
                            child: Text(
                              'Add New User',
                              style: w400.size14.colorWhite,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
