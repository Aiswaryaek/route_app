// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';

import 'features/route_page.dart';

class FlutterBasicApp extends StatefulWidget {
  const FlutterBasicApp({Key? key}) : super(key: key);

  @override
  _FlutterBasicAppState createState() => _FlutterBasicAppState();
}

class _FlutterBasicAppState extends State<FlutterBasicApp> {
  @override
  Widget build(BuildContext context) {
    return RoutePage();
  }
}
