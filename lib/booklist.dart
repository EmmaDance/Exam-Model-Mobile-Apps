import 'package:flutter/material.dart';
import 'package:practice/bloc.dart';
import 'package:practice/data/book.dart';

import 'book_tile.dart';

class BookList extends StatefulWidget {
  BookBloc bloc;

  BookList({Key key, this.bloc}) : super(key: key);

  @override
  _BookListState createState() => new _BookListState(bloc);
}

class _BookListState extends State<BookList> {
  BookBloc bloc;

  _BookListState(this.bloc);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Book>>(
        stream: bloc.allBooks,
        initialData: List<Book>(),
        builder: (context, snapshot) {
          // add connection switch
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return BookTile(book: snapshot.data[index]);
                },
              );
          }
        });
  }
}
