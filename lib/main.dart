import 'package:admin/constants.dart';
import 'package:admin/controllers/MenuAppController.dart';
import 'package:admin/login/login.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized;
  runApp(const myApp());
}

class myApp extends StatefulWidget {
  const myApp({super.key});

  @override
  State<myApp> createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyB47FarQMr5do4dryRRBFdKepX37Qt_knE",
          authDomain: "jobportal-2cd48.firebaseapp.com",
          projectId: "jobportal-2cd48",
          storageBucket: "jobportal-2cd48.appspot.com",
          messagingSenderId: "830828775449",
          appId: "1:830828775449:web:a81a460da69faebbc38288",
          measurementId: "G-GY5GP38812"));
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("successful");
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.blue),
            home: const Scaffold(
              body: Center(
                child: Text(
                  "jobportal app is being initialized",
                  style: TextStyle(
                      color: Colors.cyan,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ansaf'),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          print("not successful");
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                  "An error has occured",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "JOBHUB",
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: bgColor,
            textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
                .apply(bodyColor: Colors.white),
            canvasColor: secondaryColor,
          ),
          home: MultiProvider(providers: [
            ChangeNotifierProvider(
              create: (context) => MenuAppController(),
            ),
          ], child: Login()),
        );
      },
    );
  }
}
