import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserEmailWidget extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getUserEmail(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erro ao recuperar o email: ${snapshot.error}');
        } else {
          final email = snapshot.data;
          if (email != null) {
            return Center(
              child: Row(
                children: [
                  const Icon(
                    Icons.circle,
                    size: 20, // Tamanho do ícone
                    color: Colors.green, // Cor verde
                  ),
                  const SizedBox(
                      width: 8), // Espaçamento entre o ícone e o texto
                  Text(
                    'Usuário: $email',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 20, // Tamanho do ícone
                    color: Colors.red, // Cor verde
                  ),
                  SizedBox(width: 8), // Espaçamento entre o ícone e o texto
                  Text(
                    'Nenhum usuário logado.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }
        }
      },
    );
  }

  Future<String?> getUserEmail() async {
    final user = _auth.currentUser;
    if (user != null) {
      return user.email;
    }
    return null;
  }
}
