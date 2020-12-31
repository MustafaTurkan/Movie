import 'package:Movie/data/data.dart';
import 'package:Movie/ui/app_navigator.dart';
import 'package:Movie/ui/ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/single_child_widget.dart';
import 'infrastructure/infrastructure.dart';

class App {
  Future<void> buildAppServices() async {
    AppService.addSingleton<AppNavigator>(
      AppNavigator(),
    );

    //database
    AppService.addSingleton<MovieDb>(
      MovieDb(),
    );
    var db = AppService.get<MovieDb>();
    await db.initialize();

    //Service
    AppService.addSingleton<OMDbApi>(
      OMDbApi(),
    );

    //repositories
    AppService.addTransient<IMovieRepository>(
      () => MovieRepository(AppService.get<OMDbApi>(), db),
    );
  }

  void setSystemChromeSettings() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  void run() async {
    if (kReleaseMode) {
      debugPrint = (message, {wrapWidth}) {};
    }

    WidgetsFlutterBinding.ensureInitialized();
    setSystemChromeSettings();
    await buildAppServices();
    runApp(AppWidget('Movie'));
  }
}

class AppWidget extends StatefulWidget {
  AppWidget(this.title);
  final String title;

  @override
  _AppWidgetState createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  _AppWidgetState() : repository = AppService.get<IMovieRepository>();
  final IMovieRepository repository;

  Future<List<Movie>> futureFavorites;
  Localizer localizer;

  @override
  void initState() {
    super.initState();
    futureFavorites = repository.getFavorites();
  }

  @override
  void didChangeDependencies() {
    localizer = context.getLocalizer();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
        future: futureFavorites,
        builder: (context, snapshot) {
          return MultiProvider(
            providers: [..._providers(snapshot.data)],
            builder: (context, child) {
              return MaterialApp(
                  locale: context.get<AppLocale>(listen: true).locale,
                  localizationsDelegates: _localizationsDelegates(),
                  supportedLocales: _supportedLocales(),
                  title: widget.title,
                  builder: _builder,
                  navigatorKey: AppNavigator.key,
                  navigatorObservers: [AppNavigator.routeObserver],
                  home: buildHome(snapshot));
            },
          );
        });
  }

  Widget buildHome(AsyncSnapshot<List<Movie>> snapshot) {
    if (snapshot.connectionState != ConnectionState.done) {
      return LoadingView();
    }
    if (snapshot.hasError) {
      return ErrorView();
    }
    return SearchMovieView();
  }

  Widget buildLoading() {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(localizer.appName),
        ),
        body: Center(child: WidgetFactory.dotProgressIndicator()));
  }

  Widget buildError() {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(localizer.appName),
        ),
        body: Center(child: BackgroundHint.unExpectedError(context)));
  }

  Widget _builder(BuildContext context, Widget child) {
    var theme = context.getTheme(listen: true);
    if (!theme.initialized) {
      theme.setTheme(buildDefaultTheme(context));
    }

    return Theme(data: theme.data, child: child);
  }

  Iterable<LocalizationsDelegate<dynamic>> _localizationsDelegates() {
    return [AppLocalizationsDelegate(), GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate];
  }

  Iterable<Locale> _supportedLocales() {
    return AppLocale.supportedLocales;
  }

  String _getUserLanguage() {
    return null;
  }

  List<SingleChildWidget> _providers(List<Movie> favorites) {
    Provider.debugCheckInvalidValueType = null;
    return [
      ChangeNotifierProvider<AppTheme>(
        create: (_) => AppTheme(),
      ),
      ChangeNotifierProvider<AppLocale>(
        create: (_) => AppLocale(languageCode: _getUserLanguage()),
      ),
      BlocProvider<SearchMovieCubit>(
        create: (context) => SearchMovieCubit(repository: repository),
      ),
      BlocProvider<SelectFavoriteCubit>(
        create: (context) => SelectFavoriteCubit(repository: repository, favorites: favorites),
      ),
    ];
  }
}
