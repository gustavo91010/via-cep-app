import 'package:via_cep/models/endereco_model.dart';

abstract interface class CepRepository {
Future<EnderecoModel> getCep(String cep);
}
