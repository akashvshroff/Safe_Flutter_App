import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../blocs/provider.dart';

class UpdateMaster extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('updating.'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: buildBody(bloc),
      ),
    );
  }

  Widget buildBody(Bloc bloc) {
    return Center(
      child: StreamBuilder(
        stream: bloc.masterUpdateStatus,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text(
                  'updating master password...',
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            );
          } else {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/details');
            });
            return Container(
              height: 0.0,
              width: 0.0,
            );
          }
        },
      ),
    );
  }
}
