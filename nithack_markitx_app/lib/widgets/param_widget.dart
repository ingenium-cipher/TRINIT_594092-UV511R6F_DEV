import 'package:flutter/material.dart';

import '../utilities/styles/textstyles.dart';

class ParameterWidget extends StatefulWidget {
  Color bgColor;
  Color logoColor;
  String logo;
  String paramName;
  Function() onTap;
  bool isCheck;
  ParameterWidget(
      {super.key,
      required this.bgColor,
      required this.logoColor,
      required this.logo,
      required this.paramName,
      required this.onTap,
      required this.isCheck});

  @override
  State<ParameterWidget> createState() => _ParameterWidgetState();
}

class _ParameterWidgetState extends State<ParameterWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        //color: Color(0xff5b2e62),
        width: 150,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: 60,
                color: widget.logoColor,
                child: Image.asset(widget.logo),
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                  child: widget.isCheck == false
                      ? Text(
                          widget.paramName,
                          style: w400.size20.colorWhite,
                        )
                      : Text(
                          '${widget.paramName}✅',
                          style: w400.size20.colorWhite,
                        )),
            ),
          ],
        ),
      ),
    );
  }
}
