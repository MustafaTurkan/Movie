import 'package:Movie/infrastructure/infrastructure.dart';
import 'package:flutter/material.dart';


class AppBarContainer extends StatelessWidget {
  AppBarContainer({this.child, this.bottomPadding});

  final Widget child;
  final double bottomPadding;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding ?? Space.m, left: Space.s, right: Space.s),
        child: child,
      ),
    );
  }
}
