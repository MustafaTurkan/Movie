import 'package:Movie/data/api_providers/omdb_api.dart';
import 'package:Movie/data/data.dart';
import 'package:Movie/domain/domain.dart';

class MovieRepository extends IMovieRepository {
  MovieRepository(this.apiClient, this.dbClient);
  OMDbApi apiClient;
  MovieDb dbClient;

  @override
  Future<List<Movie>> getMovies(String filter) {
    apiClient.initialize();
    return apiClient.getMovies(filter);
  }

  @override
  Future<void> addFavorite(Movie movie) async {
    await dbClient.insertFavorite(movie);
  }

  @override
  Future<List<Movie>> getFavorites() {
    return dbClient.getFavorites();
  }

  @override
  Future<void> removeFavorite(String id) async {
    await dbClient.deleteFavorite(id);
  }
}
