import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../blocs/provider.dart';
import 'package:local_auth/local_auth.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _localAuth = LocalAuthentication();
  final TextEditingController _passwordController = TextEditingController();
  bool editingEnabled = false;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    _passwordController.text = bloc.fetchExistingMasterPassword();
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
        height: 50.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            iconSize: 50.0,
            icon: Icon(Icons.cancel_outlined, color: Colors.red),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          IconButton(
            iconSize: 50.0,
            icon: Icon(Icons.done, color: Colors.green),
            onPressed: () async {
              var shouldContinue = await showAlertDialog(
                  'warning.',
                  'editing the master password is an intensive process and could take a few minutes to complete.\n\nplease do not press the back button during the process.',
                  'cancel',
                  'continue');
              if (shouldContinue) {
                // navigate and call upon bloc to change master
                String newPassword = _passwordController.text;
                Navigator.pushReplacementNamed(context, '/update/$newPassword');
              }
            },
          ),
        ],
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
              controller: _passwordController,
              style: TextStyle(fontSize: 20.0),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 6.0),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: () async {
              // authenticate and then change enabled
              try {
                if (await _localAuth.isDeviceSupported()) {
                  bool authenticateResult = await _localAuth.authenticate(
                    localizedReason:
                        'Please verify your identity to edit the Master Password.',
                    useErrorDialogs: true,
                    stickyAuth: true,
                  );
                  if (authenticateResult) {
                    showSnackBar(
                        'success, you can now edit the master password.');
                  } else {
                    showSnackBar('error, verification failed.');
                  }
                  setState(() {
                    editingEnabled = authenticateResult;
                  });
                } else {
                  showAlertDialog(
                      'info.',
                      'add a lock screen password or biometric security to your phone to edit your master password.',
                      ' ',
                      'ok');
                }
              } on PlatformException catch (e) {
                showAlertDialog('error.',
                    'something went wrong, please try again later.', ' ', 'ok');
              }
            },
          )
        ],
      ),
    );
  }

  Future<bool> showAlertDialog(
      String title, String content, String button1, String button2) async {
    AlertDialog alert = AlertDialog(
      title: Text(
        title,
        style: TextStyle(fontSize: 20.0),
      ),
      content: Text(
        content,
        style: TextStyle(fontSize: 18.0),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(button1,
                style:
                    TextStyle(color: Colors.redAccent[400], fontSize: 16.0))),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop(true);
          },
          child: Text(
            button2,
            style: TextStyle(color: Colors.green, fontSize: 16.0),
          ),
        )
      ],
    );

    bool value = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
    return value;
  }
}
