import 'package:Movie/domain/domain.dart';
import 'package:Movie/infrastructure/infrastructure.dart';
import 'package:flutter/material.dart';

class MovieSearchField extends StatelessWidget {
  MovieSearchField({Key key, this.localizer, this.tecSearch}) : super(key: key);

  final TextEditingController tecSearch;
  final Localizer localizer;
  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
        child: ScanTextField(
          onSubmitted: (val) async {
            await onSubmit(context, val);
          },
          onClear: () {
            onClear(context);
          },
          textInputAction: TextInputAction.search,
          controller: tecSearch,
          autofocus: true,
          decoration: DenseInputDecoration(hintText: localizer.search, prefixIcon: Icon(AppIcons.magnify)),
        ));
  }

  Future<void> onSubmit(BuildContext context, String filter) async {
    await context.getBloc<SearchMovieCubit>().search(filter);
  }

  void onClear(BuildContext context) {
    context.getBloc<SearchMovieCubit>().clearFilter();
  }
}
