import 'package:flutter/material.dart';
import 'package:via_cep/models/endereco_model.dart';
import 'package:via_cep/repository/cep_repository.dart';
import 'package:via_cep/repository/cep_repository_impl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CepRepository cepRepository = CepRepositoryImpl();
  EnderecoModel? enderecoModel;

  final formKey = GlobalKey<FormState>(); // refcuperar o estado do formulario
  final cepEC = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    cepEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Cep'), /*  */
      ),
      body: SingleChildScrollView(
        // Deixar a tela principal scrolavel
        child: Form(
            // form para pegar dados de entrada
            key: formKey, // Para pegar o valor de entrada
            //Um form com uma coluna, como unico filho
            child: Column(
              // essa coluna com varios filhos
              children: [
                TextFormField(
                  controller: cepEC, // Associa o controlador ao campo de texto
                  validator: (value) {
                    // Validar se o form esta vindo com valor ou vazio
                    if (value == null || value.isEmpty) {
                      return 'CEP Obrigatório';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    final valid = formKey.currentState?.validate() ?? false;
                    // recupera o status atual do form, e sempre se previnir do estatus null, com a ?
                    // se naõ fiver, retorna um false
                    if (valid) {
                      try {
                        print(
                            'CEP digitado: ${cepEC.text}'); // Exibe o valor digitado no console
                        setState(() {
                          loading = true;
                        });
                        // Iniciando a busca
                        final endereco = await cepRepository.getCep(cepEC.text);
                        setState(() {
                          loading= false;
                          // converte o resultado no nosso model e atualiza a tela
                          enderecoModel = endereco;
                        });
                      } on Exception {
                        setState(() {
                          loading= false;
                          enderecoModel =
                              null; // se a busca pelo endereço der errado, eu limpo a console
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Error ao buscar o Endereço')),
                        );
                      }
                    }
                  },
                  child: const Text('Buscar'),
                ),
                Visibility(
                  visible: loading,
                  child: CircularProgressIndicator(),
                ),
                Visibility(
                  visible: enderecoModel != null,
                  child: enderecoModel != null
                      ? Text(
                          '${enderecoModel?.logradouro ?? ''} ${enderecoModel?.cep ?? ''} ${enderecoModel?.complemento ?? ''}',
                        )
                      : const SizedBox
                          .shrink(), // Retorna um widget vazio se o enderecoModel for nulo
                ),
              ],
            )),
      ),
    );
  }
}
