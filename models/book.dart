class Book{
  int id;
  String title;
  String author;
  bool isread;

  Book({this.id, this.title, this.author, this.isread});

  factory Book.fromMap(Map<String, dynamic> json) => new Book(
        id: json["id"],
        title: json["title"],
        author: json["author"],
        isread: json["isread"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "author": author,
        "isread": isread,
      };
}
}