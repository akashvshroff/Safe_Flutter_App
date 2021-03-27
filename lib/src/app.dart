import 'package:flutter/material.dart';
import 'package:safe/src/screens/master_password.dart';
import 'package:safe/src/screens/verify_master.dart';
import 'blocs/provider.dart';
import 'screens/loading_screen.dart';
import 'screens/master_password.dart';
import 'screens/verify_master.dart';
import 'screens/details_list.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: "safe",
        theme: ThemeData(
          fontFamily: 'Roboto',
          brightness: Brightness.dark,
        ),
        onGenerateRoute: routes,
      ),
    );

    //show loading screen with either a gesture detector or FutureBuilder with a delayed future that changes
    //screen on tap and then checks for master.
  }

  Route routes(RouteSettings settings) {
    String routeName = settings.name;
    if (routeName == '/') {
      return MaterialPageRoute(
        builder: (context) {
          return LoadingScreen();
        },
      );
    } else if (routeName.contains('master')) {
      return MaterialPageRoute(
        builder: (context) {
          final bloc = Provider.of(context);
          bloc.fetchMasterPassword();
          return MasterPassword();
        },
      );
    } else if (routeName.contains('verify')) {
      return MaterialPageRoute(builder: (context) {
        return VerifyMaster();
      });
    } else if (routeName.contains('details')) {
      return MaterialPageRoute(builder: (context) {
        //call upon all details fetcher
        return DetailsList();
      });
    }
  }
}
