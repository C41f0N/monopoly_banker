import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:monopoly_banker/class_structure/game.dart';
import 'package:monopoly_banker/pages/home.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await Hive.initFlutter();

  await Hive.openBox("__MONOPOLY_BANKER_DATABASE__");

  runApp(
    ChangeNotifierProvider(
      create: (context) => Game(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monopoly Banker',
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.green[800]!,
          onPrimary: Colors.grey[900]!,
          secondary: Colors.green[900]!,
          onSecondary: Colors.grey[900]!,
          error: Colors.red[900]!,
          onError: Colors.white,
          background: const Color.fromARGB(255, 24, 24, 24),
          onBackground: Colors.grey[850]!,
          surface: Colors.grey[900]!,
          onSurface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 25,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[900],
          focusColor: Colors.grey[800],
          labelStyle: TextStyle(
            color: Colors.grey[400],
            fontWeight: FontWeight.w300,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green[800]!.withAlpha(170),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.red.withAlpha(170),
            ),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      home: const Home(),
    );
  }
}
