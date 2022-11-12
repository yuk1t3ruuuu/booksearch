import 'package:flutter/material.dart';


enum Genre{any, humanitiesThought, historyGeography, scienceEngineering, literatureCriticism, artArchitecture }

@immutable
class Book{
   const Book({
    required this.title,
    required this.author,
    required this.description,
    required this.genre
});

  Book.fromJson(Map<String, Object?> json)
    : this(
    title: json['title']! as String,
    author: json['author']! as String,
    description: json['description']! as String,
    genre: json['genre']! as String
  );

  final String title;
  final String author;
  final String description;
  final String genre;

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'genre': genre
    };
  }






}