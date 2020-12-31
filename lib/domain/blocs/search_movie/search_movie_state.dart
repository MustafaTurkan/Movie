


import 'package:Movie/data/data.dart';
import 'package:flutter/material.dart';

abstract class SearchMovieState {}


class SearchMovieLoading extends SearchMovieState {}


class SearchMovieResult extends SearchMovieState {
  SearchMovieResult(this.movies);
   final List<Movie> movies;
}

class SearchMovieFail extends SearchMovieState {
  SearchMovieFail({@required this.reason});
  final String reason;
  @override
  String toString() => 'MovieSearch { reason: $reason }';
}

