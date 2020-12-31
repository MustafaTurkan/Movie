import 'package:flutter/material.dart';
import 'package:Movie/infrastructure/infrastructure.dart';

class CardTitle extends StatelessWidget {
  CardTitle({this.title, this.color, this.backgroundColor});

  final String title;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    var appTheme = context.getTheme();
    var color = this.color ?? appTheme.colors.primary;
    return Container(
      color: backgroundColor,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(Space.m),
            child: Text(
              title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: appTheme.textStyles.subtitleBold.copyWith(color: color),
            ),
          ),
          IndentDivider(
            color: color,
          ),
          SizedBox(height: Space.m),
        ],
      ),
    );
  }
}

class ContentTitle extends StatelessWidget {
  ContentTitle({
    @required this.title,
    this.padding = const EdgeInsets.all(Space.m),
    this.backgroundColor,
    this.decoration,
    this.icon,
    this.maxLines,
    this.leadingText
  }) : assert(
            backgroundColor == null || decoration == null,
            'Cannot provide both a color and a decoration\n'
            'To provide both, use "decoration: BoxDecoration(color: color)".');

  final String title;
  final EdgeInsets padding;
  final BoxDecoration decoration;
  final Color backgroundColor;
  final Widget icon;
  final int maxLines;
  final String leadingText;
  @override
  Widget build(BuildContext context) {

    
    var appTheme = context.getTheme();
    var icon = this.icon ?? Icon(AppIcons.chevronRight, size: 18, color: appTheme.colors.primary);
    return 
    
     Container(
        decoration: decoration,
        color: decoration == null ? backgroundColor : null,
      //  alignment: Alignment.centerLeft,
        padding: padding,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: Space.s),
              child: icon,
            ),

            Expanded(
              
                child: Text(
              title,
              style: appTheme.textStyles.subtitleBold.copyWith(color: appTheme.colors.primary),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            )),

            if(!leadingText.isNullOrEmpty())
            Expanded(child:Padding(
              padding: EdgeInsets.only(right: Space.l),
              child: Text(leadingText, style: appTheme.textStyles.subtitleBold,textAlign: TextAlign.right,
) ,)
           )
          ],
        ));
  }
}
