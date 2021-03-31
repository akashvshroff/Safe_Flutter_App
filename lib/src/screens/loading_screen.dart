import 'package:flutter/material.dart';
import 'dart:async';
import '../blocs/provider.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ' safe.',
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.0,
            ),
            IconButton(
                icon: Icon(
                  Icons.lock_outline,
                  color: Colors.white,
                  size: 40.0,
                ),
                onPressed: () {
                  changePage(context);
                })
          ],
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
