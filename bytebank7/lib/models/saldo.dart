import 'package:flutter/foundation.dart';

class Saldo extends ChangeNotifier{
  double valor;

  Saldo(this.valor);

  @override
  String toString(){
    return 'R\$ $valor';
  } 

  void adicionar(double valor){
    this.valor += valor;

    notifyListeners();
  }

  void subtrair(double valor){
    this.valor -= valor;

    notifyListeners();
  }
}