import 'package:booksearch/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:booksearch/model.dart';


final CollectionReference<Book> bookRef = FirebaseFirestore.instance
    .collection('books')
    .withConverter<Book>(
  fromFirestore: (snapshots, _) => Book.fromJson(snapshots.data()!),
  toFirestore: (todo, _) => todo.toJson(),
);


//ここでジャンルの処理をする　if文で条件分岐させてジャンルごとに取得するデータを変える
final booksStreamProvider = StreamProvider ((ref) {

  final genres = ref.watch(genreProvider);

  if (genres == Genre.humanitiesThought){  //人文・思想の場合
    var stream = bookRef.where('genre', isEqualTo: '人文・思想').snapshots();
    return stream;
  }
  else if (genres == Genre.historyGeography){ //歴史・地理の場合
    var stream = bookRef.where('genre', isEqualTo: '歴史・地理').snapshots();
    return stream;
  }
  else if (genres == Genre.scienceEngineering){ //科学・工学の場合
    var stream = bookRef.where('genre', isEqualTo: '科学・工学').snapshots();
    return stream;
  }
  else if (genres == Genre.literatureCriticism){ //文学・評論の場合
    var stream = bookRef.where('genre', isEqualTo: '文学・評論').snapshots();
    return stream;
  }
  else{
    var stream = bookRef.snapshots(); //指定なしの場合
    return stream;
  }

});

final genreProvider = StateProvider<Genre>((ref) => Genre.any);

final textProvider = StateProvider((ref) => keywordEditing.text);