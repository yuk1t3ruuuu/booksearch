import 'package:booksearch/model.dart';
import 'package:booksearch/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:booksearch/model.dart';


final CollectionReference<Book> bookRef = FirebaseFirestore.instance
    .collection('books')
    .withConverter<Book>(
  fromFirestore: (snapshots, _) => Book.fromJson(snapshots.data()!),
  toFirestore: (todo, _) => todo.toJson(),
);

//ここでifとかを使用して条件分岐で処理をする
final booksStreamProvider = StreamProvider ((ref)  {
  if (bookRef.snapshots().contains(keywordEditing.text) as bool) {
    var stream =  bookRef.where('description', arrayContains: keywordEditing.text).snapshots();
     return stream;
  }else
    {
      var stream = bookRef.snapshots();
      return stream;
    }
});




final genreProvider = StateProvider<Genre>((ref) => Genre.any);