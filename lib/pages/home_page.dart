import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:folha_de_ponto_rhs/pages/banco_bados.dart';
import 'package:folha_de_ponto_rhs/widgets/auth_check.dart';
import 'package:folha_de_ponto_rhs/widgets/relogio.dart';
import 'package:folha_de_ponto_rhs/widgets/usuario_logado.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Registo de Ponto",
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: const WidgetHome(),
    );
  }
}

class WidgetHome extends StatefulWidget {
  const WidgetHome({super.key});

  @override
  State<WidgetHome> createState() => _WidgetLoginState();
}

class _WidgetLoginState extends State<WidgetHome> {
  //controle dos botões
  bool _entradaButtonDisabled = false;
  bool _saidaButtonDisabled = false;
  bool _pausaButtonDisabled = false;
  bool _retornoButtonDisabled = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //acessando bando de dados
  final postgresService = PostgreSQLService(
    host: 'berry.db.elephantsql.com',
    port: 5432, // Porta padrão do PostgreSQL
    databaseName: 'kwlriltm',
    username: 'kwlriltm',
    password: 'XSvdSkoe1d8aCwESg7DQsJ7ay6ADyEz5',
  );
  //logout
  Future<void> _signOut(BuildContext context) async {
    await _auth.signOut();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const AuthCheck()),
    );
  }

  TimeOfDay obterHoraAtual() {
    final agora = DateTime.now();
    return TimeOfDay(hour: agora.hour, minute: agora.minute);
  }

  void registrarPonto(String tipo) async {
    //metodo pega o id na tabela funcionario no banco de dados,
    //atraves do email do usuario logado, e passa para outro metodo que insere as informacoes
    //do registro de ponto na tabela registro de ponto
    // Crie uma instância da classe UserEmailWidget
    // Crie uma instância da classe UserEmailWidget
    DateTime dataAtual = DateTime.now();
    int ano = dataAtual.year;
    int mes = dataAtual.month;
    int dia = dataAtual.day;
    String data = '$dia/$mes/$ano';

    String? emailDoUsuario;

// Verifica se o usuário está autenticado e pega o email logado
    User? usuario = FirebaseAuth.instance.currentUser;
    if (usuario != null) {
      emailDoUsuario = usuario.email;
    } else {
      emailDoUsuario = null;
    }
    try {
      int? idFuncionario =
          await postgresService.getIdFuncionario(emailDoUsuario.toString());
      if (idFuncionario != null) {
        await postgresService.inserirRegistroPonto(
            idFuncionario, data, obterHoraAtual(), tipo);
      } else {
        print('Email não encontrado no banco de dados.');
      }
    } catch (e) {
      print('Erro ao se conectar no banco de dados: $e');
    }
  }

  void _handleMenuClick(String value) {
    // Implemente a lógica para cada opção do menu aqui
    if (value == 'Sair') {
      SystemNavigator.pop();
    } else if (value == 'Logout') {
      _signOut(context);
    } else if (value == 'Sobre') {
      _showVersionNotesDialog(context);
    }
  }

  void _showVersionNotesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notas da Versão 1.0.0'),
          content: const SingleChildScrollView(
            child: Text(
              'Este aplicativo foi desenvolvido pela Devcoast para fins acadêmicos, o foco é atender o Projeto Integrado Multidisciplinar (PIM) trabalho acadêmico que tem como objetivo aplicar, de forma prática, os conhecimentos das disciplinas da faculdade.',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2), // Defina a duração desejada
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '                Registro de Ponto RHS',
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _handleMenuClick,
            itemBuilder: (BuildContext context) {
              return {'Sair', 'Logout', 'Sobre'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment:
            MainAxisAlignment.start, // Alinha os elementos no topo.
        children: <Widget>[
          const SizedBox(height: 50.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              UserEmailWidget(),
              const SizedBox(
                  height: 50.0), // Espaçamento entre o texto e o DigitaLClock.
            ],
          ),
          Center(
            child: DigitalClock(),
          ),
          const SizedBox(
              height: 50.0), // Espaçamento entre o texto e o GridView.
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(10.0),
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              children: <Widget>[
                //botao Entrada
                ElevatedButton(
                  onPressed: _entradaButtonDisabled
                      ? null
                      : () {
                          setState(() {
                            // Desativar o botão
                            _entradaButtonDisabled = true;
                          });

                          registrarPonto('Entrada');
                          _showSnackBar(context, 'Entrada Registrada.');
                        },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        Colors.green, // Define a cor do texto do botão
                  ),
                  child: _entradaButtonDisabled
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "imagens/check_icon.png",
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Entrada\n Registrada',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromARGB(255, 127, 129,
                                    129), // Defina a cor desejada aqui
                                fontSize: 15, // Tamanho da fonte
                                fontWeight:
                                    FontWeight.bold, // Peso da fonte (opcional)
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            const Text(
                              'Entrada',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ),
                            const SizedBox(width: 20.0),
                            Image.asset(
                              "imagens/entrada_icon.png",
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                ),
                //botao Pausa
                ElevatedButton(
                  onPressed: _pausaButtonDisabled
                      ? null
                      : () {
                          setState(() {
                            // Desativar o botão
                            _pausaButtonDisabled = true;
                          });

                          registrarPonto('Pausa');
                          _showSnackBar(context, 'Pausa Registrada.');
                        },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        Colors.red, // Define a cor do texto do botão
                  ),
                  child: _pausaButtonDisabled
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "imagens/check_icon.png",
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Pausa\n Registrada',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromARGB(255, 127, 129,
                                    129), // Defina a cor desejada aqui
                                fontSize: 15, // Tamanho da fonte
                                fontWeight:
                                    FontWeight.bold, // Peso da fonte (opcional)
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            const Text(
                              'Pausa  ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ),
                            const SizedBox(width: 20.0),
                            Image.asset(
                              "imagens/pausa_icon.png",
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                ),

                //botao Retorno
                ElevatedButton(
                  onPressed: _retornoButtonDisabled
                      ? null
                      : () {
                          setState(() {
                            // Desativar o botão
                            _retornoButtonDisabled = true;
                          });

                          registrarPonto('Retorno');
                          _showSnackBar(context, 'Retorno Registrado.');
                        },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        Colors.yellow[800], // Define a cor do texto do botão
                  ),
                  child: _retornoButtonDisabled
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "imagens/check_icon.png",
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Retorno\n Registrado',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromARGB(255, 127, 129,
                                    129), // Defina a cor desejada aqui
                                fontSize: 15, // Tamanho da fonte
                                fontWeight:
                                    FontWeight.bold, // Peso da fonte (opcional)
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            const Text(
                              'Retorno',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ),
                            const SizedBox(width: 20.0),
                            Image.asset(
                              "imagens/retorno_icon.png",
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                ),
                //botao Saída
                ElevatedButton(
                  onPressed: _saidaButtonDisabled
                      ? null
                      : () {
                          setState(() {
                            // Desativar o botão
                            _saidaButtonDisabled = true;
                          });

                          registrarPonto('Saída');
                          _showSnackBar(context, 'Saída Registrada.');
                        },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        Colors.lightBlue[400], // Define a cor do texto do botão
                  ),
                  child: _saidaButtonDisabled
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "imagens/check_icon.png",
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Saída\n Registrada',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromARGB(255, 127, 129,
                                    129), // Defina a cor desejada aqui
                                fontSize: 15, // Tamanho da fonte
                                fontWeight:
                                    FontWeight.bold, // Peso da fonte (opcional)
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            const Text(
                              'Saída   ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ),
                            const SizedBox(width: 20.0),
                            Image.asset(
                              "imagens/saida_icon.png",
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
