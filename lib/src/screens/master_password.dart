import 'dart:ui';

import 'package:flutter/material.dart';
import '../blocs/provider.dart';

class MasterPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return Scaffold(
      body: Center(
        child: StreamBuilder(
          stream: bloc.masterPasswordStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            return passwordInfo(snapshot.data, context);
          },
        ),
      ),
    );
  }

  Widget passwordInfo(String password, context) {}

  void changePage(context) {}
}
