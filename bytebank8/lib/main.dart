import 'package:bytebank8/screens/counter.dart';
import 'package:bytebank8/screens/dashboard.dart';
import 'package:bytebank8/screens/name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'components/theme.dart';

void main() {
  runApp(BytebankApp());
}

class LogObserver extends BlocObserver{
  @override

  void onChange(Cubit cubit, Change change){
    print('${cubit.runtimeType} > $change');
    super.onChange(cubit, change);
  }
}


class BytebankApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    Bloc.observer = LogObserver();
    return MaterialApp(
      theme: bytebankTheme,
      home: DashboardContainer(),
      // home: NameContainer(  ),
    );
  }
}
