import 'package:flutter/material.dart';
import '../blocs/provider.dart';

class VerifyMaster extends StatefulWidget {
  @override
  _VerifyMasterState createState() => _VerifyMasterState();
}

class _VerifyMasterState extends State<VerifyMaster> {
  final entryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: getChildren(bloc, context),
        ),
      ),
    );
  }

  List<Widget> getChildren(Bloc bloc, context) {
    List<Widget> children = [
      Text(
        'enter master\npassword:',
        style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        height: 40.0,
      ),
      getEntry(bloc, context),
      SizedBox(
        height: 40.0,
      ),
      getErrorField(bloc),
    ];
    return children;
  }

  Card getEntry(Bloc bloc, context) {
    return Card(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: entryController,
              style: TextStyle(fontSize: 20.0),
              decoration: InputDecoration(hintText: 'enter master password. '),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.green,
            ),
            onPressed: () {
              bloc.checkMasterPassword(entryController.text.toLowerCase());
              FocusScope.of(context).unfocus();
            },
          )
        ],
      ),
    );
  }

  StreamBuilder getErrorField(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.verifyMasterStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(
            'error: incorrect password.\nplease try again.',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.red,
            ),
          );
        } else if (!snapshot.hasData) {
          return Container(
            height: 0.0,
            width: 0.0,
          );
        } else {
          Navigator.pushNamed(context, '/details');
        }
      },
    );
  }
}
