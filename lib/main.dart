import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tono/currencyscreen.dart';
// ignore: library_prefixes

void main() {
  runApp(const CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  const CurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.athitiTextTheme(
          Theme.of(context)
              .textTheme
              .apply(bodyColor: Colors.black87, displayColor: Colors.blue),
        ),
      ),
      home: const CurrencyListScreen(),
    );
  }
}
