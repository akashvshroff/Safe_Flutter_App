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

  Widget passwordInfo(String password, context) {
    List<Widget> children = [
      SizedBox(
        height: 50.0,
      ),
      Text(
        'your master\npassword:',
        style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        height: 40.0,
      ),
      SizedBox(
        height: 100.0,
        child: Card(
          child: Padding(
            padding: EdgeInsets.fromLTRB(8.0, 30.0, 12.0, 20.0),
            child: Text(
              ' $password ',
              style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      SizedBox(
        height: 40.0,
      ),
      Text(
        'notes:',
        style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        height: 20.0,
      ),
      ListTile(
        leading: Icon(Icons.fiber_manual_record),
        title: Text(
          'remember this password carefully.',
          style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
        ),
      ),
      ListTile(
        leading: Icon(Icons.fiber_manual_record),
        title: Text(
          'it is used to verify your identity',
          style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
        ),
      ),
      ListTile(
        leading: Icon(Icons.fiber_manual_record),
        title: Text(
          'losing this password means losing your data.',
          style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: 20.0,
      ),
      Center(
        child: IconButton(
            color: Colors.blue,
            icon: Icon(Icons.check),
            onPressed: () {
              changePage(context);
            }),
      )
    ];
    return Container(
      margin: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  void changePage(context) {}
}
