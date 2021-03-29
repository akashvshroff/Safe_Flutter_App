import 'package:flutter/material.dart';
import '../models/detail_model.dart';

class DetailTile extends StatelessWidget {
  final DetailModel detail;

  DetailTile({this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 5.0),
      child: ListTile(
          onTap: () {
            onTap(context);
          },
          title: Text('${detail.service}',
              style: TextStyle(fontSize: 20.0, color: Colors.white)),
          subtitle: Text(
            '${detail.username}',
            style: TextStyle(fontSize: 18.0),
          ),
          trailing: IconButton(
            onPressed: deleteDetail,
            icon: Icon(
              Icons.delete_outline,
              color: Colors.redAccent[400],
            ),
          )),
    );
  }

  void onTap(context) {
    Navigator.pushNamed(context, '/detail/${detail.id}');
  }

  void deleteDetail() {}
}
