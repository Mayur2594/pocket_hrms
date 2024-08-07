import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pocket_hrms/languages/index.dart';

class LocalizationService extends Translations {
  static final locale = Locale('en', 'US');
  static final fallbackLocale = Locale('en', 'US');

  Locale? getSavedLocale() {
    var lang = "English";
    print('Selected Lang: ${getLocaleFromLanguage(lang)}');
    return getLocaleFromLanguage(lang);
  }

  String getSavedLanguageString() {
    var lang = "English";
    return lang;
  }

  // Supported languages
  // Needs to be same order with locales
  static final langs = [
    'English',
    'हिन्दी',
    'मराठी',
    'தமிழ்', // tamil
    'తెలుగు', // telugu
    'বাংলা', // bangla
    'ಕನ್ನಡ' // Kannada
  ];

  // Supported locales
  // Needs to be same order with langs
  static final locales = [
    Locale('en', 'US'),
    Locale('hi', 'IN'),
    Locale('mr', 'IN'),
    Locale('ta', 'IN'),
    Locale('te', 'IN'),
    Locale('bn', 'IN'),
    Locale('kn', 'IN'),
  ];

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

  // Gets locale from language, and updates the locale
  void changeLocale(String lang) async {
    final locale = getLocaleFromLanguage(lang);
    Get.updateLocale(locale);
  }

  // Finds language in `langs` list and returns it as Locale
  Locale getLocaleFromLanguage(String lang) {
    try {
      var localLang = null;
      langs.asMap().entries.map((entry) {
        int index = entry.key;
        String language = entry.value;
        if (language == lang) {
          localLang = locales[index];
        }
      }).toList();
      return localLang;
    } catch (ex) {
      return Locale('en', 'US');
    }
  }
}
