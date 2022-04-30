import 'package:bytebank9/components/container.dart';
import 'package:bytebank9/components/theme.dart';
import 'package:bytebank9/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/localization.dart';

void main() {
  runApp(BytebankApp());
}

class LogObserver extends BlocObserver {
  @override
  void onChange(Cubit cubit, Change change) {
    print("${cubit.runtimeType} > $change");
    super.onChange(cubit, change);
  }
}

class BytebankApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    // na prática evitar log do genero, pois pode vazar informações sensíveis para o log
    Bloc.observer = LogObserver();

    return MaterialApp(
      theme: bytebankTheme,
      // home: DashboardContainer(),
      home: LocalizationContainer(
        child: DashboardContainer()
      ),
    );
  }
}
