import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const JapaneseWordApp());
}

class JapaneseWordApp extends StatelessWidget {
  const JapaneseWordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Japanese Word Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const WordListScreen(),
    );
  }
}

// Data model for vocabulary item
class JapaneseWord {
  final String kanji;
  final String hiragana;
  final String romaji;
  final String english;

  const JapaneseWord({
    required this.kanji,
    required this.hiragana,
    required this.romaji,
    required this.english,
  });
}

class WordListScreen extends StatefulWidget {
  const WordListScreen({super.key});

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  late FlutterTts _flutterTts;
  final ScrollController _scrollController = ScrollController();

  // Vocabulary dataset
  final List<JapaneseWord> _words = const [
    JapaneseWord(
      kanji: 'こんにちは',
      hiragana: 'こんにちは',
      romaji: 'Konnichiwa',
      english: 'Hello / Good afternoon',
    ),
    JapaneseWord(
      kanji: 'ありがとう',
      hiragana: 'ありがとう',
      romaji: 'Arigatou',
      english: 'Thank you',
    ),
    JapaneseWord(
      kanji: 'さようなら',
      hiragana: 'さようなら',
      romaji: 'Sayounara',
      english: 'Goodbye',
    ),
    JapaneseWord(
      kanji: 'すみません',
      hiragana: 'すみません',
      romaji: 'Sumimasen',
      english: 'Excuse me / Sorry',
    ),
    JapaneseWord(kanji: 'はい', hiragana: 'はい', romaji: 'Hai', english: 'Yes'),
    JapaneseWord(kanji: 'いいえ', hiragana: 'いいえ', romaji: 'Iie', english: 'No'),
    JapaneseWord(kanji: '水', hiragana: 'みず', romaji: 'Mizu', english: 'Water'),
    JapaneseWord(kanji: '猫', hiragana: 'ねこ', romaji: 'Neko', english: 'Cat'),
    JapaneseWord(kanji: '犬', hiragana: 'いぬ', romaji: 'Inu', english: 'Dog'),
    JapaneseWord(
      kanji: '友達',
      hiragana: 'ともだち',
      romaji: 'Tomodachi',
      english: 'Friend',
    ),
    JapaneseWord(
      kanji: '美味しい',
      hiragana: 'おいしい',
      romaji: 'Oishii',
      english: 'Delicious',
    ),
    JapaneseWord(
      kanji: '楽しい',
      hiragana: 'たのしい',
      romaji: 'Tanashii',
      english: 'Fun / Enjoyable',
    ),
    JapaneseWord(
      kanji: '日本',
      hiragana: 'にほん',
      romaji: 'Nihon',
      english: 'Japan',
    ),
    JapaneseWord(
      kanji: '桜',
      hiragana: 'さくら',
      romaji: 'Sakura',
      english: 'Cherry Blossom',
    ),
    JapaneseWord(
      kanji: '頑張って',
      hiragana: 'がんばって',
      romaji: 'Ganbatte',
      english: 'Do your best!',
    ),
  ];

  int _currentIndex = -1; // -1 means no word is currently playing
  bool _isPlayingSequence = false;
  Completer<void>? _speechCompleter;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() {
    _flutterTts = FlutterTts();

    // Set voice language to Japanese
    _flutterTts.setLanguage("ja-JP");
    // _flutterTts.setSpeechRate(0.45); // Slightly slower for better clarity
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);

    // TTS Completion Handler
    _flutterTts.setCompletionHandler(() {
      _completeCurrentSpeech();
    });

    _flutterTts.setCancelHandler(() {
      _completeCurrentSpeech();
    });

    _flutterTts.setErrorHandler((msg) {
      _completeCurrentSpeech();
    });
  }

  void _completeCurrentSpeech() {
    if (_speechCompleter != null && !_speechCompleter!.isCompleted) {
      _speechCompleter!.complete();
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _scrollController.dispose();
    super.dispose();
  }

  // Speaks a word and waits for completion
  Future<void> _speakWord(String text) async {
    _speechCompleter = Completer<void>();
    await _flutterTts.speak(text);

    // Timeout guard in case engine fails to fire completion callback
    await _speechCompleter!.future.timeout(
      const Duration(seconds: 4),
      onTimeout: () {},
    );
  }

  // Main controller for playing all words sequentially
  Future<void> _togglePlayAll() async {
    if (_isPlayingSequence) {
      // Stop execution
      await _stopPlayback();
      return;
    }

    setState(() {
      _isPlayingSequence = true;
    });

    for (int i = 0; i < _words.length; i++) {
      if (!_isPlayingSequence) break;

      setState(() {
        _currentIndex = i;
      });

      _scrollToIndex(i);

      // Speak Japanese text (Kanji/Hiragana)
      await _speakWord(_words[i].kanji);

      // Pause between words
      if (_isPlayingSequence) {
        await Future.delayed(const Duration(milliseconds: 700));
      }
    }

    if (mounted) {
      setState(() {
        _isPlayingSequence = false;
        _currentIndex = -1;
      });
    }
  }

  // Play single item manually
  Future<void> _playSingle(int index) async {
    if (_isPlayingSequence) {
      await _stopPlayback();
    }

    setState(() {
      _currentIndex = index;
    });

    await _speakWord(_words[index].kanji);

    if (mounted && !_isPlayingSequence) {
      setState(() {
        _currentIndex = -1;
      });
    }
  }

  // Stop playback completely
  Future<void> _stopPlayback() async {
    await _flutterTts.stop();
    _completeCurrentSpeech();
    if (mounted) {
      setState(() {
        _isPlayingSequence = false;
        _currentIndex = -1;
      });
    }
  }

  // Automatically scroll list view to item being spoken
  void _scrollToIndex(int index) {
    if (!_scrollController.hasClients) return;
    const itemExtent = 84.0; // Approximate height of each card
    final targetOffset = index * itemExtent;

    _scrollController.animateTo(
      targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Japanese Vocabulary'),
        elevation: 2,
        actions: [
          // PLAY / STOP BUTTON ON TOP BAR
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton.filled(
              icon: Icon(_isPlayingSequence ? Icons.stop : Icons.play_arrow),
              tooltip: _isPlayingSequence ? 'Stop' : 'Play All',
              onPressed: _togglePlayAll,
              style: IconButton.styleFrom(
                backgroundColor: _isPlayingSequence
                    ? Colors.red.shade400
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(12.0),
        itemCount: _words.length,
        itemBuilder: (context, index) {
          final word = _words[index];
          final isCurrent = index == _currentIndex;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(
              color: isCurrent
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isCurrent
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade300,
                width: isCurrent ? 2 : 1,
              ),
              boxShadow: isCurrent
                  ? [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              leading: CircleAvatar(
                backgroundColor: isCurrent
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade200,
                foregroundColor: isCurrent ? Colors.white : Colors.black87,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              title: Row(
                children: [
                  Text(
                    word.kanji,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isCurrent
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${word.hiragana})',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
              subtitle: Text(
                '${word.romaji} • ${word.english}',
                style: const TextStyle(fontSize: 13),
              ),
              trailing: IconButton(
                icon: Icon(
                  isCurrent ? Icons.volume_up : Icons.volume_up_outlined,
                  color: isCurrent
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
                onPressed: () => _playSingle(index),
              ),
            ),
          );
        },
      ),
    );
  }
}
