import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:practice/add_screen.dart';
import 'package:practice/bloc.dart';
import 'package:practice/booklist.dart';
import 'package:practice/data/book.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter practice',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Home',
        channel: IOWebSocketChannel.connect('ws://192.168.2.104:3000'),

    ),

    );
  }
}

class MyHomePage extends StatefulWidget {
  final channel;
  MyHomePage({Key key, @required this.title, @required this.channel}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription subscription;
  final BookBloc bloc = BookBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      bloc.sync();
    });

    widget.channel.stream.listen((message) {
      print("WebSocket received: " + message);
      Map<String, dynamic> decoded = json.decode(message);
      Book book = Book.fromJson(decoded);
      bloc.addLocal(book);
    });

    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }


  void _addBook() async {
    if(await isOnlineSnackBar())
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (context) {
            return new AddScreen(bloc:bloc,);
          }
      ));

  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        key: _scaffoldKey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: BookList(bloc: bloc),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBook,
        tooltip: 'Add book',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  Future<bool> isOnline() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi)
      return true;
    return false;
  }

  Future<bool> isOnlineSnackBar() async {
    if (await isOnline())
      return true;
    final snackBar = SnackBar(content: Text('You cannot do this action while offline'));
    _scaffoldKey.currentState.showSnackBar(snackBar);
    return false;
  }


}

