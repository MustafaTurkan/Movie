import 'package:Movie/data/data.dart';
import 'package:Movie/domain/domain.dart';
import 'package:Movie/infrastructure/infrastructure.dart';
import 'package:Movie/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteMovieListView extends StatefulWidget {
  FavoriteMovieListView({Key key}) : super(key: key);
  @override
  _FavoriteMovieListViewState createState() => _FavoriteMovieListViewState();
}

class _FavoriteMovieListViewState extends State<FavoriteMovieListView> {
  Localizer localizer;
  AppTheme appTheme;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizer = context.getLocalizer();
    appTheme = context.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(localizer.favorites),
      ),
      body: ContentContainer(
          child: _MovieFavoriteList(
        appTheme: appTheme,
      )),
    );
  }
}

class _MovieFavoriteList extends StatelessWidget {
  const _MovieFavoriteList({Key key, @required this.appTheme}) : super(key: key);

  final AppTheme appTheme;

  @override
  Widget build(BuildContext context) {
    return ContentContainer(child: BlocBuilder<SelectFavoriteCubit, SelectFavoriteState>(builder: (context, state) {
      if (state is SelectFavoriteFail) {
        return BackgroundHint.noData(context);
      }
      if (state is SelectedListFavorite) {
        return buildBody(context, state.favorites);
      }
      return Center(child: WidgetFactory.dotProgressIndicator());
    }));
  }

  Widget buildBody(BuildContext context, List<Movie> movies) {
    if (movies.isNullOrEmpty()) {
      return BackgroundHint.noData(context);
    }
    return GridView.builder(
        itemCount: movies.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          var movie = movies[index];
          return FavoriteMovieListTile(
            favoriteIcon: AppIcons.heart,
            appTheme: appTheme,
            movie: movie,
            onTab: () async {
              var result = await questionDelete(context);
              if (result == DialogResult.no) {
                return;
              }
              await context.getBloc<SelectFavoriteCubit>().toggleSelectionState(movie);
            },
          );
        });
  }

  Future<DialogResult> questionDelete(BuildContext context) {
    return MessageDialog.question(
      context: context,
      message: context.getLocalizer().deleting,
      buttons: DialogButton.yesNo,
    );
  }
}
