import 'dart:ui' as ui;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wheellotterymachine/l10n/app_localizations.dart';

class Model {
  Model._();

  static const String _prefItemName1 = 'itemName1';
  static const String _prefItemName2 = 'itemName2';
  static const String _prefItemName3 = 'itemName3';
  static const String _prefItemName4 = 'itemName4';
  static const String _prefItemName5 = 'itemName5';
  static const String _prefItemName6 = 'itemName6';
  static const String _prefItemName7 = 'itemName7';
  static const String _prefItemName8 = 'itemName8';
  static const String _prefItemQty1 = 'itemQty1';
  static const String _prefItemQty2 = 'itemQty2';
  static const String _prefItemQty3 = 'itemQty3';
  static const String _prefItemQty4 = 'itemQty4';
  static const String _prefItemQty5 = 'itemQty5';
  static const String _prefItemQty6 = 'itemQty6';
  static const String _prefItemQty7 = 'itemQty7';
  static const String _prefItemQty8 = 'itemQty8';
  static const String _prefPin = 'pin';
  static const String _prefAnimationSpeed = 'animationSpeed';
  static const String _prefAnimationQuick = 'animationQuick';
  static const String _prefMachineVolume = 'machineVolume';
  static const String _prefTtsEnabled = 'ttsEnabled';
  static const String _prefTtsVolume = 'ttsVolume';
  static const String _prefTtsVoiceId = 'ttsVoiceId';
  static const String _prefSchemeColor = 'schemeColor';
  static const String _prefThemeNumber = 'themeNumber';
  static const String _prefLanguageCode = 'languageCode';

  static bool _ready = false;
  static String _itemName1 = 'Grand Prize';
  static String _itemName2 = 'Second Prize';
  static String _itemName3 = 'Premium Prize';
  static String _itemName4 = 'Prize A';
  static String _itemName5 = 'Prize B';
  static String _itemName6 = 'Prize C';
  static String _itemName7 = 'Consolation Prize';
  static String _itemName8 = 'Thank You Prize';
  static int _itemQty1 = 1;
  static int _itemQty2 = 1;
  static int _itemQty3 = 2;
  static int _itemQty4 = 2;
  static int _itemQty5 = 3;
  static int _itemQty6 = 10;
  static int _itemQty7 = 100;
  static int _itemQty8 = 500;
  static String _pin = '';
  static int _animationSpeed = 25;
  static int _animationQuick = 0;
  static double _machineVolume = 1.0;
  static bool _ttsEnabled = true;
  static double _ttsVolume = 1.0;
  static String _ttsVoiceId = '';
  static int _schemeColor = 120;
  static int _themeNumber = 0;
  static String _languageCode = '';

  static String get itemName1 => _itemName1;
  static String get itemName2 => _itemName2;
  static String get itemName3 => _itemName3;
  static String get itemName4 => _itemName4;
  static String get itemName5 => _itemName5;
  static String get itemName6 => _itemName6;
  static String get itemName7 => _itemName7;
  static String get itemName8 => _itemName8;
  static int get itemQty1 => _itemQty1;
  static int get itemQty2 => _itemQty2;
  static int get itemQty3 => _itemQty3;
  static int get itemQty4 => _itemQty4;
  static int get itemQty5 => _itemQty5;
  static int get itemQty6 => _itemQty6;
  static int get itemQty7 => _itemQty7;
  static int get itemQty8 => _itemQty8;
  static String get pin => _pin;
  static int get animationSpeed => _animationSpeed;
  static bool get ttsEnabled => _ttsEnabled;
  static double get ttsVolume => _ttsVolume;
  static String get ttsVoiceId => _ttsVoiceId;
  static int get animationQuick => _animationQuick;
  static double get machineVolume => _machineVolume;
  static int get schemeColor => _schemeColor;
  static int get themeNumber => _themeNumber;
  static String get languageCode => _languageCode;

