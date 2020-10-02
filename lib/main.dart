import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sole_entrepreneur/screens/business_overview_screen.dart';
import 'package:sole_entrepreneur/screens/splash_screen.dart';

// import './screens/selection_screen.dart';
import './screens/login_screen.dart';
import './screens/register_screen.dart';
import './screens/selection_screen.dart';
import './providers/auth.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // await Auth().signIn('kaleem.excel@gmail.com', 'Developer');
  // await Auth().register(
  //     'shary101@gmail.com', "csdwx9spq", "matshary", "test", "testlast");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
        ],
        child: Consumer<Auth>(builder: (ctx, auth, _) {
          // print(auth.isAuth);
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              primaryColor: Color.fromRGBO(124, 116, 146, 1),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
              appBarTheme: AppBarTheme(
                  color: Colors.white,
                  elevation: 0.0,
                  iconTheme:
                      IconThemeData(color: Color.fromRGBO(124, 116, 146, 1))),
            ),
            home: auth.isAuth
                ? BusinessOverViewScreen()
                : FutureBuilder(
                    builder: (context, authResultSnapshot) {
                      print(auth.isAuth);
                      return authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : LoginScreen();
                    },
                    future: auth.tryAutoLogin(),
                  ),
            routes: {
              LoginScreen.routeName: (ctx) => LoginScreen(),
              RegisterScreen.routeName: (ctx) => RegisterScreen(),
              BusinessOverViewScreen.routeName: (ctx) =>
                  BusinessOverViewScreen()
            },
          );
        }));
  }
}
