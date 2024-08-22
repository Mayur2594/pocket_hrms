import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pocket_hrms/languages/index.dart';
import 'package:pocket_hrms/mixins/shared_preferences_mixin.dart';

class LocalizationService extends Translations with SharedPreferencesMixin {
  static final locale = Locale('en', 'US');
  static final fallbackLocale = Locale('en', 'US');

  static final langs = [
    'English',
    'हिन्दी', //hindi
    'मराठी', // marathi
    'தமிழ்', // tamil
    'తెలుగు', // telugu
    'বাংলা', // bangla
    'ಕನ್ನಡ' // Kannada
  ];

  static final locales = [
    Locale('en', 'US'),
    Locale('hi', 'IN'),
    Locale('mr', 'IN'),
    Locale('ta', 'IN'),
    Locale('te', 'IN'),
    Locale('bn', 'IN'),
    Locale('kn', 'IN'),
  ];

  var selectedLanuage = '';

  Future<Locale> getSavedLocale() async {
    String langCode = await getValue('LANGUAGE') ?? 'English';
    return _localeFromString(langCode);
  }

  static Locale _localeFromString(String lang) {
    for (int i = 0; i < langs.length; i++) {
      if (langs[i].toLowerCase().contains(lang.toLowerCase())) {
        return locales[i];
      }
    }
    return locales.first;
  }

  void changeLocale(String lang) async {
    final locale = _localeFromString(lang);
    Get.updateLocale(locale);
    await saveValue('LANGUAGE', lang);
  }

  // Keys and their translations
  // Translations are separated maps in `lang` file
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': LanguagesSet().langEn, // english
        'hi_IN': LanguagesSet().langHi, // hindi
        'mr_IN': LanguagesSet().langMr, // marathi
        'ta_IN': LanguagesSet().langTa, // tamil
        'te_IN': LanguagesSet().langTe, // telugu
        'bn_IN': LanguagesSet().langBn, // bengali
        'kn_IN': LanguagesSet().langKn, // kannada
      };
}
