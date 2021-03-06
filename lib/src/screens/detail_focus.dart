import 'package:flutter/material.dart';
import '../models/detail_model.dart';
import '../blocs/provider.dart';
import 'package:flutter/services.dart';

class DetailFocus extends StatefulWidget {
  @override
  _DetailFocusState createState() => _DetailFocusState();
}

class _DetailFocusState extends State<DetailFocus> {
  Bloc bloc;
  String passwordText = '*' * 12;
  List<bool> _selected = [false, true, false];
  DetailModel detail;

  @override
  Widget build(BuildContext context) {
    this.bloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("detail."),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              editPassword(context);
            },
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: StreamBuilder<Object>(
            stream: this.bloc.detailFocus,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              this.detail = snapshot.data;
              return buildBody();
            }),
      ),
    );
  }

  Column buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: getChildren(),
    );
  }

  List<Widget> getChildren() {
    List<Widget> children = [
      Text(
        'service:',
        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
      ),
      Spacer(
        flex: 4,
      ),
      showUserInfo(detail.service),
      Spacer(
        flex: 5,
      ),
      Text(
        'username:',
        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
      ),
      Spacer(
        flex: 4,
      ),
      showUserInfo(detail.username),
      Spacer(
        flex: 5,
      ),
      Row(
        children: [
          Text(
            'password:',
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          getToggle(),
        ],
      ),
      Spacer(
        flex: 4,
      ),
      showUserInfo(passwordText),
      Spacer(flex: 4),
    ];
    return children;
  }

  SizedBox showUserInfo(String toShow) {
    double size;
    if (toShow.length <= 12) {
      size = 24.0;
    } else if (toShow.length <= 18) {
      size = 22.0;
    } else if (toShow.length <= 24) {
      size = 20.0;
    } else if (toShow.length <= 30) {
      size = 18.0;
    } else {
      size = 16.0;
    }
    return SizedBox(
      height: 100.0,
      child: Card(
        margin: EdgeInsets.all(5.0),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            ' $toShow ',
            style: TextStyle(fontSize: size),
          ),
        ),
      ),
    );
  }

  Widget getToggle() {
    return ToggleButtons(
      children: [
        Icon(
          Icons.visibility,
          color: Colors.white,
        ),
        Icon(
          Icons.visibility_off,
          color: Colors.white,
        ),
        Icon(
          Icons.copy,
          color: Colors.white,
        )
      ],
      isSelected: _selected,
      onPressed: (int index) {
        toggleFunction(index);
      },
    );
  }

  void toggleFunction(int index) async {
    if (index == 0) {
      _selected[0] = true;
      _selected[1] = false;
      String decryptedPassword = await this.bloc.fetchDecryptedPassword(detail);
      setState(() {
        passwordText = decryptedPassword;
      });
    } else if (index == 1) {
      _selected[1] = true;
      _selected[0] = false;
      setState(() {
        passwordText = '*' * 12;
      });
    } else {
      if (_selected[0] != true) {
        showSnackBar("error: can't copy password if not visible.");
        return;
      }
      Clipboard.setData(ClipboardData(text: passwordText));
      showSnackBar('password copied to clipboard.');
    }
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

  void editPassword(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/edit/${detail.id}');
  }
}
