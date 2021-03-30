import 'package:flutter/material.dart';
import '../blocs/provider.dart';

class DetailEdit extends StatefulWidget {
  final String pageTitle;
  final int detailId;

  DetailEdit({
    this.pageTitle,
    this.detailId,
  });

  @override
  _DetailEditState createState() => _DetailEditState(pageTitle, detailId);
}

class _DetailEditState extends State<DetailEdit> {
  final String pageTitle;
  final int detailId;
  final serviceController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  _DetailEditState(this.pageTitle, this.detailId);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('$pageTitle'),
        centerTitle: true,
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(bloc) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: getChildren(bloc),
        ),
      ),
    );
  }

  List<Widget> getChildren(bloc) {
    List<Widget> children = [
      SizedBox(
        height: 10.0,
      ),
      Text(
        'service:',
        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        height: 20.0,
      ),
      getInputField(serviceController, 22.0),
      SizedBox(
        height: 40.0,
      ),
      Text(
        'username:',
        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        height: 20.0,
      ),
      getInputField(usernameController, 22.0),
      SizedBox(
        height: 40.0,
      ),
      Row(
        children: [
          Text(
            'password:',
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 40,
          ),
          getGenerateButton(),
        ],
      ),
      SizedBox(
        height: 20.0,
      ),
      getInputField(passwordController, 21.0),
      SizedBox(
        height: 40.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            iconSize: 50.0,
            icon: Icon(Icons.cancel_outlined, color: Colors.red),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(
            width: 50,
          ),
          IconButton(
            iconSize: 50.0,
            icon: Icon(Icons.done, color: Colors.green),
            onPressed: () {
              saveDetail(bloc);
            },
          ),
        ],
      ),
      fetchDetailsForEdit(bloc),
    ];
    return children;
  }

  StreamBuilder fetchDetailsForEdit(bloc) {
    return StreamBuilder(
      stream: bloc.editDetail,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final map = snapshot.data;
          serviceController.text = map['service'];
          usernameController.text = map['username'];
          passwordController.text = map['password'];
        }
        return Container(
          height: 0.0,
          width: 0.0,
        );
      },
    );
  }

  TextField getInputField(controller, double size) {
    return TextField(
      controller: controller,
      style: TextStyle(fontSize: size),
      maxLines: null,
    );
  }

  Widget getGenerateButton() {
    return ElevatedButton(
      onPressed: () {
        generatePassword();
      },
      child: Text('generate.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          )),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
    );
  }

  Future<void> generatePassword() async {
    var newPassword = await Navigator.pushNamed(context, '/generate');
    if (newPassword != null) {
      passwordController.text = newPassword;
      showSnackBar('password successfully generated.');
    }
  }

  void showSnackBar(String content) {
    final snackBar = SnackBar(content: Text('$content'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void saveDetail(bloc) {
    String service = serviceController.text;
    String username = usernameController.text;
    String password = passwordController.text;
    if (service == '' || username == '' || password == '') {
      showSnackBar("error: can't save if any fields are empty.");
      return;
    }
    if (detailId != null) {
      //edit detail
      bloc.updateDetail(detailId, service, username, password);
      bloc.fetchDetails();
      Navigator.pop(context);
    } else {
      //add detail
      bloc.addDetail(service, username, password);
      bloc.fetchDetails();
      Navigator.pop(context);
    }
  }
}
