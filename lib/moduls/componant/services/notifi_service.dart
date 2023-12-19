

import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:greengate/moduls/componant/componant.dart';
import 'package:rxdart/rxdart.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @pragma('vm:entry-point')
  static  void  notificationTapBackground(NotificationResponse notificationResponse) {
    showToast(text: notificationResponse.payload.toString()+'test', state:ToastState.SUCCESS);
    // ignore: avoid_print
    print('notification(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.payload}');
    if (notificationResponse.input?.isNotEmpty ?? false) {
      // ignore: avoid_print
      print('notification action tapped with input: ${notificationResponse.input}');
    }
  }
 static final onNotification=BehaviorSubject<String>();

  Future<void> initNotification() async {

    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('logog');

    var initializationSettingsIOS = DarwinInitializationSettings(


        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        defaultPresentAlert: true,
        defaultPresentSound: true,
        defaultPresentBadge: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {
          print(payload.toString() + 'from notifi***********');


            });

    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);



    await notificationsPlugin.initialize(initializationSettings,



        onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {






      if(notificationResponse.actionId!=null&&notificationResponse.actionId=='call'){
        onNotification.add(notificationResponse.payload.toString());
        print(notificationResponse.payload.toString()+notificationResponse.actionId.toString()+notificationResponse.id.toString());
        Uri uri=Uri(scheme: 'tel', path: '${notificationResponse.payload}');
        await launchUrl(uri);
       // print(notificationResponse.actionId.toString()+'hi');
      }



            },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground);
  }

  notificationDetails(id) {

   Int64List vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;
    return  NotificationDetails(

        android: AndroidNotificationDetails('$id', 'channelName',
            importance: Importance.max,
          priority: Priority.high,
          enableLights: true,
          enableVibration: true,
           sound:const RawResourceAndroidNotificationSound('soundraw'),

           // androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          vibrationPattern:vibrationPattern ,
          playSound: true,
          icon: 'logog',


          actions: const[AndroidNotificationAction('call', 'call',showsUserInterface: true )]



        ),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails(id));
  }

  Future scheduleNotification(
      {int id = 0,
      String? title,
      String? body,

      String? payLoad,


      required DateTime scheduledNotificationDateTime}) async {
    return notificationsPlugin.zonedSchedule(
        id,
        title,

        body,
        tz.TZDateTime.from(scheduledNotificationDateTime, tz.local,),
        await notificationDetails(id),


        androidAllowWhileIdle: true,

        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
            payload: payLoad
    );
  }
}
