import 'package:Movie/data/data.dart';
import 'package:Movie/infrastructure/infrastructure.dart';
import 'package:Movie/infrastructure/theme/app_theme.dart';
import 'package:flutter/material.dart';

class FavoriteMovieListTile extends StatelessWidget {
   FavoriteMovieListTile({Key key, @required this.appTheme, @required this.movie,  @required this.favoriteIcon,@required this.onTab}) : super(key: key);

  final AppTheme appTheme;
    final    Movie movie;
  final VoidCallback onTab;
  final IconData favoriteIcon;

  @override
  Widget build(BuildContext context) {
    var cardBorderRadius = appTheme.data.cardBorderRadius();
    return Padding(
      padding: const EdgeInsets.all(Space.m),
      child: GestureDetector(
        onTap:onTab,
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: appTheme.colors.canvas), borderRadius: cardBorderRadius),
          child: Column(
            children: [
              buildFavoriteIcon(),
              Expanded(
                child: Padding(padding: const EdgeInsets.all(Space.xxs), child: buildImage(movie.poster)),
              ),
              IndentDivider(),
              buildTileTitle(movie.title),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImage(String src) {
    return Image.network(src);
  }

  Widget buildTileTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(Space.s),
      child: SizedBox(
        height: 30,
        child: Center(
          child: Text(
            title,
            style: appTheme.textStyles.body,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget buildFavoriteIcon() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(Space.s),
        child: Icon(favoriteIcon, size: Space.l),
      ),
    );
  }
}
