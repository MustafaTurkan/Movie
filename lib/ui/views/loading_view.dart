import 'package:Movie/infrastructure/infrastructure.dart';
import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           appBar: AppBar(
          centerTitle: true,
          title: Text(context.getLocalizer().appName),
        ),
        body: Center(child: WidgetFactory.dotProgressIndicator()));
  }
}