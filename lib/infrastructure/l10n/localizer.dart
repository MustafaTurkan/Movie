import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'locales/messages_all.dart';
import 'package:Movie/infrastructure/infrastructure.dart';
import 'dart:ui' as ui;

class Localizer {
  // workaroud for contextless translation
  // see https://github.com/flutter/flutter/issues/14518#issuecomment-447481671
  static Localizer instance;

  static Future<Localizer> load(Locale locale) {
    final String name = locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      instance = Localizer();
      return instance;
    });
  }

  static Localizer of(BuildContext context) {
    return Localizations.of<Localizer>(context, Localizer);
  }

  String get appName => Intl.message('Movie');
  String get recordNotFound => Intl.message('Record not found!');
  String get noData => Intl.message('No data');
  String get anUnExpectedErrorOccurred => Intl.message('An unexpected error occurred!');
  String get loading => Intl.message('Loading...');
  String get search => Intl.message('Search');
  String get completed => Intl.message('Completed');
  String get title => Intl.message('Title');  String get ok => Intl.message('OK');
  String get yes => Intl.message('Yes');
  String get no => Intl.message('No');
  String get cancel => Intl.message('Cancel');
  String get close => Intl.message('Close');
  String get warning => Intl.message('Warning');
  String get error => Intl.message('Error');
  String get information => Intl.message('Information');
  String get question => Intl.message('Question');
  String get message => Intl.message('Message');
  String get requiredValue => Intl.message('Required');
  String get mustBeGreaterThanZero => Intl.message('Must be greater than zero');
  String get findMovie => Intl.message('You find a movie');
  String get favorites => Intl.message('Favorites');
    String get deleting => Intl.message('Deleting');
  String get emptyFavorite => Intl.message('Your favorites are empty yet');


  //dynamic text translate
  String translate(String text,
      {String desc = '',
      Map<String, Object> examples = const {},
      String locale,
      String name,
      List<Object> args,
      String meaning,
      bool skip}) {
    return Intl.message(text,
        desc: desc, examples: examples, locale: locale, name: name, args: args, meaning: meaning, skip: skip);
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<Localizer> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocale.supportedLocales.any((l) => l.languageCode == locale.languageCode);
  }

  @override
  Future<Localizer> load(Locale locale) {
    return Localizer.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<Localizer> old) {
    return false;
  }
}

class AppLocale with ChangeNotifier {
  AppLocale({String languageCode}) {
    if (!languageCode.isNullOrWhiteSpace() && supportedLocales.any((l) => l.languageCode == locale.languageCode)) {
      _locale = Locale(languageCode);
    }
  }

  Locale _locale;

  Locale get locale => _locale ?? ui.window.locale;

  static Iterable<Locale> get supportedLocales {
    return [const Locale('en'), const Locale('tr')];
  }

  void setLocale(Locale locale) {
    assert(locale != null);
    if (locale == null || !supportedLocales.any((l) => l.languageCode == locale.languageCode)) {
      debugPrint('Un supported App locale :${locale.languageCode}');
      //throw AppError(message: 'Un supported App locale :${locale.languageCode}');
    }
    if (_locale == null || _locale.languageCode != locale.languageCode) {
      _locale = locale;
      notifyListeners();
    }
  }
}
