import 'dart:async';

import 'package:bytebank8/components/container.dart';
import 'package:bytebank8/components/progress.dart';
import 'package:bytebank8/components/response_dialog.dart';
import 'package:bytebank8/components/transaction_auth_dialog.dart';
import 'package:bytebank8/http/webclients/transaction_webclient.dart';
import 'package:bytebank8/models/contact.dart';
import 'package:bytebank8/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../components/error.dart';

@immutable
abstract class TransactionFormState {
  const TransactionFormState();
}

@immutable
class ShowFormState extends TransactionFormState {
  const ShowFormState();
}

@immutable
class SendingState extends TransactionFormState {
  const SendingState();
}

@immutable
class SentState extends TransactionFormState {
  const SentState();
}

@immutable
class FatalErrorFormState extends TransactionFormState {
  final String _message; 
  const FatalErrorFormState(this._message);
}

class TransactionFormCubit extends Cubit<TransactionFormState> {
  final TransactionWebClient _webClient = TransactionWebClient();
  TransactionFormCubit() : super(ShowFormState());

  void save(Transaction transactionCreated, String password, BuildContext context) async {
    emit(SendingState()); 
    await _send(
      transactionCreated,
      password,
      context,
    );
  }

  _send(Transaction transactionCreated, String password, BuildContext context) async {
    await _webClient.save(transactionCreated, password)
      .then((transaction) => emit(SentState()))
      .catchError((e) {
        emit(FatalErrorFormState(e.message));
    }, test: (e) => e is HttpException).catchError((e) {
        emit(FatalErrorFormState('timeout submitting the transaction'));
    }, test: (e) => e is TimeoutException).catchError((e) {
        emit(FatalErrorFormState(e.message));
    });
  }

}

class TransactionFormContainer extends BlocContainer {
  final Contact _contact;
  TransactionFormContainer(this._contact);

  @override
  Widget build(BuildContext context) {
    
    return BlocProvider<TransactionFormCubit>(
      create: (BuildContext context){
        return TransactionFormCubit();
      },
      child: BlocListener<TransactionFormCubit, TransactionFormState>(
        listener: (context, state) {
          if(state is SentState){
            Navigator.pop(context);
          }
        },
        child: _TransactionFormStateless(_contact)),
    ); 
  }
}

class _TransactionFormStateless extends StatelessWidget {
  final Contact _contact;
  _TransactionFormStateless(this._contact);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionFormCubit, TransactionFormState>(builder: (context, state) {
      if (state is ShowFormState){
        return _BasicForm(_contact);
      }

      if (state is SendingState || state is SentState){
        return ProgressView();
      }

      if (state is FatalErrorFormState){
        return ErrorView(state._message);
      };

      return Text("Unknown Error!!");
      
    });
    
  }

  Future _showSuccessfulMessage(
      Transaction transaction, BuildContext context) async {
    if (transaction != null) {
      await showDialog(
          context: context,
          builder: (contextDialog) {
            return SuccessDialog('successful transaction');
          });
      Navigator.pop(context);
    }
  }

  void _showFailureMessage(
    BuildContext context, {
    String message = 'Unknown error',
  }) {
    showDialog(
        context: context,
        builder: (contextDialog) {
          return FailureDialog(message);
        });
  }
}

class _BasicForm extends StatelessWidget{
  final Contact _contact;
  _BasicForm(this._contact);

  final TextEditingController _valueController = TextEditingController();
  final String transactionId = Uuid().v4();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _contact.name,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _contact.accountNumber.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: RaisedButton(
                    child: Text('Transfer'),
                    onPressed: () {
                      final double value =
                          double.tryParse(_valueController.text);
                      final transactionCreated = Transaction(
                        transactionId,
                        value,
                        _contact,
                      );
                      showDialog(
                          context: context,
                          builder: (contextDialog) {
                            return TransactionAuthDialog(
                              onConfirm: (String password) {
                                BlocProvider.of<TransactionFormCubit>(context).save(transactionCreated, password, context);
                              },
                            );
                          });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
