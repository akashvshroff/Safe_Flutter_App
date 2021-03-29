import 'package:flutter/material.dart';
import '../blocs/provider.dart';
import '../models/detail_model.dart';
import '../widgets/detail_tile.dart';

class DetailsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'safe.',
        ),
        centerTitle: true,
      ),
      body: buildList(bloc),
      floatingActionButton: buildButton(context),
    );
  }

  Widget buildList(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.details,
      builder: (context, AsyncSnapshot<List<DetailModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final List<DetailModel> details =
            snapshot.data != null ? snapshot.data : [];
        return RefreshIndicator(
          child: ListView.builder(
            itemCount: details.length,
            itemBuilder: (context, index) {
              return DetailTile(detail: details[index]);
            },
          ),
          onRefresh: () {
            bloc.fetchDetails();
          },
        );
      },
    );
  }

  Widget buildButton(context) {
    return FloatingActionButton(
      onPressed: () {
        // Navigator.pushNamed(context, '/add');
      },
      backgroundColor: Colors.blue,
      child: Icon(Icons.add, color: Colors.white),
    );
  }
}
