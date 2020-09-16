class Book{
  int id;
  String title;
  String author;
  bool isRead;

  Book({this.id, this.title, this.author, this.isRead=false});

  factory Book.fromMap(Map<String, dynamic> json) => Book(
        id: json["id"],
        title: json["title"],
        author: json["author"],
        isRead: json["isRead"] == 1,
      );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "title": title,
      "author": author,
      "isRead": isRead ? 1 : 0
    };

    if (id != null) map["id"] = id;

    return map;
  }
      

}
