import 'package:Movie/data/data.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'db_strings.dart';


class MovieDb {
  Database database;

  Future<void> initialize() async {
    database = await openDatabase(
      join(await getDatabasesPath(), DbString.name),
      onCreate: (Database db, int version) async {
        await db.execute(FavoriteString.createTable);
      },
      version: 1,
    );
  }

  Future<void> insertFavorite(Movie movie) async {
    try {
      await database.insert(FavoriteString.tableName, movie.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Movie>> getFavorites() async {
    try {
      var result = await database.query(FavoriteString.tableName);
      return List.generate(result.length, (index) {
        return Movie.fromJson(result[index]);
      });
    } catch (e) {
      throw Exception(e);
    }
  }


  Future<void> deleteFavorite(String id) async {
    try {
      await database.delete(FavoriteString.tableName, where: '${FavoriteString.imdbID} = ?', whereArgs: <String>[id]);
    } catch (e) {
      throw Exception(e);
    }
  }


}
