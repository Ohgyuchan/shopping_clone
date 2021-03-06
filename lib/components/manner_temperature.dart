import 'package:flutter/material.dart';

class MannerTemperature extends StatelessWidget {
  double mannerTemperature;
  late int level;
  MannerTemperature({Key? key, required this.mannerTemperature}) {
    _calcTempLevel();
  }

  void _calcTempLevel() {
    if (20 >= mannerTemperature) {
      level = 0;
    } else if (20 < mannerTemperature && 32 >= mannerTemperature) {
      level = 1;
    } else if (32 < mannerTemperature && 36.5 >= mannerTemperature) {
      level = 2;
    } else if (36.5 < mannerTemperature && 40 >= mannerTemperature) {
      level = 3;
    } else if (40 < mannerTemperature && 50 >= mannerTemperature) {
      level = 4;
    } else if (50 < mannerTemperature) {
      level = 5;
    }
  }

  final List<Color> tempPerColors = [
    Color(0xff072038),
    Color(0xff0d3a65),
    Color(0xff186ec0),
    Color(0xff37b24d),
    Color(0xffffad13),
    Color(0xfff76707),
  ];

  Widget _makeTempLabelAndBar() {
    return Container(
      width: 65,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "$mannerTemperature┬░C",
            style: TextStyle(
              color: tempPerColors[level],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 6,
              color: Colors.black.withOpacity(0.2),
              child: Row(
                children: [
                  Container(
                    height: 6,
                    width: 65 / 99 * mannerTemperature,
                    color: tempPerColors[level],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _makeTempToCharactorIcon() {
    return Container(
      width: 30,
      height: 30,
      child: Image.asset("assets/images/level-$level.jpg"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _makeTempLabelAndBar(),
              SizedBox(width: 7),
              _makeTempToCharactorIcon(),
            ],
          ),
          SizedBox(height: 5),
          Text(
            "ŰžĄŰäłýśĘŰĆä",
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 12,
                color: Colors.grey),
          )
        ],
      ),
    );
  }
}
