import 'package:Movie/ui/ui.dart';
import 'package:flutter/material.dart';


class AppNavigator {
  static final key = GlobalKey<NavigatorState>();
  static final routeObserver = RouteObserver<PageRoute>();



  Future<void> pushFavoriteMovieListView(BuildContext context,) {
    return Navigator.push(
      context,
      MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => FavoriteMovieListView()),
    );
  }


  void pop<T extends Object>(BuildContext context, {T result}) {
    Navigator.of(context).pop<T>(result);
  }
}
