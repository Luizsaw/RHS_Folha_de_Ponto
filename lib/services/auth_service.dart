import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario;
  bool isloading = true;
  AuthService() {
    _authCheck();
  }
  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      usuario = (user == null) ? null : user;
      isloading = false;
      notifyListeners();
    });
  }

  _getUser() {
    usuario = _auth.currentUser;
    isloading = true;
    notifyListeners();
  }

  Future<void> login(String email, String senha) async {
    try {
      // Tenta fazer login com o email e senha fornecidos
      await _auth.signInWithEmailAndPassword(email: email, password: senha);

      // Após o login bem-sucedido, obtém informações do usuário
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        throw AuthException(
            'Credenciais inválidas. Verifique seu email e senha.');
      } else if ((e.code == 'too-many-requests')) {
        throw AuthException(
            'O acesso a esta conta foi temporariamente desativado devido a muitas tentativas de login malsucedidas. Tente novamente mais tarde.');
      }
    } catch (e) {
      // Trata qualquer outra exceção que possa ocorrer durante o processo de login
      throw AuthException('Erro desconhecido: $e');
    }
  }

  logout() async {
    await _auth.signOut();
    _getUser();
  }
}
