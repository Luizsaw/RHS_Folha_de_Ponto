import 'package:flutter/material.dart';
import 'package:folha_de_ponto_rhs/widgets/auth_check.dart';

class FolhaDePonto extends StatelessWidget {
  const FolhaDePonto({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Folha de Ponto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const AuthCheck(),
    );
  }
}
