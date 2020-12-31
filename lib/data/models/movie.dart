import 'package:Movie/infrastructure/infrastructure.dart';

class Movie {
    Movie({
        this.title,
        this.year,
        this.imdbId,
        this.type,
        this.poster,
    });

    final String title;
    final String year;
    final String imdbId;
    final String type;
    final String poster;

    factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        title: json.getValue<String>('Title'),
        year: json.getValue<String>('Year'),
        imdbId:json.getValue<String>('imdbID'),
        type: json.getValue<String>('Type'),
        poster: json.getValue<String>('Poster').equalsIgnoreCase('N/A')?'':json.getValue<String>('Poster'),
    );
    Map<String, dynamic> toJson() => {
        'Title': title,
        'Year': year,
        'imdbID': imdbId,
        'Type': type,
        'Poster': poster,
    };
}