import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';
import 'package:booksearch/provider.dart';
import 'package:booksearch/search.dart';
import 'package:booksearch/model.dart';

TextEditingController keywordEditing = TextEditingController();

final CollectionReference<Book> bookRef = FirebaseFirestore.instance
    .collection('books')
    .withConverter<Book>(
  fromFirestore: (snapshots, _) => Book.fromJson(snapshots.data()!),
  toFirestore: (todo, _) => todo.toJson(),
);


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: BookPage()
    );
  }
}


class BookPage extends ConsumerWidget{
  const BookPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref){

    final books = ref.watch(booksStreamProvider);
    final keywords = ref.watch(textProvider);
    List<Book> bookList = [];
    List<Book> choicedList = [];

    return Scaffold(
      appBar: AppBar(
        title: Text('蔵書一覧'),
        backgroundColor: Colors.green,
        actions: [IconButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) {return SearchPage();})), icon: Icon(Icons.search))],
      ),
      body: Column(
        children: [
          books.when(
              error: (error, stack) => Text('Error: $error'),
              loading: () => const CircularProgressIndicator() ,
              data: (books){
             if (keywords.isEmpty) {
               return Expanded(
                   child: ListView.builder(         //キーワード指定がない場合
                       itemCount: books.size,
                       itemBuilder: (context, index){
                         final book = books.docs[index].data();
                         return Card(
                           child: ListTile(
                             title: Text(book.title + ' - ' + book.author, style: TextStyle(fontWeight: FontWeight.bold)),
                             subtitle: Text(book.description),
                           ),
                         );
                       }
                   )
               );
             }
             else{
               bookList = books.docs.map((doc) => doc.data()).toList();
               choicedList = bookList.where((doc) => (doc.description.contains(keywords)) || (doc.title.contains(keywords))).toList();

               return Expanded(
                   child: ListView.builder(
                       itemCount: choicedList.length,
                       itemBuilder: (context, index){
                         return Card(
                           child: ListTile(
                             title: Text(choicedList[index].title + ' - ' + choicedList[index].author, style: TextStyle(fontWeight: FontWeight.bold)),
                             subtitle: Text(choicedList[index].description),
                           ),
                         );
                       }
                   )
               );
             }

















              },
          )
        ],
      ),
    );
  }
}
