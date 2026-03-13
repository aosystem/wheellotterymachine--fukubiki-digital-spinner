import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_review/in_app_review.dart';

import 'package:wheellotterymachine/l10n/app_localizations.dart';
import 'package:wheellotterymachine/ad_manager.dart';
import 'package:wheellotterymachine/ad_banner_widget.dart';
import 'package:wheellotterymachine/ad_ump_status.dart';
import 'package:wheellotterymachine/model.dart';
import 'package:wheellotterymachine/text_to_speech.dart';
import 'package:wheellotterymachine/theme_color.dart';
import 'package:wheellotterymachine/loading_screen.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late AdManager _adManager;
  late UmpConsentController _adUmp;
  AdUmpState _adUmpState = AdUmpState.initial;
  int _themeNumber = 0;
  String _languageCode = '';
  late ThemeColor _themeColor;
  final _inAppReview = InAppReview.instance;
  bool _isReady = false;
  bool _isFirst = true;
  //
  final List<TextEditingController> _nameControls = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  final List<TextEditingController> _qtyControls = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  late final TextEditingController _pinControl;
  late final TextEditingController _animationSpeedControl;
  int _animationQuick = 0;
  double _machineVolume = 1.0;
  late List<TtsOption> _ttsVoices;
  bool _ttsEnabled = true;
  double _ttsVolume = 1.0;
  String _ttsVoiceId = '';
  int _schemeColor = 0;
  Color _accentColor = Colors.red;
  //
  final List<String> _ballAssets = const [
    'assets/image/ball_gold.png',
    'assets/image/ball_silver.png',
    'assets/image/ball_purple.png',
    'assets/image/ball_blue.png',
    'assets/image/ball_green.png',
    'assets/image/ball_yellow.png',
    'assets/image/ball_red.png',
    'assets/image/ball_white.png',
  ];
  final List<String> _ballLabels = const [
    'GOLD',
    'SILVER',
    'PURPLE',
    'BLUE',
    'GREEN',
    'YELLOW',
    'RED',
    'WHITE',
  ];

  @override
  void initState() {
    super.initState();
    _initState();
  }

  Future<void> _initState() async {
    _adManager = AdManager();
    _themeNumber = Model.themeNumber;
    _languageCode = Model.languageCode;
    //
    _adUmp = UmpConsentController();
    _refreshConsentInfo();
    //
    _nameControls[0] = TextEditingController(text: Model.itemName1);
    _nameControls[1] = TextEditingController(text: Model.itemName2);
    _nameControls[2] = TextEditingController(text: Model.itemName3);
    _nameControls[3] = TextEditingController(text: Model.itemName4);
    _nameControls[4] = TextEditingController(text: Model.itemName5);
    _nameControls[5] = TextEditingController(text: Model.itemName6);
    _nameControls[6] = TextEditingController(text: Model.itemName7);
    _nameControls[7] = TextEditingController(text: Model.itemName8);
    _qtyControls[0] = TextEditingController(text: Model.itemQty1.toString());
    _qtyControls[1] = TextEditingController(text: Model.itemQty2.toString());
    _qtyControls[2] = TextEditingController(text: Model.itemQty3.toString());
    _qtyControls[3] = TextEditingController(text: Model.itemQty4.toString());
    _qtyControls[4] = TextEditingController(text: Model.itemQty5.toString());
    _qtyControls[5] = TextEditingController(text: Model.itemQty6.toString());
    _qtyControls[6] = TextEditingController(text: Model.itemQty7.toString());
    _qtyControls[7] = TextEditingController(text: Model.itemQty8.toString());
    _pinControl = TextEditingController(text: Model.pin);
    _animationSpeedControl = TextEditingController(text: Model.animationSpeed.toString());
    _animationQuick = Model.animationQuick;
    _machineVolume = Model.machineVolume;
    _ttsEnabled = Model.ttsEnabled;
    _ttsVolume = Model.ttsVolume;
    _ttsVoiceId = Model.ttsVoiceId;
    _schemeColor = Model.schemeColor;
    _accentColor = _getRainbowAccentColor(_schemeColor);
    //speech
    await TextToSpeech.getInstance();
    _ttsVoices = TextToSpeech.ttsVoices;
    //
    setState(() {
      _isReady = true;
    });
  }

  @override
  void dispose() {
    _pinControl.dispose();
    _animationSpeedControl.dispose();
    for (final c in _nameControls) {
      c.dispose();
    }
    for (final c in _qtyControls) {
      c.dispose();
    }
    _adManager.dispose();
    unawaited(TextToSpeech.stop());
    super.dispose();
  }

  Future<void> _refreshConsentInfo() async {
    _adUmpState = await _adUmp.updateConsentInfo(current: _adUmpState);
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _onTapPrivacyOptions() async {
    final err = await _adUmp.showPrivacyOptions();
    await _refreshConsentInfo();
    if (err != null && mounted) {
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l.cmpErrorOpeningSettings} ${err.message}')),
      );
    }
  }

  Color _getRainbowAccentColor(int hue) {
    return HSVColor.fromAHSV(1.0, hue.toDouble(), 1.0, 1.0).toColor();
  }

  void _onApply() async {
    await Model.setItemName1(_nameControls[0].text.trim());
    await Model.setItemName2(_nameControls[1].text.trim());
    await Model.setItemName3(_nameControls[2].text.trim());
    await Model.setItemName4(_nameControls[3].text.trim());
    await Model.setItemName5(_nameControls[4].text.trim());
    await Model.setItemName6(_nameControls[5].text.trim());
    await Model.setItemName7(_nameControls[6].text.trim());
    await Model.setItemName8(_nameControls[7].text.trim());
    await Model.setItemQty1(int.tryParse(_qtyControls[0].text.trim()) ?? 0);
    await Model.setItemQty2(int.tryParse(_qtyControls[1].text.trim()) ?? 0);
    await Model.setItemQty3(int.tryParse(_qtyControls[2].text.trim()) ?? 0);
    await Model.setItemQty4(int.tryParse(_qtyControls[3].text.trim()) ?? 0);
    await Model.setItemQty5(int.tryParse(_qtyControls[4].text.trim()) ?? 0);
    await Model.setItemQty6(int.tryParse(_qtyControls[5].text.trim()) ?? 0);
    await Model.setItemQty7(int.tryParse(_qtyControls[6].text.trim()) ?? 0);
    await Model.setItemQty8(int.tryParse(_qtyControls[7].text.trim()) ?? 0);
    await Model.setPin(_pinControl.text.trim());
    await Model.setAnimationSpeed(int.tryParse(_animationSpeedControl.text.trim()) ?? 25);
    await Model.setAnimationQuick(_animationQuick);
    await Model.setMachineVolume(_machineVolume);
    await Model.setTtsEnabled(_ttsEnabled);
    await Model.setTtsVolume(_ttsVolume);
    await Model.setTtsVoiceId(_ttsVoiceId);
    await Model.setSchemeColor(_schemeColor);
    await Model.setThemeNumber(_themeNumber);
    await Model.setLanguageCode(_languageCode);
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const LoadingScreen();
    }
    if (_isFirst) {
      _isFirst = false;
      _themeColor = ThemeColor(themeNumber: _themeNumber, context: context);
    }
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: _themeColor.backColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: l.cancel,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: null,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: _onApply,
              tooltip: l.apply,
              icon: const Icon(Icons.check),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 100),
                  children: [
                    _buildItemsTable(l),
                    _buildPin(l),
                    _buildAnimationSpeed(l),
                    _buildAnimationQuick(l),
                    _buildMachineVolume(l),
                    _buildSpeech(l),
                    _buildSchemeColor(l),
                    _buildTheme(l),
                    _buildLanguage(l),
                    _buildReview(l),
                    _buildCmp(l),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
          AdBannerWidget(adManager: _adManager),
        ],
      ),
    );
  }

  Widget _buildItemsTable(AppLocalizations l) {
    return Card(
      margin: const EdgeInsets.only(left: 4, top: 0, right: 4, bottom: 0),
      color: _themeColor.cardColor,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.resultsAndQuantity),
            const SizedBox(height: 8),
            Table(
              columnWidths: const {
                0: FixedColumnWidth(24),
                1: IntrinsicColumnWidth(),
                2: FlexColumnWidth(1),
                3: FixedColumnWidth(64),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: List.generate(8, (i) {
                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Image.asset(_ballAssets[i], width: 20, height: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(_ballLabels[i]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: TextField(
                        controller: _nameControls[i],
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Name',
                        ),
                        inputFormatters: [LengthLimitingTextInputFormatter(50)],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: SizedBox(
                        width: 60,
                        child: TextField(
                          controller: _qtyControls[i],
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(isDense: true),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPin(AppLocalizations l) {
    return Card(
      margin: const EdgeInsets.only(left: 4, top: 12, right: 4, bottom: 0),
      color: _themeColor.cardColor,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(l.pin),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _pinControl,
                    obscureText: true,
                    decoration: const InputDecoration(isDense: true),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              l.pinNote,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimationSpeed(AppLocalizations l) {
    return Card(
      margin: const EdgeInsets.only(left: 4, top: 12, right: 4, bottom: 0),
      color: _themeColor.cardColor,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(l.animationSpeed),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _animationSpeedControl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(isDense: true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimationQuick(AppLocalizations l) {
    return Card(
      margin: const EdgeInsets.only(left: 4, top: 12, right: 4, bottom: 0),
      color: _themeColor.cardColor,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.animationQuick),
            Row(
              children: <Widget>[
                Text(_animationQuick.toString()),
                Expanded(
                  child: Slider(
                    value: _animationQuick.toDouble(),
                    min: 0,
                    max: 4,
                    divisions: 4,
                    label: _animationQuick.toString(),
                    onChanged: (v) => setState(() => _animationQuick = v.round()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMachineVolume(AppLocalizations l) {
    return Card(
      margin: const EdgeInsets.only(left: 4, top: 12, right: 4, bottom: 0),
      color: _themeColor.cardColor,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.machineVolume),
            Row(
              children: <Widget>[
                Text(_machineVolume.toStringAsFixed(1)),
                Expanded(
                  child: Slider(
                    value: _machineVolume,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: _machineVolume.toStringAsFixed(1),
                    onChanged: (v) => setState(() => _machineVolume = v),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeech(AppLocalizations l) {
    if (_ttsVoices.isEmpty) {
      return SizedBox.shrink();
    }
    return Column(children:[
      Card(
        margin: const EdgeInsets.only(left: 4, top: 12, right: 4, bottom: 0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
        color: _themeColor.cardColor,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l.ttsEnabled,
                    ),
                  ),
                  Switch(
                    value: _ttsEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        _ttsEnabled = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        )
      ),
      Card(
        margin: const EdgeInsets.only(left: 4, top: 2, right: 4, bottom: 0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
        color: _themeColor.cardColor,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
              child: Row(
                children: [
                  Text(
                    l.ttsVolume,
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                children: <Widget>[
                  Text(_ttsVolume.toStringAsFixed(1)),
                  Expanded(
                    child: Slider(
                      value: _ttsVolume,
                      min: 0.0,
                      max: 1.0,
                      divisions: 10,
                      label: _ttsVolume.toStringAsFixed(1),
                      onChanged: _ttsEnabled
                          ? (double value) {
                        setState(() {
                          _ttsVolume = double.parse(
                            value.toStringAsFixed(1),
                          );
                        });
                      }
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
      Card(
        margin: const EdgeInsets.only(left: 4, top: 2, right: 4, bottom: 0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        color: _themeColor.cardColor,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 16),
              child: DropdownButtonFormField<String>(
                initialValue: () {
                  if (_ttsVoiceId.isNotEmpty && _ttsVoices.any((o) => o.id == _ttsVoiceId)) {
                    return _ttsVoiceId;
                  }
                  return _ttsVoices.first.id;
                }(),
                items: _ttsVoices
                    .map((o) => DropdownMenuItem<String>(value: o.id, child: Text(o.label)))
                    .toList(),
                onChanged: (v) {
                  if (v == null) {
                    return;
                  }
                  setState(() => _ttsVoiceId = v);
                },
              ),
            ),
          ],
        )
      )
    ]);
  }

  Widget _buildSchemeColor(AppLocalizations l) {
    return Card(
        margin: const EdgeInsets.only(left: 0, top: 12, right: 0, bottom: 0),
        color: _themeColor.cardColor,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Row(
                children: [
                  Text(l.colorScheme),
                  const Spacer(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                children: <Widget>[
                  Text(_schemeColor.toStringAsFixed(0)),
                  Expanded(
                      child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: _accentColor,
                            inactiveTrackColor: _accentColor.withValues(alpha: 0.3),
                            thumbColor: _accentColor,
                            overlayColor: _accentColor.withValues(alpha: 0.2),
                            valueIndicatorColor: _accentColor,
                          ),
                          child: Slider(
                              value: _schemeColor.toDouble(),
                              min: 0,
                              max: 360,
                              divisions: 360,
                              label: _schemeColor.toString(),
                              onChanged: (double value) {
                                setState(() {
                                  _schemeColor = value.toInt();
                                  _accentColor = _getRainbowAccentColor(_schemeColor);
                                });
                              }
                          )
                      )
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }

  Widget _buildTheme(AppLocalizations l) {
    final TextTheme t = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.only(left: 4, top: 12, right: 4, bottom: 0),
      color: _themeColor.cardColor,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                l.theme,
                style: t.bodyMedium,
              ),
            ),
            DropdownButton<int>(
              value: _themeNumber,
              items: [
                DropdownMenuItem(value: 0, child: Text(l.systemSetting)),
                DropdownMenuItem(value: 1, child: Text(l.lightTheme)),
                DropdownMenuItem(value: 2, child: Text(l.darkTheme)),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _themeNumber = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguage(AppLocalizations l) {
    final Map<String,String> languageNames = {
      'af': 'af: Afrikaans',
      'ar': 'ar: العربية',
      'bg': 'bg: Български',
      'bn': 'bn: বাংলা',
      'bs': 'bs: Bosanski',
      'ca': 'ca: Català',
      'cs': 'cs: Čeština',
      'da': 'da: Dansk',
      'de': 'de: Deutsch',
      'el': 'el: Ελληνικά',
      'en': 'en: English',
      'es': 'es: Español',
      'et': 'et: Eesti',
      'fa': 'fa: فارسی',
      'fi': 'fi: Suomi',
      'fil': 'fil: Filipino',
      'fr': 'fr: Français',
      'gu': 'gu: ગુજરાતી',
      'he': 'he: עברית',
      'hi': 'hi: हिन्दी',
      'hr': 'hr: Hrvatski',
      'hu': 'hu: Magyar',
      'id': 'id: Bahasa Indonesia',
      'it': 'it: Italiano',
      'ja': 'ja: 日本語',
      'km': 'km: ខ្មែរ',
      'kn': 'kn: ಕನ್ನಡ',
      'ko': 'ko: 한국어',
      'lt': 'lt: Lietuvių',
      'lv': 'lv: Latviešu',
      'ml': 'ml: മലയാളം',
      'mr': 'mr: मराठी',
      'ms': 'ms: Bahasa Melayu',
      'my': 'my: မြန်မာ',
      'ne': 'ne: नेपाली',
      'nl': 'nl: Nederlands',
      'or': 'or: ଓଡ଼ିଆ',
      'pa': 'pa: ਪੰਜਾਬੀ',
      'pl': 'pl: Polski',
      'pt': 'pt: Português',
      'ro': 'ro: Română',
      'ru': 'ru: Русский',
      'si': 'si: සිංහල',
      'sk': 'sk: Slovenčina',
      'sr': 'sr: Српски',
      'sv': 'sv: Svenska',
      'sw': 'sw: Kiswahili',
      'ta': 'ta: தமிழ்',
      'te': 'te: తెలుగు',
      'th': 'th: ไทย',
      'tl': 'tl: Tagalog',
      'tr': 'tr: Türkçe',
      'uk': 'uk: Українська',
      'ur': 'ur: اردو',
      'uz': 'uz: Oʻzbekcha',
      'vi': 'vi: Tiếng Việt',
      'zh': 'zh: 中文',
      'zu': 'zu: isiZulu',
    };
    final TextTheme t = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.only(left: 4, top: 12, right: 4, bottom: 0),
      color: _themeColor.cardColor,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                l.language,
                style: t.bodyMedium,
              ),
            ),
            DropdownButton<String?>(
              value: _languageCode,
              items: [
                DropdownMenuItem(value: '', child: Text('Default')),
                ...languageNames.entries.map((entry) => DropdownMenuItem<String?>(
                  value: entry.key,
                  child: Text(entry.value),
                )),
              ],
              onChanged: (String? value) {
                setState(() {
                  _languageCode = value ?? '';
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReview(AppLocalizations l) {
    final TextTheme t = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.only(left: 0, top: 12, right: 0, bottom: 0),
      color: _themeColor.cardColor,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.reviewApp, style: t.bodyMedium),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  icon: Icon(Icons.open_in_new, size: 16),
                  label: Text(l.reviewStore, style: t.bodySmall),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 12),
                    side: BorderSide(color: Theme.of(context).colorScheme.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    await _inAppReview.openStoreListing(
                      appStoreId: 'YOUR_APP_STORE_ID',
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCmp(AppLocalizations l) {
    String statusLabel;
    IconData statusIcon;
    final showButton =
        _adUmpState.privacyStatus == PrivacyOptionsRequirementStatus.required;
    statusLabel = l.cmpCheckingRegion;
    statusIcon = Icons.help_outline;
    switch (_adUmpState.privacyStatus) {
      case PrivacyOptionsRequirementStatus.required:
        statusLabel = l.cmpRegionRequiresSettings;
        statusIcon = Icons.privacy_tip;
        break;
      case PrivacyOptionsRequirementStatus.notRequired:
        statusLabel = l.cmpRegionNoSettingsRequired;
        statusIcon = Icons.check_circle_outline;
        break;
      case PrivacyOptionsRequirementStatus.unknown:
        statusLabel = l.cmpRegionCheckFailed;
        statusIcon = Icons.error_outline;
        break;
    }
    return Card(
      margin: const EdgeInsets.only(left: 4, top: 12, right: 4, bottom: 0),
      color: _themeColor.cardColor,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding:
        const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.cmpSettingsTitle,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(l.cmpConsentDescription,
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Center(
              child: Column(
                children: [
                  Chip(
                    avatar: Icon(statusIcon, size: 18),
                    label: Text(statusLabel),
                    side: BorderSide.none,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${l.cmpConsentStatusLabel} ${_adUmpState.consentStatus.localized(context)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (showButton)
                    Column(children: [
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _adUmpState.isChecking
                            ? null
                            : _onTapPrivacyOptions,
                        icon: const Icon(Icons.settings),
                        label: Text(_adUmpState.isChecking
                            ? l.cmpConsentStatusChecking
                            : l.cmpOpenConsentSettings),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          side: BorderSide(
                            width: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed:
                        _adUmpState.isChecking ? null : _refreshConsentInfo,
                        icon: const Icon(Icons.refresh),
                        label: Text(l.cmpRefreshStatus),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: () async {
                          await ConsentInformation.instance.reset();
                          await _refreshConsentInfo();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l.cmpResetStatusDone)));
                          }
                        },
                        icon: const Icon(Icons.refresh),
                        label: Text(l.cmpResetStatus),
                      ),
                    ])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
