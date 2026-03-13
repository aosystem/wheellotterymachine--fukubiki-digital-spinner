import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:wheellotterymachine/ad_banner_widget.dart';
import 'package:wheellotterymachine/ad_manager.dart';
import 'package:wheellotterymachine/frame_painter.dart';
import 'package:wheellotterymachine/l10n/app_localizations.dart';
import 'package:wheellotterymachine/parse_locale_tag.dart';
import 'package:wheellotterymachine/pin_prompt.dart';
import 'package:wheellotterymachine/settings_page.dart';
import 'package:wheellotterymachine/text_to_speech.dart';
import 'package:wheellotterymachine/item_state.dart';
import 'package:wheellotterymachine/model.dart';
import 'package:wheellotterymachine/machine_frame_cache.dart';
import 'package:wheellotterymachine/theme_color.dart';
import 'package:wheellotterymachine/theme_mode_number.dart';
import 'package:wheellotterymachine/main.dart';
import 'package:wheellotterymachine/loading_screen.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});
  @override
  State<MainHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<MainHomePage> with SingleTickerProviderStateMixin {
  late List<ui.Image> _decodedFrames = [];
  final List<String> _balls = const [
    'assets/image/ball_gold.png',
    'assets/image/ball_silver.png',
    'assets/image/ball_purple.png',
    'assets/image/ball_blue.png',
    'assets/image/ball_green.png',
    'assets/image/ball_yellow.png',
    'assets/image/ball_red.png',
    'assets/image/ball_white.png',
  ];
  final Map<int, Offset> _pos = const {
    95: Offset(440, 540),
    96: Offset(457, 558),
    97: Offset(474, 589),
    98: Offset(492, 630),
    99: Offset(508, 620),
    100: Offset(527, 614),
    101: Offset(547, 616),
    102: Offset(567, 627),
    103: Offset(586, 651),
    104: Offset(601, 647),
    105: Offset(617, 650),
    106: Offset(634, 665),
    107: Offset(646, 670),
    108: Offset(657, 680),
    109: Offset(669, 709),
    110: Offset(680, 710),
  };
  late AdManager _adManager;
  final _audio = AudioPlayer();
  late AnimationController _machineAnimationController;
  bool _busy = false;
  int _frame = 0;
  int _choice = 0;
  String _result = '';
  bool _showResult = false;
  late List<ItemState> _items;
  Offset? _lastBallNormPos;
  //
  late ThemeColor _themeColor;
  bool _isReady = false;
  bool _isFirst = true;

  @override
  void initState() {
    super.initState();
    _initState();
  }

  void _initState() async {
    _adManager = AdManager();
    await TextToSpeech.applyPreferences(Model.ttsVoiceId,Model.ttsVolume);
    _itemsUpdate();
    _machineAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1),
    )
    ..addListener(() {
      final value = _machineAnimationController.value;
      final step = _frameStep();
      final frame = (value * _displayedFrameCount()).floor() * step;
      if (frame != _frame) {
        setState(() {
          _frame = frame;
        });
      }
    })
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _busy = false;
          final lastFrameIndex = _decodedFrames.isEmpty
              ? 119
              : min(119, _decodedFrames.length - 1);
          _frame = lastFrameIndex;
          _showResult = true;
        });
      }
    });
    //
    await _warmMachineFrames();
    if (mounted) {
      setState(() {
        _isReady = true;
      });
    }
  }

  void _itemsUpdate() {
    _items = [
      ItemState(name: Model.itemName1, qty: Model.itemQty1),
      ItemState(name: Model.itemName2, qty: Model.itemQty2),
      ItemState(name: Model.itemName3, qty: Model.itemQty3),
      ItemState(name: Model.itemName4, qty: Model.itemQty4),
      ItemState(name: Model.itemName5, qty: Model.itemQty5),
      ItemState(name: Model.itemName6, qty: Model.itemQty6),
      ItemState(name: Model.itemName7, qty: Model.itemQty7),
      ItemState(name: Model.itemName8, qty: Model.itemQty8),
    ];
  }

  @override
  void dispose() {
    _machineAnimationController.dispose();
    _adManager.dispose();
    _audio.dispose();
    TextToSpeech.stop();
    super.dispose();
  }

  Future<void> _speakResult() async {
    if (_result != '' && Model.ttsEnabled && Model.ttsVolume > 0.0) {
      unawaited(TextToSpeech.speak(_result));
    }
  }

  Future<void> _warmMachineFrames() async {
    try {
      final frames = await MachineFrameCache.load();
      if (!mounted) {
        return;
      }
      setState(() {
        _decodedFrames = frames;
      });
    } catch (_) {
    }
  }

  Widget _frameImage(int idx, int targetWidthPx) {
    if (_decodedFrames.isEmpty) {
      return const SizedBox.shrink();
    }
    final safeIndex = idx.clamp(0, _decodedFrames.length - 1).toInt();
    return Center(
      child: SizedBox(
        width: targetWidthPx.toDouble(),
        height: targetWidthPx.toDouble(),
        child: CustomPaint(painter: FramePainter(_decodedFrames[safeIndex])),
      ),
    );
  }

  Future<void> _onStart() async {
    if (_busy) {
      return;
    }
    setState(() {
      _busy = true;
      _result = '';
      _showResult = false;
      _frame = 0;
      _lastBallNormPos = null;
    });
    final sum = _items.fold<int>(0, (p, e) => p + e.qty);
    if (sum == 0) {
      setState(() {
        _result = AppLocalizations.of(context).empty;
        _showResult = true;
        _busy = false;
      });
      return;
    }
    final rnd = Random();
    int remain = rnd.nextInt(sum);
    int choice = 0;
    for (int i = 0; i < _items.length; i++) {
      final q = _items[i].qty;
      if (q == 0) {
        continue;
      }
      if (remain >= q) {
        remain -= q;
      } else {
        choice = i;
        await Model.setQtyResult(choice);
        _itemsUpdate();
        break;
      }
    }
    _choice = choice;
    if (Model.machineVolume > 0) {
      try {
        await _audio.setSource(AssetSource('sound/garagara2.wav'));
        await _audio.setVolume(Model.machineVolume);
        await _audio.setPlaybackRate((Model.animationQuick + 1).toDouble());
        unawaited(_audio.resume());
      } catch (_) {}
    }
    _machineAnimationController
      ..duration = Duration(milliseconds: Model.animationSpeed * _displayedFrameCount())
      ..reset();
    await _machineAnimationController.forward();
    _result = _items[_choice].name;
    unawaited(_speakResult());
  }

  int _frameStep() {
    switch (Model.animationQuick) {
      case 1:
        return 2;
      case 2:
        return 3;
      case 3:
        return 4;
      case 4:
        return 6;
      default:
        return 1;
    }
  }

  int _displayedFrameCount() {
    final step = _frameStep();
    return (120 / step).round();
  }

  Future<void> _onSetting() async {
    if (_busy) {
      return;
    }
    if (Model.pin.isNotEmpty) {
      final ok = await PinPrompt.show(context, correctPin: Model.pin);
      if (!ok) {
        return;
      }
    }
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const SettingPage()),
    );
    if (!mounted) {
      return;
    }
    if (updated == true) {
      final mainState = context.findAncestorStateOfType<MainAppState>();
      if (mainState != null) {
        mainState
          ..themeMode = ThemeModeNumber.numberToThemeMode(Model.themeNumber)
          ..locale = parseLocaleTag(Model.languageCode)
          ..setState(() {});
      }
      await TextToSpeech.applyPreferences(Model.ttsVoiceId,Model.ttsVolume);
      _itemsUpdate();
      _isFirst = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const LoadingScreen();
    }
    if (_isFirst) {
      _isFirst = false;
      _themeColor = ThemeColor(context: context);
    }
    return Scaffold(
      backgroundColor: _themeColor.mainBack2Color,
      body: Stack(children:[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_themeColor.mainBack2Color, _themeColor.mainBackColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            image: DecorationImage(
              image: AssetImage('assets/image/tile.png'),
              repeat: ImageRepeat.repeat,
              opacity: 0.1,
            ),
          ),
        ),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      onPressed: _busy ? null : _onSetting,
                      tooltip: AppLocalizations.of(context).setting,
                      icon: Icon(
                        Icons.settings,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, c) {
                    final box = min(c.maxWidth, c.maxHeight);
                    final ml = (c.maxWidth - box) / 2;
                    final mt = (c.maxHeight - box) / 2;
                    final bs = box / 25;
                    final op = (_frame >= 95 || _showResult) ? 1.0 : 0.0;
                    Offset? p = _pos[_frame];
                    if (p == null && _frame >= 95) {
                      final keys = _pos.keys.where((k) => k <= _frame).toList()
                        ..sort();
                      if (keys.isNotEmpty) p = _pos[keys.last];
                    }
                    if (p != null) {
                      _lastBallNormPos = p;
                    }
                    final useP = p ?? (_showResult ? _lastBallNormPos : null);
                    double? x, y;
                    if (useP != null) {
                      final px = box / 900.0;
                      final h = bs / 2;
                      x = ml + px * useP.dx - h;
                      y = mt + px * useP.dy - h;
                    }
                    final idx = _frame.clamp(0, 119).toInt();
                    final dpr = MediaQuery.of(context).devicePixelRatio;
                    final targetWidthPx = max(1, (box * dpr).round());
                    return Stack(
                      children: [
                        _frameImage(idx, targetWidthPx),
                        if (x != null && y != null)
                          Positioned(
                            left: x,
                            top: y,
                            width: bs,
                            height: bs,
                            child: Opacity(
                              opacity: op,
                              child: Image.asset(
                                _balls[_choice],
                                cacheWidth: max(1, (bs * dpr).round()),
                                filterQuality: FilterQuality.low,
                              ),
                            ),
                          ),
                        Positioned(
                          left: ml,
                          top: mt,
                          width: box,
                          height: box,
                          child: IgnorePointer(
                            child: AnimatedOpacity(
                              opacity: _showResult ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 0),
                                  child: Text(
                                    _result,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Opacity(
                  opacity: _busy ? 0.4 : 1.0,
                  child: ElevatedButton(
                    onPressed: _busy ? null : _onStart,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      fixedSize: const Size(130, 130),
                      backgroundColor: Colors.white.withValues(alpha: 0.25),
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppLocalizations.of(context).drawLot,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: _themeColor.mainBackColor),
        child: AdBannerWidget(adManager: _adManager),
      ),
    );
  }

}
