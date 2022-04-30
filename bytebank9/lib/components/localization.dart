import 'dart:async';

import 'package:bytebank9/components/error.dart';
import 'package:bytebank9/components/progress.dart';
import 'package:bytebank9/http/webclients/i18n_webclient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstorage/localstorage.dart';

import 'container.dart';
import 'error.dart';

class LocalizationContainer extends BlocContainer{
  final Widget child;

  LocalizationContainer({@required Widget this.child});

  @override
  Widget build(BuildContext context) {
      
    return BlocProvider<CurrentLocaleCubit>(
      create: (context) => CurrentLocaleCubit(),
      child: this.child,
    );
  }
}

class CurrentLocaleCubit extends Cubit<String>{
  CurrentLocaleCubit() : super('en');
}

class ViewI18n {
  String _language;

  ViewI18n(BuildContext context){
    this._language = BlocProvider.of<CurrentLocaleCubit>(context).state;
  }

  String localize(Map<String, String> values){
    assert(values != null);
    assert(values.containsKey(_language));

    return values[_language];
  }
}

@immutable
abstract class I18NMessagesState {
  const I18NMessagesState();
}

@immutable
class LoadingI18NMessagesState extends I18NMessagesState {
  const LoadingI18NMessagesState();
}

@immutable
class InitI18NMessagesState extends I18NMessagesState {
  const InitI18NMessagesState();
}

@immutable
class LoadedI18NMessagesState extends I18NMessagesState {
  final I18NMessages _messages;
  const LoadedI18NMessagesState(this._messages);
}

class I18NMessages {
  final Map<String, dynamic> _messages; 
  I18NMessages(this._messages);

  String get(String key){
    assert(key != null);
    assert(_messages.containsKey(key));

    return _messages[key];
  }
}

@immutable
class FatalErrorI18NMessagesState extends I18NMessagesState {
  const FatalErrorI18NMessagesState();
}

typedef Widget I18NWidgetCreator(I18NMessages messages);

class I18NLoadingContainer extends BlocContainer {
  I18NWidgetCreator creator;
  String viewKey;

  I18NLoadingContainer({
    @required String viewKey, 
    @required I18NWidgetCreator creator
  }) {
    this.creator = creator;
    this.viewKey = viewKey;
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider<I18NMessagesCubit>(
      create: (BuildContext context){
        final cubit = I18NMessagesCubit(this.viewKey);
        cubit.reload(I18nWebClient(this.viewKey));
        return cubit;
      },
      child: I18NLoadingView(this.creator),
    );  
  }
}

class I18NLoadingView extends StatelessWidget {
  final I18NWidgetCreator _creator;
  I18NLoadingView(this._creator);

  @override
  Widget build(BuildContext context) {
    
    return BlocBuilder<I18NMessagesCubit, I18NMessagesState>(
      builder: (context, state){
        if(state is InitI18NMessagesState || state is LoadingI18NMessagesState){
          return ProgressView(message: 'Loading...');
        }

        if(state is LoadedI18NMessagesState){
          final messages = state._messages;
          return _creator.call(messages);
        }

        return ErrorView('Erro de buscando mensagens da tela');
      },
    );
  }
}

class I18NMessagesCubit extends Cubit<I18NMessagesState>{
  final String _viewKey;
  I18NMessagesCubit(this._viewKey) : super(InitI18NMessagesState());

  final LocalStorage storage = new LocalStorage('local_unsecure_version_1.json');

  reload(I18nWebClient client) async{
    emit(LoadingI18NMessagesState());
    await storage.ready;
    final items = storage.getItem(_viewKey); 
    print('LOADED $_viewKey $items');
    if (items != null){
      emit(LoadedI18NMessagesState(I18NMessages(items)));
      return;
    }

    client.findAll().then(saveAndRefresh);
  }

  saveAndRefresh(Map<String, dynamic> messages) {
    storage.setItem(_viewKey, messages);
    print('saving $_viewKey $messages');
    emit(LoadedI18NMessagesState(I18NMessages(messages)));
  }
}