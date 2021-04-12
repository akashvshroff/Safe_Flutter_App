import 'package:flutter/material.dart';

import 'blocs/provider.dart';
import 'screens/loading_screen.dart';
import 'screens/master_password.dart';
import 'screens/verify_master.dart';
import 'screens/details_list.dart';
import 'screens/detail_focus.dart';
import 'screens/generate_password.dart';
import 'screens/detail_edit.dart';
import 'screens/settings.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "safe",
        theme: ThemeData(
          fontFamily: 'Recursive',
          brightness: Brightness.dark,
        ),
        onGenerateRoute: routes,
        onUnknownRoute: (settings) =>
            MaterialPageRoute(builder: (context) => DetailsList()),
      ),
    );
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
          bloc.fetchMasterPassword(); //call upon fn to add password to stream
          return MasterPassword();
        },
      );
    } else if (routeName.contains('verify')) {
      return MaterialPageRoute(builder: (context) {
        return VerifyMaster();
      });
    } else if (routeName.contains('details')) {
      return MaterialPageRoute(builder: (context) {
        final bloc = Provider.of(context);
        bloc.fetchDetails(); //call upon fn to fetch details and add to stream
        return DetailsList();
      });
    } else if (routeName.contains('detail')) {
      return MaterialPageRoute(builder: (context) {
        int detailId = int.parse(routeName.replaceAll('/detail/', ''));
        final bloc = Provider.of(context);
        bloc.detailFocusSink(null); //resets the previous fetched detail
        bloc.fetchDetailById(detailId); //fetch detail with particular id
        return DetailFocus();
      });
    } else if (routeName.contains('add')) {
      return MaterialPageRoute(builder: (context) {
        return DetailEdit(pageTitle: 'add.', detailId: null);
      });
    } else if (routeName.contains('generate')) {
      return MaterialPageRoute(builder: (context) {
        final bloc = Provider.of(context);
        bloc.generatePasswordSink(null); //resets previous generated password
        return GeneratePassword();
      });
    } else if (routeName.contains('edit')) {
      return MaterialPageRoute(builder: (context) {
        final bloc = Provider.of(context);
        bloc.detailFocusSink(null); //resets the previous fetched detail
        int detailId = int.parse(routeName.replaceAll('/edit/', ''));
        bloc.fetchDetailById(detailId); //fetch detail with particular id
        return DetailEdit(
          pageTitle: 'edit.',
          detailId: detailId,
        );
      });
    } else if (routeName.contains('settings')) {
      return MaterialPageRoute(builder: (context) {
        return SettingsPage();
      });
    }
  }
}
