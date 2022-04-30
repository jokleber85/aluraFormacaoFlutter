import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class BlocContainer extends StatelessWidget { }

void push(BuildContext blocContext, BlocContainer container) {
  Navigator.of(blocContext).push(
    MaterialPageRoute(
      builder: (context) => container,
    ),
  );
}