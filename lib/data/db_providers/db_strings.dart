class DbString {
  static const String name = 'movie.db';
}

class FavoriteString {
  static const String tableName = 'Favorite';
  static const String title = 'Title';
  static const String year = 'Year';
  static const String imdbID = 'imdbID';
  static const String type = 'Type';
  static const String poster = 'Poster';
  static const String createTable = 'CREATE TABLE $tableName ($title TEXT,$year TEXT,$imdbID TEXT,$type TEXT,$poster TEXT)';
}

