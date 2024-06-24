import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  static Future<void> requestLocalNotification() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> inicializeLocalNotification() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettingsAndroid =
        AndroidInitializationSettings("app_icon");

    const initializationSettingsDarwin = DarwinInitializationSettings(
        onDidReceiveLocalNotification: iosShowNotification);

    const inicilizationSetting = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin
    );
    await flutterLocalNotificationsPlugin.initialize(
      inicilizationSetting,
      // onDidReceiveNotificationResponse: ondi
    );
  }

  static void iosShowNotification(
      int id, String? title, String? body, String? data) {
    showLocalNotification(id: id, title: title, body: body, data: data);
  }

  static void showLocalNotification(
      {required int id,
      required String? title,
      required String? body,
      required String? data}) {
    const androidDetails = AndroidNotificationDetails(
        "channelId", "channelName",
        playSound: true,
        sound: RawResourceAndroidNotificationSound("notification"),
        importance: Importance.max,
        priority: Priority.high);
    const notificationDetails = NotificationDetails(android: androidDetails,iOS: DarwinNotificationDetails(presentSound: true,));
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.show(id, title, body, notificationDetails,
        payload: data);
  }
}
