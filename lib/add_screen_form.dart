import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practice/bloc.dart';

import 'data/book.dart';

class AddScreenForm extends StatefulWidget {
  final BookBloc bloc;
  AddScreenForm({Key key, this.bloc}) : super(key: key);

  @override
  _AddScreenFormState createState() => new _AddScreenFormState(bloc);
}


class _AddScreenFormState extends State<AddScreenForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  final BookBloc bloc;

  _AddScreenFormState(this.bloc);

  @override
  void initState() {
    super.initState();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    String title;
    return Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  title = value;
                  return null;
                },
                decoration: new InputDecoration(
                    labelText: 'Book title',
                    hintText: 'Enter the title of the book',
                    contentPadding: const EdgeInsets.all(16.0)),
              ),
              Center(child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 25, 8, 8),
                child: Text(selectedDate.day.toString()+ "/" + selectedDate.month.toString() + "/" + selectedDate.year.toString()),
              )),
              Center(
                child: RaisedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Select date'),
                ),
              ),
              Center(
                child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: RaisedButton(
                      onPressed: () {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (_formKey.currentState.validate()) {
                          // Process data.
                          _addBook(title, selectedDate);
                          Navigator.pop(context);
                        }
                      },
                      color: Colors.redAccent,
                      child: Text('Submit',style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),
                      ),
                    )
                ),
              ),

            ]
        )
    );
  }

  void _addBook(String title, DateTime creationDate){
    setState(() {
      Book b = new Book();
      b.title = title;
      b.creationDate = creationDate;
      bloc.add(b);
    });
  }

}



