import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:startupspace/config/local_notification/local_notification.dart';

final permissionProvider =
    StateNotifierProvider<PermissionNotifier, PermissionState>((ref) {
  return PermissionNotifier();
});

class PermissionNotifier extends StateNotifier<PermissionState> {
  PermissionNotifier() : super(PermissionState()) {
    onForegroundMessage();
    requestNotificationFCM();
  }
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  int pushid = 0;

  Future<void> checkPermission() async {
    final permissionAarray = await Future.wait([
      Permission.camera.status,
      Permission.videos.status,
      Permission.location.status,
      Permission.locationAlways.status,
      Permission.locationWhenInUse.status,
      Permission.notification.status
    ]);

    state = state.copyWith(
        camera: permissionAarray[0],
        video: permissionAarray[1],
        location: permissionAarray[2],
        locationAlaways: permissionAarray[3],
        locationWhenInUse: permissionAarray[4],
        notification: permissionAarray[5]);
  }

  void _checkPerssionState(PermissionStatus status) {
    if (status == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }

  requestCamaraAcces() async {
    final status = await Permission.camera.request();
    state = state.copyWith(camera: status);

    _checkPerssionState(status);
  }

  requestNotificationFCM() async {
    final status = await Permission.notification.request();
    state = state.copyWith(notification: status);

  _checkPerssionState(status);
    await messaging.subscribeToTopic('all');

    await LocalNotification.requestLocalNotification();
  }

  void handleRemoteMessage(RemoteMessage message) {
    if (message.notification == null) return;
    LocalNotification.showLocalNotification(
        id: ++pushid,
        title: "Nuevo Espacio Startup Space",
        body: "¡Se habre un Nuevo espacio en Startup Space esta semana!",
        data: "data");
  }

  void onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  requestLocationAccess() async {
    final status = await Permission.location.request();
    state = state.copyWith(location: status);

    _checkPerssionState(status);
  }
}

class PermissionState {
  final PermissionStatus camera;
  final PermissionStatus video;
  final PermissionStatus location;
  final PermissionStatus locationAlaways;
  final PermissionStatus locationWhenInUse;
  final PermissionStatus notification;

  PermissionState(
      {this.camera = PermissionStatus.denied,
      this.video = PermissionStatus.denied,
      this.location = PermissionStatus.denied,
      this.locationAlaways = PermissionStatus.denied,
      this.locationWhenInUse = PermissionStatus.denied,
      this.notification = PermissionStatus.denied});

  get cameraGranted {
    return camera == PermissionStatus.granted;
  }

  get videoGranted {
    return video == PermissionStatus.granted;
  }

  get notificationGranted {
    return notification == PermissionStatus.granted;
  }

  get locationGranted {
    return location == PermissionStatus.granted;
  }

  get locationAlawaysGranted {
    return locationAlaways == PermissionStatus.granted;
  }

  get tlocationWhenInUseGranted {
    return locationWhenInUse == PermissionStatus.granted;
  }

  PermissionState copyWith(
          {PermissionStatus? camera,
          PermissionStatus? video,
          PermissionStatus? location,
          PermissionStatus? locationAlaways,
          PermissionStatus? locationWhenInUse,
          PermissionStatus? notification}) =>
      PermissionState(
          camera: camera ?? this.camera,
          location: location ?? this.location,
          locationAlaways: locationAlaways ?? this.locationAlaways,
          locationWhenInUse: locationWhenInUse ?? this.locationWhenInUse,
          video: video ?? this.video,
          notification: notification ?? this.notification);
}
