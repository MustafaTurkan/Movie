import 'package:Movie/data/data.dart';
import 'package:Movie/infrastructure/infrastructure.dart';
import 'package:flutter/material.dart';

abstract class SelectFavoriteState {}

class SelectingFavorite extends SelectFavoriteState {}

class SelectedListFavorite extends SelectFavoriteState {
  SelectedListFavorite(this.favorites);
  final List<Movie> favorites;

  bool contains(Movie movie) {
    if (favorites.isNullOrEmpty()) {
      return false;
    }
    return favorites.any((e) => e.imdbId==movie.imdbId);
  }
}

class SelectFavoriteFail extends SelectFavoriteState {
  SelectFavoriteFail({@required this.reason});
  final String reason;
  @override
  String toString() => ' SelectFavorite { reason: $reason }';
}
