
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'data/book.dart';

class BookTile extends StatelessWidget{

  final Book book;
  const BookTile({Key key, @required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(book.title),
      subtitle: Text(book.creationDate.day.toString()+ "/" + book.creationDate.month.toString() + "/" + book.creationDate.year.toString()),

    );
  }

}