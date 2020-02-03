
class Book{

  int id;
  String title;
  DateTime creationDate;

  Book();
  Book.withDetails({this.id, this.title, this.creationDate});


  factory Book.fromJson(Map<String, dynamic> i){
    Book b = new Book();
    b.id = i["id"];
    b.title = i["title"];
    b.creationDate = DateTime.parse(i["date"]);
    return b;
  }

  Map<String, dynamic> toMap() {
    return {
      "id":id,
      "title":title,
      "creationDate":creationDate.toString()
    };
}

  @override
  String toString() {
    return 'Book {id: $id, title: $title, date: $creationDate}';
  }

  @override
  bool operator ==(other) {
    // TODO: implement ==
    return this.title ==(other.title);
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;

}
