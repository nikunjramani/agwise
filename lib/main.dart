import 'dart:convert';

import 'package:agtech_farmer/constants/Constant.dart';
import 'package:agtech_farmer/services/SharedPrederence.dart';
import 'package:agtech_farmer/ui/chatscreen/chatscreen.dart';
import 'package:agtech_farmer/ui/language/language.dart';
import 'package:agtech_farmer/ui/login/login.dart';
import 'package:agtech_farmer/ui/map/viewmap.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  // }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: FutureBuilder<bool>(
        future: checklanguage(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if(snapshot.data == false) {
            return FutureBuilder<bool>(
              future: SharedPreference.getIsUserLogin(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if(snapshot.data==true){
                  return ChatScreen();
                }else{
                  return Login();
                }
              });
          }else{
            // Constant.englishyes= SharedPreference.getLanguage()=="Kannada"?false:true;
            return Language();
          }
        },
      ),
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
    );
  }
  @override
  initState() {
    // TODO: implement initState
    super.initState();
    initPreference();

  }
  Future<bool> checklanguage() async{
    return await SharedPreference.getLanguage()==null?true:false;
  }

  Future<void> initPreference() async {
    Constant.englishyes=await SharedPreference.getLanguage()=="Kannada"?false:true;
    Constant.farmerid=await SharedPreference.getFarmerId();
    Constant.farmername=await SharedPreference.getFarmerName();
    Constant.number=await SharedPreference.getNumber();
    Constant.firebasetoken=await FirebaseMessaging.instance.getToken();
    print(Constant.firebasetoken);
  }
}
