import 'package:flutter/material.dart';
import 'package:folha_de_ponto_rhs/pages/home_page.dart';
import 'package:folha_de_ponto_rhs/pages/login_page.dart';
import 'package:folha_de_ponto_rhs/services/auth_service.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    if (auth.isloading) {
      return HomePage();
    } else {
      return const LoginPage();
    }
  }

  loading() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
