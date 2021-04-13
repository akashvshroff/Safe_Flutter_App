import 'package:flutter/material.dart';
import '../blocs/provider.dart';

class VerifyMaster extends StatefulWidget {
  @override
  _VerifyMasterState createState() => _VerifyMasterState();
}

class _VerifyMasterState extends State<VerifyMaster> {
  final entryController = TextEditingController();
  int count = 0;
  bool locked = false;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              decoration: InputDecoration(
                  hintText: 'enter master password. ',
                  contentPadding: EdgeInsets.only(left: 6.0)),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.green,
            ),
            onPressed: () {
              FocusScope.of(context).unfocus();
              count++;
              if (count >= 3) {
                setState(() {
                  locked = true;
                });
              } else {
                bloc.checkMasterPassword(entryController.text.toLowerCase());
              }
            },
          )
        ],
      ),
    );
  }

  SizedBox getErrorField(Bloc bloc) {
    if (locked) {
      return SizedBox(
        height: 100.0,
        child: getLocked(),
      );
    }
    return SizedBox(
      height: 100.0,
      child: StreamBuilder(
        stream: bloc.verifyMasterStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return getIncorrect();
          } else if (!snapshot.hasData) {
            return Container(
              height: 0.0,
              width: 0.0,
            );
          } else {
            return getCorrect();
          }
        },
      ),
    );
  }

  Row getLocked() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'too many attempts.\nplease try again later.',
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.red,
          ),
        ),
        Icon(
          Icons.error_outline,
          color: Colors.white,
          size: 40.0,
        ),
      ],
    );
  }

  Row getIncorrect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'incorrect password.\n${3 - count} attempts remain.',
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.red,
          ),
        ),
        Icon(
          Icons.error_outline,
          color: Colors.white,
          size: 40.0,
        ),
      ],
    );
  }

  Row getCorrect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'verified password.\ntap lock to access\nsafe.',
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.green,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.lock_open_outlined,
            color: Colors.white,
            size: 40.0,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/details');
          },
        ),
      ],
    );
  }
}
