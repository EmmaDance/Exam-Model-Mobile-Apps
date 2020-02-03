

import 'package:connectivity/connectivity.dart';
import 'package:practice/data/book.dart';
import 'package:practice/database.dart';
import 'package:practice/service.dart';
import 'package:rxdart/rxdart.dart';

class BookBloc{
  final Service service = new Service();
  final BookDatabase db = BookDatabase();

  BookBloc(){
    getBooks();
  }

  final _bookSubject = BehaviorSubject<List<Book>>();

  Stream<List<Book>> get allBooks =>
    _bookSubject.stream;

  getBooks() async {
    print("Bloc get books");
    List<Book> books;
    if (await isOnline())
      books = await service.getAll();
    else
      books = await db.books();
    if (books.isNotEmpty)
      _bookSubject.sink.add(books);

  }

  add(Book book) async{
    final id = db.insertBook(book);
    id.then((id) async {
      book.id = id;
      print("bloc add id = "+id.toString());
        print("activity bloc - service insert");
        await service.insert(book).then((inserted){
          if(inserted)
            print("Added to server");
          else {
            print("Add to server failed");
          }});
      _bookSubject.sink.add(await db.books());
    });
  }

  addLocal(Book book) async {
    final id = db.insertBook(book);
    id.then((id) async {
      print("bloc add locally, id = " + id.toString());
      _bookSubject.sink.add(await db.books());
    });
  }

  sync() async{
//        db.deleteBooksTable();
    if (await isOnline()){
      print("sync");
      List<Book> books = await service.getAll();
      books.forEach((book){
        db.insertBook(book);
      });
    }
  }


  dispose(){
    _bookSubject.close();
  }

  Future<bool> isOnline() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi)
      return true;
    return false;
  }

}