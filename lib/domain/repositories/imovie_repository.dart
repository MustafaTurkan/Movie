import 'package:Movie/data/data.dart';

abstract class IMovieRepository
{
    Future<List<Movie>> getMovies(String filter);
    Future<void> addFavorite(Movie movie);
    Future<void> removeFavorite(String id);
    Future<List<Movie>> getFavorites();
}
