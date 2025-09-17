import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/loginscreen.dart';
import 'screens/CalculatorScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('loggedIn') ?? false;

  runApp(Test(isLoggedIn: isLoggedIn));
}

class Test extends StatefulWidget {
  final bool isLoggedIn;
  const Test({super.key, required this.isLoggedIn});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: widget.isLoggedIn ? const CalculatorScreen() : const LoginScreen(),
    );
  }
}
