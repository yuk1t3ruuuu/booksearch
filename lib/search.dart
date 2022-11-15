import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:booksearch/provider.dart';
import 'model.dart';


TextEditingController keywordEditing = TextEditingController();

class SearchPage extends ConsumerWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final genres = ref.watch(genreProvider);


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('検索条件'),
        backgroundColor: Colors.green,
        leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.arrow_back))
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children:  [
             SizedBox(height: 10.0,),
            Text('検索条件', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
            SizedBox(height: 20.0,),
            Text('ジャンル', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 10.0,),
            SizedBox(
              width: 130.0,
              child: DropdownButton<Genre>(
                  isExpanded: true,
                  icon: Icon(Icons.arrow_downward),
                  underline: Container(
                    color: Colors.green,
                    height: 3,
                  ),
                  value: genres,
                  items: const [
                    DropdownMenuItem(child: Text('指定なし'), value: Genre.any),
                    DropdownMenuItem(child: Text('人文・思想'), value: Genre.humanitiesThought),
                    DropdownMenuItem(child: Text('歴史・地理'), value: Genre.historyGeography),
                    DropdownMenuItem(child: Text('科学・工学'), value: Genre.scienceEngineering),
                    DropdownMenuItem(child: Text('文学・評論'), value: Genre.literatureCriticism)
                  ],
                  onChanged: (Genre? value){
                    ref.read(genreProvider.notifier).state = value!;
                  }
              )
            ),
            SizedBox(height: 40.0),
            Text('フィルター', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
            SizedBox(height: 30.0),
            SizedBox(
              width: 300.0,
              child: TextFormField(
                controller: keywordEditing,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "キーワード"
                ),
                onChanged: (String? value){
                  ref.read(textProvider.notifier).state = value!;
                },

              )
            )
          ],
        )
      )
    );
  }
}