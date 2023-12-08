import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myweather/components/login_page/login_page.dart';
import 'package:myweather/components/weather_home/weather_home.dart';
import 'package:myweather/controllers/userController.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserController()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My weather',
      routes: {
        "/home": (context) => const WeatherHome(),
        "/login": (context) => const LoginPage()
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
