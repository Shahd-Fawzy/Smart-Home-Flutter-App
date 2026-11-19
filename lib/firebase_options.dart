import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD7HGODh0EqywMXUbMBMmscsAI9f2mTd_c',
    appId: '1:1010382696000:web:5df7dd24bc79992d9ab9a5',
    messagingSenderId: '1010382696000',
    projectId: 'smart-home-project-bf1ba',
    authDomain: 'smart-home-project-bf1ba.firebaseapp.com',
    databaseURL: 'https://smart-home-project-bf1ba-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'smart-home-project-bf1ba.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD7HGODh0EqywMXUbMBMmscsAI9f2mTd_c',
    appId: '1:1010382696000:web:5df7dd24bc79992d9ab9a5',
    messagingSenderId: '1010382696000',
    projectId: 'smart-home-project-bf1ba',
    databaseURL: 'https://smart-home-project-bf1ba-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'smart-home-project-bf1ba.firebasestorage.app',
  );
}
