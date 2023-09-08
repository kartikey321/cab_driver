// ignore_for_file: prefer_const_constructors

import 'package:cab_driver/brand_colors.dart';
import 'package:cab_driver/screens/historypage.dart';
import 'package:cab_driver/widgets/BrandDivider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../DataProvider.dart';

class EarningsTab extends StatelessWidget {
  const EarningsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: BrandColors.colorPrimary,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 70),
            child: Column(
              children: <Widget>[
                Text(
                  'Total Earnings',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '\u{20B9}${Provider.of<AppData>(context).earnings}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontFamily: 'Brand-Bold'),
                )
              ],
            ),
          ),
        ),
        TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.all(0)),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HistoryPage(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
            child: Row(
              children: <Widget>[
                Image.asset(
                  'assets/images/taxi.png',
                  width: 70,
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  'Trips',
                  style: TextStyle(fontSize: 16),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      Provider.of<AppData>(context).tripCount,
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        BrandDivider(),
      ],
    );
  }
}
