import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../blocs/provider.dart';
import '../models/detail_model.dart';

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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: getChildren(bloc),
        ),
      ),
    );
  }

  List<Widget> getChildren(bloc) {
    List<Widget> children = [
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'password:',
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
          getGenerateButton(),
        ],
      ),
      SizedBox(
        height: 20.0,
      ),
      getInputField(passwordController, 21.0),
      SizedBox(
        height: 60.0,
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
      stream: bloc.detailFocus,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final detail = snapshot.data;
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            setControllerValues(bloc, detail);
          });
        }
        return Container(
          height: 0.0,
          width: 0.0,
        );
      },
    );
  }

  void setControllerValues(Bloc bloc, DetailModel detail) async {
    serviceController.text = detail.service;
    usernameController.text = detail.username;
    passwordController.text = await bloc.fetchDecryptedPassword(detail);
  }

  Widget getInputField(controller, double size) {
    return Flexible(
      child: TextField(
        decoration: InputDecoration(border: OutlineInputBorder()),
        controller: controller,
        style: TextStyle(fontSize: size),
        maxLines: null,
      ),
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
    FocusScope.of(context).unfocus();
    var newPassword = await Navigator.pushNamed(context, '/generate');
    if (newPassword != null) {
      passwordController.text = newPassword;
      showSnackBar('password successfully generated.');
    }
  }

  void showSnackBar(String content) {
    final snackBar = SnackBar(
      content: Text(
        '$content',
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
      backgroundColor: Colors.grey[700],
    );
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
      showSnackBar('information edited successfully.');
    } else {
      //add detail
      bloc.addDetail(service, username, password);
      bloc.fetchDetails();
      Navigator.pop(context);
      showSnackBar('information added successfully.');
    }
  }
}
