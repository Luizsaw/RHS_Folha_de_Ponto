import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:folha_de_ponto_rhs/folha_de_ponto.dart';
import 'package:folha_de_ponto_rhs/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
      child: const FolhaDePonto(),
    ),
  );
}
