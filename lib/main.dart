import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:intelliguard/models/entry.dart';
import 'package:intelliguard/screens/guest_register.dart';
import 'package:intelliguard/screens/homepage.dart';
import 'package:intelliguard/screens/news_display.dart';
import 'package:intelliguard/screens/scan.dart';
import 'package:intelliguard/screens/show_entries.dart';
import 'package:intelliguard/screens/take_photo.dart';
import 'package:provider/provider.dart';
import 'package:intelliguard/models/user.dart';
import 'package:intelliguard/models/verified.dart';

import 'screens/login_screen.dart';
import 'screens/guest_register.dart';
import 'screens/show_entries.dart';
import 'screens/startup_screen.dart';
import 'screens/take_photo.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  runApp(MyApp(
    camera: cameras,
  ));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> camera;

  MyApp({@required this.camera});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: EntryHistory()),
        ChangeNotifierProvider.value(value: Users()),
        ChangeNotifierProvider.value(value: CreateUser()),
        ChangeNotifierProvider.value(value: Verified()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: LoginPage(),
        ),
        routes: {
          LoginPage.routeName: (ctx) => LoginPage(),
          ShowEntries.routeName: (ctx) => ShowEntries(),
          GuestSU.routeName: (ctx) => GuestSU(),
          Startup.routeName: (ctx) => Startup(),
          CameraScreen.routeName: (ctx) => CameraScreen(
                cameras: camera,
              ),
          Homepage.routeName: (ctx) => Homepage(),
          ScanBeacon.routeName: (ctx) => ScanBeacon(),
        },
      ),
    );
  }
}
