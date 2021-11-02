import 'package:flutter/material.dart';
import 'package:mercado/molelo/produto.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerQuantidade = TextEditingController();
  final TextEditingController _controllerValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Cadastrando produto'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Produto'),
                  controller: _controllerNome,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Quantidade'),
                    controller: _controllerQuantidade,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Valor'),
                    controller: _controllerValor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    child: Text('Confirmar'),
                    onPressed: () {
                      final String nome = _controllerNome.text;
                      final int? quantidade =
                          int.tryParse(_controllerQuantidade.text);
                      final double? valor =
                          double.tryParse(_controllerValor.text);

                      if (quantidade != null && valor != null) {
                        final Produto produtoNovo =
                            Produto(nome, quantidade, valor);
                        debugPrint('Criando Transferencia');
                        debugPrint('$produtoNovo');
                      }
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
