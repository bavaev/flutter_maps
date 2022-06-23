import 'package:flutter/material.dart';

import 'maps.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Google Maps',
      home: Maps(),
    );
  }
}
