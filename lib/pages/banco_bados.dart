import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class PostgreSQLService {
  late PostgreSQLConnection _connection;

  PostgreSQLService({
    required String host,
    required int port,
    required String databaseName,
    required String username,
    required String password,
  }) {
    _connection = PostgreSQLConnection(
      host,
      port,
      databaseName,
      username: username,
      password: password,
    );
  }

  Future<void> openConnection() async {
    if (_connection.isClosed) {
      await _connection.open();
    }
  }

  Future<int?> getIdFuncionario(String email) async {
    await openConnection();
    try {
      final results = await _connection.query(
        'SELECT id_funcionario FROM "RHS"."tb_funcionario" WHERE email = @email',
        substitutionValues: {'email': email},
      );

      if (results.isNotEmpty) {
        return results[0][0] as int?;
      } else {
        return null; // Email não encontrado
      }
    } finally {}
  }

  Future<void> inserirRegistroPonto(
      int id, String data, TimeOfDay hora, String tipo) async {
    await openConnection();
    try {
      final horaFormatada =
          '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}';

      await _connection.query(
        'INSERT INTO "RHS"."tb_registro_ponto" (id_funcionario, data, hora, tipo) '
        'VALUES (@id_funcionario, @data, @hora, @tipo)',
        substitutionValues: {
          'id_funcionario': id,
          'data': data,
          'hora': horaFormatada,
          'tipo': tipo,
        },
      );
    } finally {}
  }

  Future<void> dispose() async {
    await _connection.close();
  }
}
