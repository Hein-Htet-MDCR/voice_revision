# Flutter TTS Japanese Vocabulary Player

## Overview

Developed a Flutter-based Japanese vocabulary learning application using the `flutter_tts` package. The application displays Japanese vocabulary in Kanji, Hiragana, Romaji, and English while providing text-to-speech pronunciation and sequential playback functionality.

---

## Features Implemented

### 1. Vocabulary Data Model

Created a `JapaneseWord` model to store vocabulary information:

- Kanji
- Hiragana
- Romaji
- English Meaning

Example:

```dart
JapaneseWord(
  kanji: '水',
  hiragana: 'みず',
  romaji: 'Mizu',
  english: 'Water',
)
```

---

### 2. Japanese Text-to-Speech (TTS)

Configured Flutter TTS to pronounce Japanese vocabulary using the Japanese language engine.

```dart
_flutterTts.setLanguage("ja-JP");
_flutterTts.setVolume(1.0);
_flutterTts.setPitch(1.0);
```

**Purpose:**
- Natural Japanese pronunciation
- Support for Kanji and Hiragana reading
- Improved listening practice

---

### 3. Sequential Vocabulary Playback

Implemented automatic playback for the entire vocabulary list.

**Workflow:**

1. Select the first vocabulary item.
2. Pronounce the Japanese text.
3. Wait for speech completion.
4. Move to the next item.
5. Continue until the last word.

```dart
for (int i = 0; i < _words.length; i++) {
  await _speakWord(_words[i].kanji);
}
```

---

### 4. Speech Completion Handling

Implemented TTS event handlers to manage playback status.

```dart
_flutterTts.setCompletionHandler(() {
  _completeCurrentSpeech();
});

_flutterTts.setCancelHandler(() {
  _completeCurrentSpeech();
});

_flutterTts.setErrorHandler((msg) {
  _completeCurrentSpeech();
});
```

**Benefits:**
- Prevents playback interruption
- Handles TTS completion correctly
- Supports error and cancellation recovery

---

### 5. Manual Single-Word Playback

Users can play individual vocabulary items by pressing the speaker icon.

**Features:**
- Instant pronunciation
- Independent playback
- Visual indication of active item

```dart
onPressed: () => _playSingle(index)
```

---

### 6. Automatic List Scrolling

Implemented scrolling synchronization with the currently spoken vocabulary item.

```dart
_scrollToIndex(i);
```

**Benefits:**
- Automatically focuses on the active word
- Better user experience
- Easier vocabulary tracking

---

### 7. Active Word Highlighting

The currently spoken vocabulary item is highlighted dynamically.

**Visual Indicators:**
- Different background color
- Highlighted border
- Active speaker icon
- Shadow effects

This helps users identify the word currently being pronounced.

---

### 8. Playback Controls

Implemented playback management through the application toolbar.

#### Play All

Starts sequential playback of all vocabulary items.

#### Stop

Stops the current playback immediately and resets the state.

```dart
IconButton(
  icon: Icon(
    _isPlayingSequence
        ? Icons.stop
        : Icons.play_arrow,
  ),
)
```

---

## Current Vocabulary Dataset

The application currently contains sample Japanese vocabulary, including:

- こんにちは (Hello)
- ありがとう (Thank You)
- さようなら (Goodbye)
- すみません (Excuse Me / Sorry)
- 水 (Water)
- 猫 (Cat)
- 犬 (Dog)
- 日本 (Japan)
- 桜 (Cherry Blossom)
- 頑張って (Do Your Best)

---

## Current Result

The application successfully provides:

✅ Japanese vocabulary display

✅ Kanji, Hiragana, Romaji, and English translation support

✅ Japanese Text-to-Speech pronunciation (`ja-JP`)

✅ Sequential vocabulary playback

✅ Manual vocabulary playback

✅ Automatic list scrolling

✅ Active word highlighting

✅ Play and Stop controls

✅ Speech completion handling

---

## Planned Enhancements

### Continuous Loop Playback

Automatically restart playback after reaching the last vocabulary item.

```dart
while (_isPlayingSequence) {
  for (int i = 0; i < _words.length; i++) {
    await _speakWord(_words[i].kanji);
  }
}
```

### Additional Improvements

- Adjustable speech speed
- Loop mode toggle
- Random vocabulary playback
- N5/N4/N3 vocabulary categories
- Vocabulary search functionality
- Learning progress tracking
- CSV import support
- Supabase/PostgreSQL integration
- Vocabulary bookmarking and favorites

---

## Project Status

**Status:** Completed

The Japanese Vocabulary TTS Player is fully functional and supports vocabulary display, Japanese pronunciation, sequential playback, auto-scrolling, and user interaction controls. Future development will focus on continuous loop playback, vocabulary management, and database integration.