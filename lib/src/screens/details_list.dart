import 'package:flutter/material.dart';
import '../blocs/provider.dart';
import '../models/detail_model.dart';
import '../widgets/detail_tile.dart';

class DetailsList extends StatefulWidget {
  @override
  _DetailsListState createState() => _DetailsListState();
}

class _DetailsListState extends State<DetailsList> {
  final queryController = TextEditingController();
  String queryString = '';

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/settings');
          },
        ),
        automaticallyImplyLeading: false,
        title: Text(
          'safe.',
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search_off, color: Colors.white),
            onPressed: () {
              setState(() {
                queryString = '';
                queryController.text = '';
              });
              bloc.fetchDetails();
            },
          ),
        ],
      ),
      body: buildBody(bloc),
      floatingActionButton: buildButton(context),
    );
  }

  Widget buildBody(Bloc bloc) {
    return Column(
      children: [
        searchQuery(),
        Expanded(
          child: buildList(bloc),
        )
      ],
    );
  }

  Widget searchQuery() {
    return Card(
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 8.0, 5.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: queryController,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                  hintText: 'enter service name.',
                  contentPadding: EdgeInsets.all(10.0)),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.green,
              size: 32.0,
            ),
            onPressed: () {
              FocusScope.of(context).unfocus();
              setState(() {
                queryString = queryController.text.toLowerCase();
              });
            },
          )
        ],
      ),
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
        details.add(null);
        return RefreshIndicator(
          child: ListView.builder(
            itemCount: details.length,
            itemBuilder: (context, index) {
              if (details[index] == null) {
                return Container(height: 100.0, width: 0.0);
              } else if (details[index]
                      .service
                      .toLowerCase()
                      .contains(queryString) ||
                  queryString == '') {
                return DetailTile(detail: details[index]);
              } else {
                return Container(height: 0.0, width: 0.0);
              }
            },
          ),
          onRefresh: () {
            return bloc.fetchDetails();
          },
        );
      },
    );
  }

  Widget buildButton(context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, '/add');
      },
      backgroundColor: Colors.blue,
      child: Icon(Icons.add, color: Colors.white),
    );
  }
}
