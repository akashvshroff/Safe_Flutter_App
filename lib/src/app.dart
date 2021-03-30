import 'package:flutter/material.dart';

import 'blocs/provider.dart';
import 'models/detail_model.dart';

import 'screens/loading_screen.dart';
import 'screens/master_password.dart';
import 'screens/verify_master.dart';
import 'screens/details_list.dart';
import 'screens/detail_focus.dart';
import 'screens/generate_password.dart';
import 'screens/detail_edit.dart';

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
        // home: GeneratePassword(),
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
        final bloc = Provider.of(context);
        bloc.fetchDetails();
        return DetailsList();
      });
    } else if (routeName.contains('detail')) {
      return MaterialPageRoute(builder: (context) {
        int detailId = int.parse(routeName.replaceAll('/detail/', ''));
        final bloc = Provider.of(context);
        bloc.detailFocusSink(null);
        bloc.fetchDetailById(detailId);
        return DetailFocus();
      });
    } else if (routeName.contains('add')) {
      return MaterialPageRoute(builder: (context) {
        return DetailEdit(pageTitle: 'add.', detailId: null);
      });
    } else if (routeName.contains('generate')) {
      return MaterialPageRoute(builder: (context) {
        final bloc = Provider.of(context);
        bloc.generatePasswordSink(null);
        return GeneratePassword();
      });
    } else if (routeName.contains('edit')) {
      return MaterialPageRoute(builder: (context) {
        final bloc = Provider.of(context);
        bloc.detailFocusSink(null);
        int detailId = int.parse(routeName.replaceAll('/edit/', ''));
        bloc.fetchDetailById(detailId);
        return DetailEdit(
          pageTitle: 'edit.',
          detailId: detailId,
        );
      });
    }
  }
}
