import 'package:admin/responsive.dart';

import 'package:flutter/material.dart';

import '../../constants.dart';

class DashboardScreen extends StatelessWidget {
  final String? username;
  const DashboardScreen({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: defaultPadding),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    SizedBox(height: defaultPadding),
                  ],
                ),
              ),
              if (!Responsive.isMobile(context))
                SizedBox(width: defaultPadding),
              // On Mobile means if the screen is less than 850 we don't want to show it
            ],
          )
        ],
      ),
    );
  }
}
