import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDBOmdnZyIa6ZnLrARqtGRNB2ulgLctQUQ',
    appId: '1:310685105802:android:bb742440cd0dd15b36b773',
    messagingSenderId: '310685105802',
    projectId: 'party-radar-2a1ec',
    storageBucket: 'party-radar-2a1ec.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDBOmdnZyIa6ZnLrARqtGRNB2ulgLctQUQ',
    appId: '1:310685105802:android:bb742440cd0dd15b36b773',
    messagingSenderId: '310685105802',
    projectId: 'party-radar-2a1ec',
    storageBucket: 'party-radar-2a1ec.appspot.com',
    iosClientId: '310685105802-fqbrk50ghm26fsi0bts4iqvpro4igk76.apps.googleusercontent.com',
    iosBundleId: 'com.ruslanbadaev.tickets',
  );
}
