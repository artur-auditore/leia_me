import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import './helpers/book_helper.dart';
import './models/book.dart';
import './views/book_dialog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Book> _BookList = [];
  BookHelper _helper = BookHelper();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _helper.getAll().then((list) {
      setState(() {
        _BookList = list;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Livros a Ler')),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: _addNewBook),
      body: _buildBookList(),
    );
  }

  Widget _buildBookList() {
    if (_BookList.isEmpty) {
      return Center(
        child: _loading ? CircularProgressIndicator() : Text("Sem Livros! Clique em + para adicionar um"),
      );
    } else {
      return ListView.builder(
        itemBuilder: _buildBookItemSlidable,
        itemCount: _BookList.length,
      );
    }
  }

  Widget _buildBookItem(BuildContext context, int index) {
    final Book = _BookList[index];
    return CheckboxListTile(
      value: Book.isRead,
      title: Text(Book.title),
      subtitle: Text(Book.author),
      onChanged: (bool isChecked) {
        setState(() {
          Book.isRead = isChecked;
        });

        _helper.update(Book);
      },
    );
  }

  Widget _buildBookItemSlidable(BuildContext context, int index) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: _buildBookItem(context, index),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Editar',
          color: Colors.blue,
          icon: Icons.edit,
          onTap: () {
            _addNewBook(editedBook: _BookList[index], index: index);
          },
        ),
        IconSlideAction(
          caption: 'Excluir',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            _deleteBook(deletedBook: _BookList[index], index: index);
          },
        ),
      ],
    );
  }

  Future _addNewBook({Book editedBook, int index}) async {
    final Book = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BookDialog(book: editedBook);
      },
    );

    if (Book != null) {
      setState(() {
        if (index == null) {
          _BookList.add(Book);
          _helper.save(Book);
        } else {
          _BookList[index] = Book;
          _helper.update(Book);
        }
      });
    }
  }

  void _deleteBook({Book deletedBook, int index}) {
    setState(() {
      _BookList.removeAt(index);
    });

    _helper.delete(deletedBook.id);

    Flushbar(
      title: "Exclusão de livros",
      message: "Livro \"${deletedBook.title}\" removido.",
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      duration: Duration(seconds: 3),
      mainButton: FlatButton(
        child: Text(
          "Desfazer",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          setState(() {
            _BookList.insert(index, deletedBook);
            _helper.update(deletedBook);
          });
        },
      ),
    )..show(context);
  }
}