  static Future<void> ensureReady() async {
    if (_ready) {
      return;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //
    _itemName1 = prefs.getString(_prefItemName1) ?? '';
    _itemName2 = prefs.getString(_prefItemName2) ?? '';
    _itemName3 = prefs.getString(_prefItemName3) ?? '';
    _itemName4 = prefs.getString(_prefItemName4) ?? '';
    _itemName5 = prefs.getString(_prefItemName5) ?? '';
    _itemName6 = prefs.getString(_prefItemName6) ?? '';
    _itemName7 = prefs.getString(_prefItemName7) ?? '';
    _itemName8 = prefs.getString(_prefItemName8) ?? '';
    _itemQty1 = (prefs.getInt(_prefItemQty1) ?? 0).clamp(0,9999999);
    _itemQty2 = (prefs.getInt(_prefItemQty2) ?? 0).clamp(0,9999999);
    _itemQty3 = (prefs.getInt(_prefItemQty3) ?? 0).clamp(0,9999999);
    _itemQty4 = (prefs.getInt(_prefItemQty4) ?? 0).clamp(0,9999999);
    _itemQty5 = (prefs.getInt(_prefItemQty5) ?? 0).clamp(0,9999999);
    _itemQty6 = (prefs.getInt(_prefItemQty6) ?? 0).clamp(0,9999999);
    _itemQty7 = (prefs.getInt(_prefItemQty7) ?? 0).clamp(0,9999999);
    _itemQty8 = (prefs.getInt(_prefItemQty8) ?? 0).clamp(0,9999999);
    _pin = prefs.getString(_prefPin) ?? '';
    _animationSpeed = (prefs.getInt(_prefAnimationSpeed) ?? 25).clamp(1, 1000);
    _animationQuick = (prefs.getInt(_prefAnimationQuick) ?? 0).clamp(0, 4);
    _machineVolume = (prefs.getDouble(_prefMachineVolume) ?? 1.0).clamp(0.0, 1.0);
    _ttsEnabled = prefs.getBool(_prefTtsEnabled) ?? true;
    _ttsVolume = (prefs.getDouble(_prefTtsVolume) ?? 1.0).clamp(0.0, 1.0);
    _ttsVoiceId = prefs.getString(_prefTtsVoiceId) ?? '';
    _schemeColor = (prefs.getInt(_prefSchemeColor) ?? 120).clamp(0, 360);
    _themeNumber = (prefs.getInt(_prefThemeNumber) ?? 0).clamp(0, 2);
    _languageCode = prefs.getString(_prefLanguageCode) ?? ui.PlatformDispatcher.instance.locale.languageCode;
    _languageCode = _resolveLanguageCode(_languageCode);
    _setDefaultItems();
    _ready = true;
  }

  static String _resolveLanguageCode(String code) {
    final supported = AppLocalizations.supportedLocales;
    if (supported.any((l) => l.languageCode == code)) {
      return code;
    } else {
      return '';
    }
  }

  static void _setDefaultItems() async {
    if (	_itemName1 == ''
        && _itemName2 == ''
        && _itemName3 == ''
        && _itemName4 == ''
        && _itemName5 == ''
        && _itemName6 == ''
        && _itemName7 == ''
        && _itemName8 == ''
    ) {
      _itemName1 = 'Grand Prize';
      _itemName2 = 'Second Prize';
      _itemName3 = 'Premium Prize';
      _itemName4 = 'Prize A';
      _itemName5 = 'Prize B';
      _itemName6 = 'Prize C';
      _itemName7 = 'Consolation Prize';
      _itemName8 = 'Thank You Prize';
      _itemQty1 = 1;
      _itemQty2 = 1;
      _itemQty3 = 2;
      _itemQty4 = 2;
      _itemQty5 = 3;
      _itemQty6 = 10;
      _itemQty7 = 100;
      _itemQty8 = 500;
      await setItemName1(_itemName1);
      await setItemName2(_itemName2);
      await setItemName3(_itemName3);
      await setItemName4(_itemName4);
      await setItemName5(_itemName5);
      await setItemName6(_itemName6);
      await setItemName7(_itemName7);
      await setItemName8(_itemName8);
      await setItemQty1(_itemQty1);
      await setItemQty2(_itemQty2);
      await setItemQty3(_itemQty3);
      await setItemQty4(_itemQty4);
      await setItemQty5(_itemQty5);
      await setItemQty6(_itemQty6);
      await setItemQty7(_itemQty7);
      await setItemQty8(_itemQty8);
    }
  }

  static Future<void> setQtyResult(int choice) async {
    if (choice == 0) {
      await setItemQty1(_itemQty1 - 1);
    } else if (choice == 1) {
      await setItemQty2(_itemQty2 - 1);
    } else if (choice == 2) {
      await setItemQty3(_itemQty3 - 1);
    } else if (choice == 3) {
      await setItemQty4(_itemQty4 - 1);
    } else if (choice == 4) {
      await setItemQty5(_itemQty5 - 1);
    } else if (choice == 5) {
      await setItemQty6(_itemQty6 - 1);
    } else if (choice == 6) {
      await setItemQty7(_itemQty7 - 1);
    } else if (choice == 7) {
      await setItemQty8(_itemQty8 - 1);
    }
  }

  static Future<void> setItemName1(String value) async {
    _itemName1 = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefItemName1, value);
  }

