import 'package:Movie/data/data.dart';
import 'package:Movie/domain/domain.dart';
import 'package:Movie/infrastructure/infrastructure.dart';
import 'package:Movie/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchMovieView extends StatefulWidget {
  SearchMovieView({Key key}) : super(key: key);

  @override
  _SearchMovieViewState createState() => _SearchMovieViewState();
}

class _SearchMovieViewState extends State<SearchMovieView> {
  _SearchMovieViewState()
      : navigator = AppService.get<AppNavigator>(),
        repository = AppService.get<IMovieRepository>();

  final AppNavigator navigator;
  final IMovieRepository repository;
  final tecSearch = TextEditingController();
  Localizer localizer;
  AppTheme appTheme;
  Future<List<Movie>> futureFavorites;

  @override
  void initState() {
    super.initState();
    futureFavorites = repository.getFavorites();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appTheme = context.getTheme();
    localizer = context.getLocalizer();
  }

  @override
  void dispose() {
    tecSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(localizer.appName),
        actions: [buildFavoritesButton()],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<SearchMovieCubit, SearchMovieState>(
            listener: (context, state) async {
              if (state is SearchMovieFail) {
                await MessageDialog.error(
                    context: context, message: localizer.translate(state.reason), title: localizer.error);
              }
            },
          ),
          BlocListener<SelectFavoriteCubit, SelectFavoriteState>(
            listener: (context, state) async {
              if (state is SelectFavoriteFail) {
                await MessageDialog.error(
                    context: context, message: localizer.translate(state.reason), title: localizer.error);
              }
            },
          ),
        ],
        child: Column(
          children: [
            MovieSearchField(
              localizer: localizer,
              tecSearch: tecSearch,
            ),
            Expanded(
                child: _MovieList(
              appTheme: appTheme,
            ))
          ],
        ),
      ),
    );
  }

  Widget buildFavoritesButton() {
    return IconButton(
            icon: Icon(AppIcons.homeHeart),
            onPressed: () async {
 
              navigator.pushFavoriteMovieListView(context);
            },
          );
        }

}

class _MovieList extends StatelessWidget {
  const _MovieList({Key key, @required this.appTheme}) : super(key: key);

  final AppTheme appTheme;

  @override
  Widget build(BuildContext context) {
    return ContentContainer(child: BlocBuilder<SearchMovieCubit, SearchMovieState>(builder: (context, state) {
      if (state is SearchMovieFail) {
        return BackgroundHint.seach(context);
      }
      if (state is SearchMovieResult) {
        return buildBody(context, state.movies);
      }
      return Center(child: WidgetFactory.dotProgressIndicator());
    }));
  }

  Widget buildBody(BuildContext context, List<Movie> movies) {
    if (movies.isNullOrEmpty()) {
      return BackgroundHint.seach(context);
    }

    return GridView.builder(
        itemCount: movies.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          var movie = movies[index];
          return BlocBuilder<SelectFavoriteCubit, SelectFavoriteState>(
            builder: (context, state) {
              if (state is SelectingFavorite) {
                return Center(
                  child: WidgetFactory.circularProgressIndicator(
                      size: 20, color: appTheme.colors.primaryPale, strokeWidth: 1.5),
                );
              }
              if (state is SelectedListFavorite) {
                return MovieListTile(
                  favoriteIcon: state.contains(movie) ? AppIcons.heart : AppIcons.heartOutline,
                  appTheme: appTheme,
                  movie: movie,
                  onTab: () async {
                    await context.getBloc<SelectFavoriteCubit>().toggleSelectionState(movie);
                  },
                );
              }
              return WidgetFactory.emptyWidget();
            },
          );
        });
  }
}
