import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CurrencyDetailScreen extends StatelessWidget {
  final Map currency;
  final double inputAmount;

  const CurrencyDetailScreen({
    super.key,
    required this.currency,
    required this.inputAmount,
  });

  @override
  Widget build(BuildContext context) {
    final double rate = currency['rate'] is double
        ? currency['rate']
        : (currency['rate'] as num).toDouble();
    final double convertedAmount = inputAmount * rate; // คำนวณจำนวนที่แปลง

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${currency['name']} รายละเอียด',
          style: GoogleFonts.athiti(fontSize: 24),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.lightBlue[50],
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCard(
                  Icons.assistant_photo_outlined, 'สกุลเงิน', currency['name']),
              _buildCard(Icons.calculate, 'อัตตราแลกเปลี่ยน', rate.toString()),
              _buildCard(Icons.attach_money, 'ผ่านอัตตราแลกเปลี่ยน',
                  inputAmount.toStringAsFixed(2)),
              _buildCard(Icons.monetization_on, 'จำนวนเงิน',
                  convertedAmount.toStringAsFixed(2)),
            ],
          ),
        ),
      ),
    );
  }

  // เมธอดช่วยในการสร้างการ์ดที่มีข้อความและไอคอน
  Widget _buildCard(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 8, // เงาที่มีมากขึ้นเพื่อความลึก
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // มุมโค้ง
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon,
                    size: 28, color: Colors.blueAccent), // ไอคอนสำหรับการ์ด
                const SizedBox(width: 8), // ช่องว่างระหว่างไอคอนกับข้อความ
                Text(
                  title,
                  style: GoogleFonts.athiti(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text(
              value,
              style: GoogleFonts.athiti(fontSize: 18, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
