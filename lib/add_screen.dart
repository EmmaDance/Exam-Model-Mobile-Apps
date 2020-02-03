
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practice/add_screen_form.dart';
import 'package:practice/bloc.dart';

class AddScreen extends StatelessWidget{
  final BookBloc bloc;

  const AddScreen({Key key, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new book"),
      ),
      body: AddScreenForm(bloc: bloc,),
    );
  }

}