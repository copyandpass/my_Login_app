// main.dart

import 'package:flutter/material.dart';
import 'package:my_login_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:my_login_app/screens/home_screen.dart';
import 'package:my_login_app/screens/login_screen.dart';
import 'package:my_login_app/screens/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadToken()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'Flutter Login App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/home': (context) => const HomeScreen(),
            },
            home: authProvider.isLoading
                ? const Center(child: CircularProgressIndicator()) // 로딩 상태일 때 로딩 스피너 표시
                : authProvider.isLoggedIn
                    ? const HomeScreen()
                    : const LoginScreen(),
          );
        },
      ),
    );
  }
}