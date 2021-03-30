import 'package:flutter/material.dart';
import '../blocs/provider.dart';

class GeneratePassword extends StatefulWidget {
  @override
  _GeneratePasswordState createState() => _GeneratePasswordState();
}

class _GeneratePasswordState extends State<GeneratePassword> {
  String generatedPassword;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("generate."),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: buildBody(bloc, context),
    );
  }

  Widget buildBody(Bloc bloc, context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: getChildren(bloc, context),
      ),
    );
  }

  List<Widget> getChildren(Bloc bloc, context) {
    List<Widget> children = [
      SizedBox(
        height: 10.0,
      ),
      Text(
        'choose your\nmethod:',
        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        height: 20.0,
      ),
      memorizable(bloc),
      SizedBox(
        height: 10.0,
      ),
      random(bloc),
      SizedBox(
        height: 20.0,
      ),
      Text(
        'password:',
        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        height: 20.0,
      ),
      passwordBuilder(bloc),
      SizedBox(
        height: 20.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.cancel, color: Colors.red),
            onPressed: () {
              cancel(context);
            },
          ),
          SizedBox(
            width: 50,
          ),
          IconButton(
            icon: Icon(Icons.done, color: Colors.blue),
            onPressed: () {
              submit(context);
            },
          ),
        ],
      ),
    ];
    return children;
  }

  ListTile memorizable(bloc) {
    return ListTile(
      leading: Icon(Icons.fiber_manual_record),
      title: Text(
        'memorizable',
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'a 5 word, easy to remember password.',
        style: TextStyle(fontSize: 20.0),
      ),
      trailing: IconButton(
        onPressed: () {
          generatePassword(bloc, 1);
        },
        icon: Icon(
          Icons.play_arrow,
          color: Colors.white,
        ),
      ),
    );
  }

  ListTile random(bloc) {
    return ListTile(
      leading: Icon(Icons.fiber_manual_record),
      title: Text(
        'random',
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'a 16 character alphanumeric combination.',
        style: TextStyle(fontSize: 20.0),
      ),
      trailing: IconButton(
        onPressed: () {
          generatePassword(bloc, 2);
        },
        icon: Icon(
          Icons.play_arrow,
          color: Colors.white,
        ),
      ),
    );
  }

  StreamBuilder passwordBuilder(bloc) {
    return StreamBuilder(
      stream: bloc.generatePasswordStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return showPassword('');
        }
        generatedPassword = snapshot.data;
        return showPassword(snapshot.data);
      },
    );
  }

  SizedBox showPassword(String password) {
    double size = password.length <= 16 ? 20.0 : 16.0;
    return SizedBox(
      height: 100.0,
      child: Card(
        margin: EdgeInsets.all(5.0),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            '$password',
            style: TextStyle(fontSize: size),
          ),
        ),
      ),
    );
  }

  void generatePassword(bloc, id) {
    if (id == 1) {
      bloc.fetchDiceWarePassword();
    } else {
      bloc.fetchRandomPassword();
    }
  }

  void cancel(context) {
    Navigator.pop(context, null);
  }

  void submit(context) {
    if (generatedPassword != null) {
      // print(generatedPassword);
      Navigator.pop(context, generatedPassword);
    }
  }
}
