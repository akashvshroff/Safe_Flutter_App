import 'package:flutter/material.dart';
import 'dart:async';
import '../blocs/provider.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          changePage(context);
        },
        child: Center(
          child: Text(
            'safe.',
            style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void changePage(context) {
    final bloc = Provider.of(context);
    bloc.getMasterPasswordHash().then((hash) {
      if (hash != null) {
        //master password exists
        Navigator.pushNamed(context, '/verify');
      } else {
        //no master exists
        Navigator.pushNamed(context, '/master');
      }
    });
  }
}
