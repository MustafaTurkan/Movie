import 'package:bloc/bloc.dart';
import 'package:Movie/data/data.dart';
import 'package:Movie/domain/domain.dart';
import 'package:flutter/material.dart';

class SelectFavoriteCubit extends Cubit<SelectFavoriteState> {
  SelectFavoriteCubit({@required this.favorites, @required this.repository}) : super(SelectedListFavorite(favorites));

  final IMovieRepository repository;
  List<Movie> favorites;

  Future<void> toggleSelectionState(Movie movie) async {
    try {
      if (_isSelected(movie)) {
        favorites.remove(movie);
        await repository.removeFavorite(movie.imdbId);
        emit(SelectedListFavorite(favorites));
      } else {
        favorites.add(movie);
        await repository.addFavorite(movie);
        emit(SelectedListFavorite(favorites));
      }
    } catch (e) {
      emit(SelectFavoriteFail(reason: e.toString()));
    }
  }

  bool _isSelected(Movie movie) {
    return favorites.any((e) => e.imdbId.contains(movie.imdbId));
  }
}
