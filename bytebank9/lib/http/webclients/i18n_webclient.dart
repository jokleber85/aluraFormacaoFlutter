import 'dart:convert';

import 'package:bytebank9/http/webclient.dart';
import 'package:bytebank9/models/transaction.dart';
import 'package:http/http.dart';

const messages_uri = 'https://gist.githubusercontent.com/jokleber85/91a164132a3dd32522a71dbadba5180a/raw/fb47eedeb56fc1a27b8349916b7a7bdc95bec43a/';

class I18nWebClient {
  final String _viewKey;
  I18nWebClient(this._viewKey);

  Future<Map<String, dynamic>> findAll() async {
    final Response response = await client.get(Uri.parse("$messages_uri${_viewKey}.json"));
    final Map<String, dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson;
  }
}