  static Future<void> setItemName2(String value) async {
    _itemName2 = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefItemName2, value);
  }

  static Future<void> setItemName3(String value) async {
    _itemName3 = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefItemName3, value);
  }

  static Future<void> setItemName4(String value) async {
    _itemName4 = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefItemName4, value);
  }

  static Future<void> setItemName5(String value) async {
    _itemName5 = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefItemName5, value);
  }

  static Future<void> setItemName6(String value) async {
    _itemName6 = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefItemName6, value);
  }

  static Future<void> setItemName7(String value) async {
    _itemName7 = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefItemName7, value);
  }

  static Future<void> setItemName8(String value) async {
    _itemName8 = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefItemName8, value);
  }

  static Future<void> setItemQty1(int value) async {
    _itemQty1 = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefItemQty1, value);
  }

  static Future<void> setItemQty2(int value) async {
    _itemQty2 = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefItemQty2, value);
  }

  static Future<void> setItemQty3(int value) async {
    _itemQty3 = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefItemQty3, value);
  }

  static Future<void> setItemQty4(int value) async {
    _itemQty4 = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefItemQty4, value);
  }

  static Future<void> setItemQty5(int value) async {
    _itemQty5 = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefItemQty5, value);
  }

  static Future<void> setItemQty6(int value) async {
    _itemQty6 = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefItemQty6, value);
  }

  static Future<void> setItemQty7(int value) async {
    _itemQty7 = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefItemQty7, value);
  }

  static Future<void> setItemQty8(int value) async {
    _itemQty8 = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefItemQty8, value);
  }

  static Future<void> setPin(String value) async {
    _pin = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefPin, value);
  }

  static Future<void> setAnimationSpeed(int value) async {
    _animationSpeed = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefAnimationSpeed, value);
  }

  static Future<void> setAnimationQuick(int value) async {
    _animationQuick = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefAnimationQuick, value);
  }

  static Future<void> setMachineVolume(double value) async {
    _machineVolume = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_prefMachineVolume, value);
  }

  static Future<void> setTtsEnabled(bool value) async {
    _ttsEnabled = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefTtsEnabled, value);
  }

  static Future<void> setTtsVolume(double value) async {
    _ttsVolume = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_prefTtsVolume, value);
  }

  static Future<void> setTtsVoiceId(String value) async {
    _ttsVoiceId = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefTtsVoiceId, value);
  }

  static Future<void> setSchemeColor(int value) async {
    _schemeColor = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefSchemeColor, value);
  }

  static Future<void> setThemeNumber(int value) async {
    _themeNumber = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefThemeNumber, value);
  }

  static Future<void> setLanguageCode(String value) async {
    _languageCode = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefLanguageCode, value);
  }

}