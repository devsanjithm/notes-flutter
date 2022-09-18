import 'package:flutter/material.dart';
import 'ui/home_page.dart';
import 'ui/note_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('NoteBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          primaryColor: Colors.yellow,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.kalamTextTheme(
            Theme.of(context).textTheme,
          )),
      initialRoute: '/',
      getPages: [
        GetPage(
            name: '/',
            page: () => HomePage(),
            transition: Transition.cupertino,
            transitionDuration: Duration(milliseconds: 500)),
        // GetPage(
        //     name: '/edit',
        //     page: () => Editpage(),
        //     transition: Transition.cupertino,
        //     transitionDuration: Duration(milliseconds: 500)),
        // GetPage(
        //     name: '/add',
        //     page: () => Addpage(),
        //     transition: Transition.cupertino,
        //     transitionDuration: Duration(milliseconds: 500)),
        GetPage(
            name: '/note',
            page: () => Notepage(),
            transition: Transition.cupertino,
            transitionDuration: Duration(milliseconds: 500))
      ],
      title: 'Notes',
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 500),
      // home: const HomePage(),
    );
  }
}
