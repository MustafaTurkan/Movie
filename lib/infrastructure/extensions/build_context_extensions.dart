
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Movie/infrastructure/infrastructure.dart';
import 'package:provider/provider.dart';

extension BuildContextExtensions on BuildContext {
  T get<T>({bool listen = false}) => Provider.of<T>(this, listen: listen);
  T getBloc<T extends Cubit<dynamic>>() => BlocProvider.of<T>(this);
  Localizer getLocalizer() => Localizer.of(this);
  AppTheme getTheme({bool listen = false}) => Provider.of<AppTheme>(this, listen: listen);
  FocusScopeNode getFocusScope() => FocusScope.of(this);
  MediaQueryData getMediaQuery({bool nullOk = false}) => MediaQuery.of(this, nullOk: nullOk);
}
