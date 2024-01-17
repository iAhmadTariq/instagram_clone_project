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
    apiKey: 'AIzaSyBxr93co7EAzsX8p7zuHu9rDkUB0cC8Jcw',
    appId: '1:813350969738:web:e2cf73836275c5febe2873',
    messagingSenderId: '813350969738',
    projectId: 'instagram-clone-27d3e',
    authDomain: 'instagram-clone-27d3e.firebaseapp.com',
    storageBucket: 'instagram-clone-27d3e.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD_kp9Q5KUdhsRyVFpeyq-5yq6BJ3x1_pI',
    appId: '1:813350969738:android:40ae493e68b7b466be2873',
    messagingSenderId: '813350969738',
    projectId: 'instagram-clone-27d3e',
    storageBucket: 'instagram-clone-27d3e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDjwld7yvN7J-_CCe41fxGspU5YKVOJSog',
    appId: '1:813350969738:ios:7ff8a0f358e37ceabe2873',
    messagingSenderId: '813350969738',
    projectId: 'instagram-clone-27d3e',
    storageBucket: 'instagram-clone-27d3e.appspot.com',
    iosClientId: '813350969738-8blqbcil5o1bhg1ouddito4ie027m2v1.apps.googleusercontent.com',
    iosBundleId: 'com.example.instagramCloneProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDjwld7yvN7J-_CCe41fxGspU5YKVOJSog',
    appId: '1:813350969738:ios:4ca16cc6bd51e445be2873',
    messagingSenderId: '813350969738',
    projectId: 'instagram-clone-27d3e',
    storageBucket: 'instagram-clone-27d3e.appspot.com',
    iosClientId: '813350969738-72ech777euju08fifnusb6girqv04ger.apps.googleusercontent.com',
    iosBundleId: 'com.example.instagramCloneProject.RunnerTests',
  );
}