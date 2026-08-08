import 'package:flutter/material.dart';
import 'package:leaf_notes/core/constants/app_images.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4EEDF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.appIcon, height: 200),
            const Text(
              'Leaf Notes',
              style: TextStyle(fontFamily: 'InkFree', fontSize: 35),
            ),
          ],
        ),
      ),
    );
  }
}
