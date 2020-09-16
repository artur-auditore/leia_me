import 'package:flutter/material.dart';
import '../models/book.dart';

class BookDialog extends StatefulWidget {
  final Book book;

  BookDialog({this.book});

  @override
  _BookDialogState createState() => _BookDialogState();
}

class _BookDialogState extends State<BookDialog> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();

  Book _currentBook = Book();

  @override
  void initState() {
    super.initState();

    if (widget.book != null) {
      _currentBook = Book.fromMap(widget.book.toMap());
    }

    _titleController.text = _currentBook.title;
    _authorController.text = _currentBook.author;
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.clear();
    _authorController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.book == null ? 'Novo Livro' : 'Editar Livro'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Título'),
              autofocus: true),
          TextField(
              controller: _authorController,
              decoration: InputDecoration(labelText: 'Autor')),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Salvar'),
          onPressed: () {
            _currentBook.title = _titleController.value.text;
            _currentBook.author = _authorController.text;

            Navigator.of(context).pop(_currentBook);
          },
        ),
      ],
    );
  }
}