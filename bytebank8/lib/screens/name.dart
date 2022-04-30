import 'package:bytebank8/components/container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

import '../models/name.dart';

class NameContainer extends BlocContainer {
  @override
  Widget build(BuildContext context) {
    return NameView();
  }
}

class NameView extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _nameController.text = context.bloc<NameCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Name'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Desired Name:'),
            style: TextStyle(fontSize: 24.0)),
          Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: SizedBox(
              width: double.maxFinite,
              child: RaisedButton(
                child: Text('CHANGE'),
                onPressed: () {
                  final name = _nameController.text;
                  context.bloc<NameCubit>().change(name);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
