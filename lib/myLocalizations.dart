 import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyLocalizations {
  MyLocalizations(this.locale);

  final Locale locale;

  static MyLocalizations of(BuildContext context) {
    return Localizations.of<MyLocalizations>(context, MyLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = Map();
  Future<bool> load( ) async{
    ///load the lang code of the locale
    String data = await rootBundle.loadString('resources/lang/${locale.languageCode}.json');
    Map<String, dynamic> _result =json.decode(data);
    Map<String, String> _value= Map();
    _result.forEach((String key,  dynamic value) {
      _value[key] =_value.toString();
    });

    _localizedValues[this.locale.languageCode]= _value;
    return true;
  }

  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }

  String find(String key) {
    return _localizedValues[locale.languageCode][key] ?? '';
  }
}

class MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalizations> {
  const MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'de', 'he'].contains(locale.languageCode);
  }

  @override
  Future<MyLocalizations> load(Locale locale) async{
   MyLocalizations  localizations = MyLocalizations(locale);
   await localizations.load();
   return localizations;
  }
///return true if u want to reload a widget localisation when it rebuilds
  @override
  bool shouldReload(MyLocalizationsDelegate old) => false;
}