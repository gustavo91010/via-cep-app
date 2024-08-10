import 'dart:math';

import 'package:dio/dio.dart';
import 'package:via_cep/models/endereco_model.dart';
import 'package:via_cep/repository/cep_repository.dart';

class CepRepositoryImpl implements CepRepository{
  @override
  Future<EnderecoModel> getCep(String cep) async {
    try {

   final result= await Dio().get('https://viacep.com.br/ws/$cep/json/');
   return EnderecoModel.fromMap(result.data);
    }on DioException catch(e){
      

      throw Exception('Error ao buscar cep');

    }
  }
  
}