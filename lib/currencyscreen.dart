import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:tono/detailscreen.dart';

class CurrencyListScreen extends StatefulWidget {
  const CurrencyListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CurrencyListScreenState createState() => _CurrencyListScreenState();
}

class _CurrencyListScreenState extends State<CurrencyListScreen> {
  List currencyData = [];
  double inputAmount = 1.0;
  String selectedCurrency = 'USD';
  double selectedRate = 1.0;

  @override
  void initState() {
    super.initState();
    loadCurrencyData();
  }

  Future<void> loadCurrencyData() async {
    try {
      final String response =
          await rootBundle.rootBundle.loadString('assets/currency_data.json');
      final data = json.decode(response);
      setState(() {
        currencyData = data['currencies'];
        _updateSelectedRate(); // อัปเดตอัตราการแปลงสำหรับสกุลเงินที่เลือกครั้งแรก
      });
    } catch (e) {
      print("Error loading JSON: $e");
    }
  }

  void _updateSelectedRate() {
    final selectedCurrencyData = currencyData.firstWhere(
      (currency) => currency['name'] == selectedCurrency,
      orElse: () => {'rate': 1.0},
    );
    setState(() {
      selectedRate = selectedCurrencyData['rate'] is double
          ? selectedCurrencyData['rate']
          : (selectedCurrencyData['rate'] as num).toDouble();
    });
  }

  void updateAmount(double change) {
    setState(() {
      inputAmount =
          (inputAmount + change).clamp(0, double.infinity); // ค่าเงินจะไม่ติดลบ
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Currency Converter',
          style: GoogleFonts.athiti(fontSize: 24),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[100]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'จำนวนเงินปัจจุบัน: ${inputAmount.toStringAsFixed(2)} $selectedCurrency',
                        style: GoogleFonts.athiti(
                            fontSize: 20, color: Colors.black87),
                      ),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value: selectedCurrency,
                        items: currencyData
                            .map<DropdownMenuItem<String>>((currency) {
                          return DropdownMenuItem<String>(
                            value: currency['name'],
                            child: Text(currency['name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCurrency = value ?? 'USD';
                            _updateSelectedRate();
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    children: [
                      ElevatedButton(
                        onPressed: () => updateAmount(0.01),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor:
                              Colors.white, // Set text color to white
                        ),
                        child: const Text('+0.01'),
                      ),
                      ElevatedButton(
                        onPressed: () => updateAmount(0.10),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor:
                              Colors.white, // Set text color to white
                        ),
                        child: const Text('+0.10'),
                      ),
                      ElevatedButton(
                        onPressed: () => updateAmount(1.0),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor:
                              Colors.white, // Set text color to white
                        ),
                        child: const Text('+1.0'),
                      ),
                      ElevatedButton(
                        onPressed: () => updateAmount(10),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor:
                              Colors.white, // Set text color to white
                        ),
                        child: const Text('+10'),
                      ),
                      ElevatedButton(
                        onPressed: () => updateAmount(-0.01),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor:
                              Colors.white, // Set text color to white
                        ),
                        child: const Text('-0.01'),
                      ),
                      ElevatedButton(
                        onPressed: () => updateAmount(-0.10),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor:
                              Colors.white, // Set text color to white
                        ),
                        child: const Text('-0.10'),
                      ),
                      ElevatedButton(
                        onPressed: () => updateAmount(-1.0),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor:
                              Colors.white, // Set text color to white
                        ),
                        child: const Text('-1.0'),
                      ),
                      ElevatedButton(
                        onPressed: () => updateAmount(-10),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor:
                              Colors.white, // Set text color to white
                        ),
                        child: const Text('-10'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: currencyData.length,
                itemBuilder: (context, index) {
                  final currency = currencyData[index];
                  final double rate = currency['rate'] is double
                      ? currency['rate']
                      : (currency['rate'] as num).toDouble();
                  final double convertedAmount =
                      (inputAmount * selectedRate) / rate;

                  final imageName = currency['name'].toLowerCase();

                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(
                        '${currency['name']}',
                        style: GoogleFonts.athiti(fontSize: 20),
                      ),
                      subtitle: Text(
                        'อัตตราแลกเปลี่ยน: $rate \nจำนวนเงินที่แปลงแล้ว: ${convertedAmount.toStringAsFixed(2)}',
                        style: GoogleFonts.athiti(fontSize: 16),
                      ),
                      leading: Image.asset(
                        'assets/images/$imageName.png',
                        width: 40,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error, color: Colors.red);
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CurrencyDetailScreen(
                              currency: currency,
                              inputAmount: convertedAmount,
                            ),
                          ),
                        );
                      },
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
