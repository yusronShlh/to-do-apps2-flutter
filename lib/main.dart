import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:notes_day/firebase_options.dart';
import 'package:notes_day/pages/login_page.dart';
import 'package:notes_day/provider/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ), // Tambahkan Provider
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes Day',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const LoginPage(), // Halaman pertama tetap LoginPage
      ),
    );
  }
}
