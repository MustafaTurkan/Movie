import 'package:Movie/app.dart';
import 'package:Movie/domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  Bloc.observer = AppBlocObserver();
  await App().run();
}