import 'dart:async';

import 'package:admin/constants.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  final String? username;

  const DashboardScreen({Key? key, required this.username}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentPage = 0;
  late final PageController _pageController;
  final List<String> imageUrls = [
    'assets/slide/1 (1).jpg',
    'assets/slide/1 (2).jpg',
    'assets/slide/1 (3).jpg',
    'assets/slide/1 (4).jpg',
    'assets/slide/1 (5).jpg',
    'assets/slide/1 (6).jpg',
    'assets/slide/2 (1).png',
    'assets/slide/2 (2).png',
    'assets/slide/2 (3).png',
    'assets/slide/2 (4).png',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Start the timer to change images automatically
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentPage < imageUrls.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            // Header widget
            SizedBox(height: defaultPadding),
            Container(
              height: 700,
              child: PageView.builder(
                controller: _pageController,
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      imageUrls[index],
                      fit: BoxFit.cover,
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
}
