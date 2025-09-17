import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_ders/widgets/buttontasarimi.dart';
import 'package:decimal/decimal.dart'; // <- decimal paketi
import 'loginscreen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  Decimal sayi1 = Decimal.zero;
  Decimal sayi2 = Decimal.zero;
  String GosterilecekSayi = "";
  String IslemGecmisi = "";
  String sonuc = "0";
  String islem = "";
  bool yeniSayiGiriliyor = false;

  String formatSonuc(Decimal value) {
    return value.toString(); // decimal zaten doğru şekilde string verir
  }

  void btnTiklama(String buttonDegeri) {
    if (buttonDegeri == "AC") {
      GosterilecekSayi = "";
      sonuc = "";
      sayi1 = Decimal.zero;
      sayi2 = Decimal.zero;
      islem = "";
      IslemGecmisi = "";
    } else if (buttonDegeri == "C") {
      GosterilecekSayi = "";
      sonuc = "";
      sayi1 = Decimal.zero;
      sayi2 = Decimal.zero;
    } else if (buttonDegeri == "BACK") {
      if (GosterilecekSayi.isNotEmpty) {
        sonuc = GosterilecekSayi.substring(0, GosterilecekSayi.length - 1);
      }
    } else if (buttonDegeri == "+" ||
        buttonDegeri == "-" ||
        buttonDegeri == "/" ||
        buttonDegeri == "x") {
      if (GosterilecekSayi.isEmpty) return;
      sayi1 = Decimal.parse(GosterilecekSayi.replaceAll(',', '.'));
      islem = buttonDegeri;
      IslemGecmisi = GosterilecekSayi + " " + islem;
      yeniSayiGiriliyor = true;
    } else if (buttonDegeri == "+/-") {
      if (GosterilecekSayi.isNotEmpty) {
        if (GosterilecekSayi.startsWith('-')) {
          sonuc = GosterilecekSayi.substring(1);
        } else {
          sonuc = '-' + GosterilecekSayi;
        }
      }
    } else if (buttonDegeri == "=") {
      if (GosterilecekSayi.isEmpty || islem.isEmpty) return;
      sayi2 = Decimal.parse(GosterilecekSayi.replaceAll(',', '.'));

      if (islem == "+") sonuc = formatSonuc(sayi1 + sayi2);
      if (islem == "-") sonuc = formatSonuc(sayi1 - sayi2);
      if (islem == "x") sonuc = formatSonuc(sayi1 * sayi2);
      if (islem == "/") {
        if (sayi2 == Decimal.zero) {
          sonuc = "bölünemez";
        } else {
          sonuc = formatSonuc((sayi1 / sayi2) as Decimal);
        }
      }

      IslemGecmisi = "$sayi1 $islem $sayi2";
      GosterilecekSayi = sonuc;
      yeniSayiGiriliyor = true;
      islem = "";
    } else {
      if (yeniSayiGiriliyor) {
        sonuc = buttonDegeri;
        yeniSayiGiriliyor = false;
      } else {
        sonuc = GosterilecekSayi + buttonDegeri;
      }
    }

    setState(() {
      GosterilecekSayi = sonuc;
    });
  }

  Widget buildButton(
    String text, {
    Color bgColor = Colors.grey,
    Color textColor = Colors.black,
  }) {
    return ElevatedButton(
      onPressed: () => btnTiklama(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        minimumSize: const Size(70, 70),
      ),
      child: Text(text, style: TextStyle(fontSize: 24, color: textColor)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hesap Makinesi"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('loggedIn', false);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Text(
                          IslemGecmisi,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Text(
                          GosterilecekSayi,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            HesapMakinesiButtonu(
                              metin: "AC",
                              dolguRengi: 0xFFFF5722,
                              metinRengi: 0xFF000000,
                              metinBoyutu: 24.0,
                              tiklama: btnTiklama,
                            ),
                            HesapMakinesiButtonu(
                              metin: "C",
                              dolguRengi: 0xFFFF5722,
                              metinRengi: 0xFF000000,
                              metinBoyutu: 24.0,
                              tiklama: btnTiklama,
                            ),
                            HesapMakinesiButtonu(
                              metin: "BACK",
                              dolguRengi: 0xFFFFC107,
                              metinRengi: 0xFF000000,
                              metinBoyutu: 12.0,
                              tiklama: btnTiklama,
                            ),
                            HesapMakinesiButtonu(
                              metin: "/",
                              dolguRengi: 0xFFFFC107,
                              metinRengi: 0xFF000000,
                              metinBoyutu: 24.0,
                              tiklama: btnTiklama,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            HesapMakinesiButtonu(
                              metin: "1",
                              dolguRengi: 0xFFFF5722,
                              metinRengi: 0xFF000000,
                              metinBoyutu: 24.0,
                              tiklama: btnTiklama,
                            ),
                            HesapMakinesiButtonu(
                              metin: "2",
                              dolguRengi: 0xFFFF5722,
                              metinRengi: 0xFF000000,
                              metinBoyutu: 24.0,
                              tiklama: btnTiklama,
                            ),
                            HesapMakinesiButtonu(
                              metin: "3",
                              dolguRengi: 0xFFFF5722,
                              metinRengi: 0xFF000000,
                              metinBoyutu: 24.0,
                              tiklama: btnTiklama,
                            ),
                            HesapMakinesiButtonu(
                              metin: "x",
                              dolguRengi: 0xFFFFC107,
                              metinRengi: 0xFF000000,
                              metinBoyutu: 24.0,
                              tiklama: btnTiklama,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            HesapMakinesiButtonu(
                              metin: "4",
                              dolguRengi: 0xFFFF5722,
                              metinRengi: 0xFF000000,
                              metinBoyutu: 24.0,
                              tiklama: btnTiklama,
                            ),
                            HesapMakinesiButtonu(
                              metin: "5",
                              dolguRengi: 0xFFFF5722,
                              metinRengi: 0xFF000000,
                              metinBoyutu: 24.0,
                              tiklama: btnTiklama,
                            ),
                            HesapMakinesiButtonu(
                              metin: "6",
                              dolguRengi: 0xFFFF5722,
                              metinRengi: 0xFF000000,
                              metinBoyutu: 24.0,
                              tiklama: btnTiklama,
                            ),
                            HesapMakinesiButtonu(
                              metin: "-",
                              dolguRengi: 0xFFFFC107,
                              metinRengi: 0xFF000000,
                              metinBoyutu: 24.0,
                              tiklama: btnTiklama,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            HesapMakinesiButtonu(
                              metin: "7",
                              dolguRengi: 0xFFFF5722,
                              metinRengi: 0xFF000000,
                              metinBoyutu: 24.0,
                              tiklama: btnTiklama,
                            ),
                            HesapMakinesiButtonu(
                              metin: "8",
                              dolguRengi: 0xFFFF5722,
                              metinRengi: 0xFF000000,
                              metinBoyutu: 24.0,
                              tiklama: btnTiklama,
                            ),
                            HesapMakinesiButtonu(
                              metin: "9",
                              dolguRengi: 0xFFFF5722,
                              metinRengi: 0xFF000000,
                              metinBoyutu: 24.0,
                              tiklama: btnTiklama,
                            ),
                            HesapMakinesiButtonu(
                              metin: "+",
                              dolguRengi: 0xFFFFC107,
                              metinRengi: 0xFF000000,
                              metinBoyutu: 24.0,
                              tiklama: btnTiklama,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            HesapMakinesiButtonu(
                              metin: "+/-",
                              dolguRengi: 0xFFFF5722,
                              metinRengi: 0xFF000000,
                              metinBoyutu: 24.0,
                              tiklama: btnTiklama,
                            ),
                            HesapMakinesiButtonu(
                              metin: "0",
                              dolguRengi: 0xFFFF5722,
                              metinRengi: 0xFF000000,
                              metinBoyutu: 24.0,
                              tiklama: btnTiklama,
                            ),
                            HesapMakinesiButtonu(
                              metin: ",",
                              dolguRengi: 0xFFFF5722,
                              metinRengi: 0xFF000000,
                              metinBoyutu: 24.0,
                              tiklama: btnTiklama,
                            ),
                            HesapMakinesiButtonu(
                              metin: "=",
                              dolguRengi: 0xFFFFC107,
                              metinRengi: 0xFF000000,
                              metinBoyutu: 24.0,
                              tiklama: btnTiklama,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
