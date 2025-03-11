// import 'dart:developer';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/get_navigation.dart';
//
// import 'app_strings.dart';
//
// class NotificationClass {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final AndroidNotificationChannel channel = const AndroidNotificationChannel(
//     'anad_channel',
//     'OGA',
//     description: 'OGA',
//     importance: Importance.max,
//   );
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   notificationListener() async {
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//
//     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//         alert: true,
//         badge: true,
//         sound: true
//     );
//
//     NotificationSettings settings = await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
//       var initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid,
//         iOS: const DarwinInitializationSettings(
//           requestAlertPermission: true,
//           requestBadgePermission: true,
//           requestSoundPermission: true,
//         ),
//       );
//
//       flutterLocalNotificationsPlugin.initialize(
//         initializationSettings,
//         onDidReceiveNotificationResponse: (NotificationResponse response) {
//           log("Notification tapped with payload onDidReceiveNotificationResponse: ${response.payload}");
//           _handleNavigation(response.payload);
//         },
//       );
//
//       FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//         RemoteNotification? notification = message.notification;
//         AndroidNotification? android = message.notification?.android;
//
//         if (notification != null && android != null) {
//           String payload = message.data['route'] ?? kProfileScreenRoute;
//           log('Notification received with payload Json: ${message.data['notification']}');
//           log('Notification received with payload data: ${message.data['data']}');
//           log('Notification received with payload: $payload');
//
//           flutterLocalNotificationsPlugin.show(
//             notification.hashCode,
//             notification.title,
//             notification.body,
//             NotificationDetails(
//               android: AndroidNotificationDetails(
//                 channel.id,
//                 channel.name,
//                 channelDescription: channel.description,
//                 icon: android.smallIcon,
//                 color: Colors.white,
//                 colorized: true,
//                 enableVibration: true,
//                 styleInformation: const BigTextStyleInformation(''),
//               ),
//             ),
//             payload: payload,
//           );
//         }
//       });
//       // Handle background & terminated state notifications
//       FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//         String? route = message.data['route'];
//         log("Background notification received: $route");
//         _handleNavigation(route);
//       });
//
//       RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//       if (initialMessage != null) {
//         log("Terminated state notification: ${initialMessage.data['route']}");
//         _handleNavigation(initialMessage.data['route']);
//       }
//     }
//   }
//
//   void _handleNavigation(String? payload) {
//     if (payload != null && payload.isNotEmpty) {
//       // Navigator.pushNamed(context, payload);
//       Get.toNamed(payload);
//     }
//   }
// }
