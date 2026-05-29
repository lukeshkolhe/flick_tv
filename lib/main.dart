import 'package:flutter/material.dart';
import 'package:flick_tv/app/flick_app.dart';
import 'package:flick_tv/core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const FlickApp());
}
