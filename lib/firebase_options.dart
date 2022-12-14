// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAJjnLVof7tSi5wFNvowpgJZnJgf4PRUn0',
    appId: '1:997705828041:web:de67896ba4593688636f18',
    messagingSenderId: '997705828041',
    projectId: 'reminder-app-cf965',
    authDomain: 'reminder-app-cf965.firebaseapp.com',
    storageBucket: 'reminder-app-cf965.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB-p1CWeMEvWGxl-e0CKV0nZQ_KSYE_WTs',
    appId: '1:997705828041:android:8356305a697e4f02636f18',
    messagingSenderId: '997705828041',
    projectId: 'reminder-app-cf965',
    storageBucket: 'reminder-app-cf965.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyColNtZIWi1HIvt6KRmTRbVoaLUSEAgT_E',
    appId: '1:997705828041:ios:8b818db00bf8e129636f18',
    messagingSenderId: '997705828041',
    projectId: 'reminder-app-cf965',
    storageBucket: 'reminder-app-cf965.appspot.com',
    iosClientId: '997705828041-n5dlhai9q7hsl7unq3ugh9m3444kk2v3.apps.googleusercontent.com',
    iosBundleId: 'com.te.reminder-app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyColNtZIWi1HIvt6KRmTRbVoaLUSEAgT_E',
    appId: '1:997705828041:ios:44b077fd40d74ba5636f18',
    messagingSenderId: '997705828041',
    projectId: 'reminder-app-cf965',
    storageBucket: 'reminder-app-cf965.appspot.com',
    iosClientId: '997705828041-ndi41vnseetho5ctn694kbbk11t12ffu.apps.googleusercontent.com',
    iosBundleId: 'com.example.reminderApp',
  );
}
