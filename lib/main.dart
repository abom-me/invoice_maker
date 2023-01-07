import 'package:flutter/material.dart';
import 'package:invoice_maker/settings.dart';
import 'package:invoice_maker/widgets/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(),
        scaffoldBackgroundColor: appColor,
        fontFamily: appFont,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: appColor,
          primary: appColor,

          // onPrimary: Colors.indigo
        ),
        appBarTheme: const AppBarTheme(elevation: 0),
      ),
      home: HomePage(),
    );
  }
}
