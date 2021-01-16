import 'dart:io';

import 'package:dio/dio.dart';
import 'package:loja_virtual/shared/models/cep_aberto_address.dart';

const token = 'cd278af786478e43e682fdba7bc429b0';

class CepAbertoService {
  Future<CepAbertoAddress> getAddressFromCep(String cep) async {
    final cleanCep = cep.replaceAll('.', '').replaceAll('-', '');

    final url = 'https://www.cepaberto.com/api/v3/cep?cep=$cleanCep';

    final dio = Dio();

    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

    try {
      final response = await dio.get<Map<String, dynamic>>(url);

      if (response.data.isEmpty) {
        return Future.error('CEP inválido');
      }

      final address = CepAbertoAddress.fromMap(response.data);

      return address;
    } on DioError {
      return Future.error('Erro ao buscar CEP');
    }
  }
}
