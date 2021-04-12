import 'package:flutter/material.dart';
import '../blocs/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController passwordController = TextEditingController();
  bool editingEnabled = false;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    passwordController.text = bloc.fetchExistingMasterPassword();
    return Scaffold(
      appBar: AppBar(
        title: Text('settings.'),
        centerTitle: true,
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(bloc) {
    return Container(
      margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: getChildren(bloc),
      ),
    );
  }

  List<Widget> getChildren(bloc) {
    List<Widget> children = [
      Text(
        'your master\npassword:',
        style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        height: 30.0,
      ),
      getPasswordCard(),
      SizedBox(
        height: 30.0,
      ),
      IconButton(
        icon: Icon(Icons.check, color: Colors.green, size: 35),
        onPressed: () {
          //show dialog
          Navigator.pop(context);
        },
      ),
    ];
    return children;
  }

  void showSnackBar(String content) {
    final snackBar = SnackBar(
      content: Text(
        '$content',
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
      backgroundColor: Colors.grey[700],
      action: SnackBarAction(
        textColor: Colors.blue,
        label: 'ok.',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget getPasswordCard() {
    return Card(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              enabled: editingEnabled,
              maxLines: null,
              controller: passwordController,
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.red,
            ),
            onPressed: () {
              //authenticate and then change enabled
            },
          )
        ],
      ),
    );
  }
}
