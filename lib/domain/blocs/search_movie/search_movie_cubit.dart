import 'package:bloc/bloc.dart';
import 'package:Movie/data/data.dart';
import 'package:Movie/domain/domain.dart';
import 'package:flutter/material.dart';


class SearchMovieCubit extends Cubit<SearchMovieState> {
  SearchMovieCubit({@required this.repository}) : super((SearchMovieResult(List<Movie>.empty())));

  final IMovieRepository repository;

  Future<void> search(String filter) async {
    try {
      emit(SearchMovieLoading());
      var result = await repository.getMovies(filter);
      emit(SearchMovieResult(result));
    } 
    catch (e ) {
      emit(SearchMovieFail(reason: e.toString()));
    }
  }

  void clearFilter() {
    try {
      emit(SearchMovieResult(List<Movie>.empty()));
    } catch (e) {
      emit(SearchMovieFail(reason: e.toString()));
    }
  }
}
