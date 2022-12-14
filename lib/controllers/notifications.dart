import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:image/image.dart' as image;
//import 'package:path_provider/path_provider.dart';
//import 'package:reminder_app/screens/home.dart' as home;
import 'package:rxdart/subjects.dart';
//import 'package:http/http.dart' as http;
import 'package:reminder_app/main.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

String? selectedNotificationPayload;

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin notifsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('gradient');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
            onDidReceiveLocalNotification: (
              int id,
              String? title,
              String? body,
              String? payload,
            ) async {
              didReceiveLocalNotificationSubject.add(
                ReceivedNotification(
                  id: id,
                  title: title,
                  body: body,
                  payload: payload,
                ),
              );
            });

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    await notifsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      openMain(payload: payload);
      //notification tapped logic needs to be implemented still
    });
  }

  void displayScheduleNotif(
      {required String body,
      required int channel,
      required String title,
      required DateTime date}) async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    tz.TZDateTime time = tz.TZDateTime.from(
      date,
      tz.local,
    );

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        "Notif memo", //Required for Android 8.0 or after
        "Notif memo", //Required for Android 8.0 or after
        channelDescription:
            "This is for notifications created by the app", //Required for Android 8.0 or after
        importance: Importance.high,
        priority: Priority.high);
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails(
      presentAlert:
          true, // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentBadge:
          true, // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentSound:
          true, // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      sound: null, // Specifics the file path to play (only from iOS 10 onwards)
      badgeNumber: 15, // The application's icon badge number
      //attachments: List<IOSNotificationAttachment>?, (only from iOS 10 onwards)
      subtitle: "Your note", //Secondary description  (only from iOS 10 onwards)
      //threadIdentifier: String? (only from iOS 10 onwards)
    );
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await notifsPlugin.zonedSchedule(
        channel, title, body, time, platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void displayNotification(
      {required String body,
      required int channel,
      required String title}) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        "Notif memo", //Required for Android 8.0 or after
        "Notif memo", //Required for Android 8.0 or after
        channelDescription:
            "This is for notifications created by the app", //Required for Android 8.0 or after
        importance: Importance.high,
        priority: Priority.high);
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails(
      presentAlert:
          false, // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentBadge:
          true, // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentSound:
          true, // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      sound: null, // Specifics the file path to play (only from iOS 10 onwards)
      badgeNumber: 15, // The application's icon badge number
      //attachments: List<IOSNotificationAttachment>?, (only from iOS 10 onwards)
      subtitle: "Your note", //Secondary description  (only from iOS 10 onwards)
      //threadIdentifier: String? (only from iOS 10 onwards)
    );
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await notifsPlugin.show(
      channel,
      title,
      body,
      platformChannelSpecifics,
      payload: body,
    );
  }

  void scheduleNotificationDaily(
      {required String body,
      required int channel,
      required String title,
      required DateTime date}) async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    tz.TZDateTime time = tz.TZDateTime.from(
      date,
      tz.local,
    );

    if (time.isBefore(DateTime.now())) {
      time = time.add(const Duration(days: 1));
    }

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        "Notif memo", //Required for Android 8.0 or after
        "Notif memo", //Required for Android 8.0 or after
        channelDescription:
            "This is for notifications created by the app", //Required for Android 8.0 or after
        importance: Importance.high,
        priority: Priority.high);
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails(
      presentAlert:
          true, // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentBadge:
          true, // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentSound:
          true, // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      sound: null, // Specifics the file path to play (only from iOS 10 onwards)
      badgeNumber: 15, // The application's icon badge number
      //attachments: List<IOSNotificationAttachment>?, (only from iOS 10 onwards)
      subtitle: "Your note", //Secondary description  (only from iOS 10 onwards)
      //threadIdentifier: String? (only from iOS 10 onwards)
    );
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await notifsPlugin.zonedSchedule(
        channel, title, body, time, platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  void deleteNotif(String id) async {
    notifsPlugin.cancel(int.parse(id));
  }
}
