// @dart=2.9
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_viruses/pages/auth/login.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
    supportedLocales: [Locale('ru'), Locale('en')],
    path: 'assets/translations',
    fallbackLocale: Locale('en'),
    child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _init = Firebase.initializeApp();
    return FutureBuilder(
      future: _init,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorWidget();
        } else {
          return AdaptiveTheme(
            light: ThemeData(
              brightness: Brightness.light,
              
              primarySwatch: Colors.lightGreen,
              accentColor: Colors.lightGreen,
              hintColor: Color(0xFF2B2B2B)
            ),
            dark: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.lightGreen,
              accentColor: Colors.lightGreen,
              hintColor: Color(0xFFE1E1E1)
            ),
            initial: AdaptiveThemeMode.light,
            builder: (theme, darkTheme) => MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: theme,
              darkTheme: darkTheme,
              debugShowCheckedModeBanner: false,
              home: Login(),
            )
          );
        }
      },
    );
  }
}

class ErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Something went wrong...")
          ],)
      )
    );
  }
}