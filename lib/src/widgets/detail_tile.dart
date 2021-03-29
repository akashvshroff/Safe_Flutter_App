import 'package:flutter/material.dart';
import '../models/detail_model.dart';
import '../blocs/provider.dart';

class DetailTile extends StatelessWidget {
  final DetailModel detail;

  DetailTile({this.detail});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 5.0),
      child: ListTile(
          onTap: () {
            onTap(context, bloc);
          },
          title: Text('${detail.service}',
              style: TextStyle(fontSize: 20.0, color: Colors.white)),
          subtitle: Text(
            '${detail.username}',
            style: TextStyle(fontSize: 18.0),
          ),
          trailing: IconButton(
            onPressed: () {
              deleteDetail(context, bloc);
            },
            icon: Icon(
              Icons.delete_outline,
              color: Colors.redAccent[400],
            ),
          )),
    );
  }

  void onTap(context, bloc) {
    Navigator.pushNamed(context, '/detail/${detail.id}');
    bloc.fetchDetails();
  }

  void deleteDetail(context, bloc) {
    AlertDialog alert = AlertDialog(
      title: Text("warning."),
      content: Text("this is a permament process and cannot be undone."),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'cancel',
              style: TextStyle(color: Colors.green),
            )),
        TextButton(
          onPressed: () async {
            await bloc.deleteDetailById(detail.id);
            bloc.fetchDetails();
            Navigator.of(context).pop();
          },
          child: Text(
            'continue',
            style: TextStyle(color: Colors.redAccent[400]),
          ),
        )
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}
