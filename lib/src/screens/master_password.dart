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

  Widget passwordInfo(String password, BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: getChildren(password, context),
      ),
    );
  }

  void changePage(context) {
    Navigator.pushNamed(context, '/verify');
  }

  List<Widget> getChildren(String password, BuildContext context) {
    List<Widget> children = [
      SizedBox(
        height: 30.0,
      ),
      Text(
        'your master\npassword:',
        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        height: 40.0,
      ),
      SizedBox(
        height: 100.0,
        child: Card(
          margin: EdgeInsets.all(5.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              ' $password ',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      SizedBox(
        height: 30.0,
      ),
      Text(
        'notes:',
        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        height: 20.0,
      ),
      ListTile(
        leading: Icon(Icons.fiber_manual_record),
        title: Text(
          'remember this password carefully.',
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: 5.0,
      ),
      ListTile(
        leading: Icon(Icons.fiber_manual_record),
        title: Text(
          'it is used to verify your identity.',
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: 5.0,
      ),
      ListTile(
        leading: Icon(Icons.fiber_manual_record),
        title: Text(
          'losing this password means losing your data.',
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: 50.0,
      ),
      Center(
        child: IconButton(
            color: Colors.blue,
            icon: Icon(
              Icons.check,
              size: 40.0,
            ),
            onPressed: () {
              changePage(context);
            }),
      )
    ];
    return children;
  }
}
