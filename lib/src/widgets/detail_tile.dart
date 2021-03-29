import 'package:flutter/material.dart';
import '../models/detail_model.dart';

class DetailTile extends StatelessWidget {
  final DetailModel detail;

  DetailTile({this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        color: Colors.black,
      )),
      margin: EdgeInsets.all(10.0),
      child: ListTile(
          onTap: onTap,
          title: Text(
            '${detail.service}',
            style: TextStyle(fontSize: 20.0),
          ),
          subtitle: Text(
            '${detail.username}',
            style: TextStyle(fontSize: 18.0),
          ),
          trailing: IconButton(
            onPressed: deleteDetail,
            icon: Icon(
              Icons.delete,
              color: Colors.redAccent[400],
            ),
          )),
    );
  }

  void onTap() {}
  void deleteDetail() {}
}
