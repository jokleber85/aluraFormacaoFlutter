import 'package:bytebank7/screens/dashboard/saldo.dart';
import 'package:bytebank7/screens/deposito/formulario.dart';
import 'package:bytebank7/screens/transferencia/formulario.dart';
import 'package:bytebank7/screens/transferencia/lista.dart';
import 'package:bytebank7/screens/transferencia/ultima.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/saldo.dart';

class Dashboard extends StatelessWidget{
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ByteBank'),
      ),
      body: ListView(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: SaldoCard(),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text('Receber Depósito'), 
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return FormularioDeposito();
                  }));
                }
              ), 
              RaisedButton(
                child: Text('Nova Transferência'), 
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return FormularioTransferencia();
                  }));
                }
              ), 
            ],
          ),
          UltimasTransferencias()
        ] 
      ),
    );
  }

}