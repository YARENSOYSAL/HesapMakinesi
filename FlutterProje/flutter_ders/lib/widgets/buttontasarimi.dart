import 'package:flutter/material.dart';

class HesapMakinesiButtonu extends StatelessWidget {
  final String metin;
  final int dolguRengi; // ARGB veya Hex değer
  final int metinRengi;
  final double metinBoyutu;
  final Function tiklama;

  const HesapMakinesiButtonu({
    super.key,
    required this.metin,
    required this.dolguRengi,
    required this.metinRengi,
    required this.metinBoyutu,
    required this.tiklama,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: 80,
        height: 80,
        child: ElevatedButton(
          onPressed: () => tiklama(metin), // Bu satırı değiştirdik
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(dolguRengi),
            foregroundColor: Color(metinRengi),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(metin, style: TextStyle(fontSize: metinBoyutu)),
        ),
      ),
    );
  }
}
