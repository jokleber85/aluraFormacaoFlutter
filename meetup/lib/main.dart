import 'package:meetups/http/web.dart';
import 'package:meetups/models/device.dart';
import 'package:meetups/screens/events_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true
  );

  if(settings.authorizationStatus == AuthorizationStatus.authorized){
    print('Permissão concedida pelo usuário');
    _startPushNotificationHandler(messaging); 
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional){
    print('Permissão provisória concedida pelo usuário');
    _startPushNotificationHandler(messaging); 
  } else {
    print('Permissão negada pelo usuário');
  }

  runApp(App());
}

void _startPushNotificationHandler(FirebaseMessaging messaging) async {
  String? token = await messaging.getToken(
    // AppWeb
    vapidKey: 'Certificados push da Web'
  );
  print('Token: $token');
  setPushToken(token);

  // Foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) { 
    print('Mensagem recebida enquanto o app aberto ${message.data}');

    if (message.notification != null){
      print('Mensagem também contem notificação:');
      print('${message.notification?.title}');
      print('${message.notification?.body}');
    }
  });

  //Background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgrounHandler);

  //Terminated
  final data = await FirebaseMessaging.instance.getInitialMessage();
  if (data!.data['message'].length > 0){
    showMyDialog(data.data['message']);
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dev meetups',
      home: EventsScreen(),
      navigatorKey: navigatorKey,
    );
  }
}

void setPushToken(String? token) async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? preferencesToken = preferences.getString('pushToken');
  bool? preferencesSent = preferences.getBool('tokenSent');

  print('PreferencesToken: $preferencesToken');

  if (preferencesToken != token || (preferencesToken == token && preferencesSent == false)){
    print('Enviando TOKEN');

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? brand;
    String? model;

    if (Platform.isAndroid){
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Android: ${androidInfo.model}');
      model = androidInfo.model;
      brand = androidInfo.brand;
    }else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('Android: ${iosInfo.utsname.machine}');
      model = iosInfo.utsname.machine;
      brand = 'Apple';
    }

    Device device = Device(brand: brand, model: model, token: token);

    sendDevice(device);
  }
}

Future<void> _firebaseMessagingBackgrounHandler(RemoteMessage message) async{
  print('Mensagem recebida em backgroun ${message.notification}');

}

void showMyDialog(String message){
  Widget okButton = OutlinedButton(
    onPressed: () => {
      Navigator.pop(navigatorKey.currentContext!),
    },
    child: Text('Ok!'), 
  );
  AlertDialog alerta = AlertDialog(
    title: Text('Promoção Imperdível'),
    content: Text(message),
    actions: [
      okButton,
    ],
  );
  showDialog(context: navigatorKey.currentContext!, builder: (BuildContext context){
    return alerta;
  });
}