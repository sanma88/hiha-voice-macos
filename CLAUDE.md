# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

HiHaVoice is a native macOS (14.4+) SwiftUI application that transcribes speech to text using local AI models. It's built with Swift, uses SwiftData for persistence, and depends on whisper.cpp for local transcription. The project is GPL v3 licensed.

## Build Commands

```bash
make all          # Full build (check prerequisites + build whisper framework + build app)
make dev          # Build and run
make local        # Build without Apple Developer certificate (ad-hoc signed)
make build        # Build only (assumes whisper framework already built)
make clean        # Remove ~/HiHaVoice-Dependencies and build artifacts
make check        # Verify git, xcodebuild, swift are installed
```

The whisper.cpp XCFramework is built automatically and stored in `~/HiHaVoice-Dependencies/whisper.cpp/build-apple/whisper.xcframework`.

Local builds use `LocalBuild.xcconfig` and the `LOCAL_BUILD` Swift compilation flag, which disables iCloud/CloudKit features. Use `#if LOCAL_BUILD` for conditional code paths.

## Testing

```bash
xcodebuild test -project HiHaVoice.xcodeproj -scheme HiHaVoice -destination 'platform=macOS'
```

Tests are in `HiHaVoiceTests/` and `HiHaVoiceUITests/`.

## Architecture

### App Entry Point & Dependency Wiring

`HiHaVoice.swift` — The `@main` App struct. All top-level services are created here and passed down via `@EnvironmentObject`. The initialization order matters due to circular dependencies (e.g., `RecorderUIManager` ↔ `HiHaVoiceEngine`).

### Core Engine (`Whisper/`)

- **HiHaVoiceEngine** — Central orchestrator. Owns the `Recorder`, manages recording state, and coordinates the transcription pipeline. Injected with `WhisperModelManager`, `TranscriptionModelManager`, and `AIEnhancementService`.
- **TranscriptionPipeline** — Post-recording pipeline: transcribe → filter → format → word-replace → prompt-detect → AI enhance → save → paste → dismiss.
- **TranscriptionModelManager** — Unified manager over multiple model backends (Whisper, Parakeet). Handles model selection and availability.
- **WhisperModelManager** — Manages whisper.cpp model downloads, loading/unloading, and warmup.
- **ParakeetModelManager** — Manages Parakeet (FluidAudio) models.
- **RecorderUIManager** — Controls mini recorder panel visibility and state transitions.
- **LibWhisper** — Swift wrapper around the whisper.cpp C API.

### Transcription Services (`Services/`)

- **TranscriptionServiceRegistry** — Routes transcription requests to the correct service based on `ModelProvider` (local, parakeet, nativeApple, cloud).
- **LocalTranscriptionService** — Whisper.cpp-based local transcription.
- **ParakeetTranscriptionService** — FluidAudio-based local transcription.
- **CloudTranscriptionService** — Cloud providers (Groq, ElevenLabs, Deepgram, Mistral, Gemini, Soniox).
- **NativeAppleTranscriptionService** — Apple's built-in speech recognition.
- **StreamingTranscription/** — Real-time streaming providers (Deepgram, ElevenLabs, Mistral, Soniox, Parakeet).
- **TranscriptionSession** — Abstraction over streaming vs file-based transcription sessions.

### Model Types (`Models/TranscriptionModel.swift`)

The `TranscriptionModel` protocol unifies all model types. Concrete types: `LocalModel` (whisper.cpp downloadable), `ImportedLocalModel` (user-imported), `ParakeetModel`, `CloudModel`, `CustomCloudModel` (user-configured endpoint), `NativeAppleModel`. The `ModelProvider` enum distinguishes backends.

### AI Enhancement (`Services/AIEnhancement/`)

- **AIService** — Manages API keys and communicates with AI providers (OpenAI, Anthropic, Gemini, Groq, Ollama, DeepSeek, OpenRouter).
- **AIEnhancementService** — Post-transcription text enhancement using AI prompts. Integrates with Power Mode for context-aware enhancement.

### Power Mode (`PowerMode/`)

Context-aware mode that detects the active app/URL and automatically applies pre-configured transcription settings (model, prompts, enhancement). Key components: `ActiveWindowService`, `BrowserURLService`, `PowerModeSessionManager`, `PowerModeConfig`.

### Recording (`Recorder.swift`, `CoreAudioRecorder.swift`)

`Recorder` wraps `CoreAudioRecorder` (Core Audio-based). Handles audio device management, level metering, and streaming audio chunks. `MediaController`/`PlaybackController` manage media pause/resume during recording.

### Data Layer

- **SwiftData** models: `Transcription`, `VocabularyWord`, `WordReplacement`
- Two SwiftData stores: `default.store` (transcriptions) and `dictionary.store` (vocabulary/replacements, synced via CloudKit in non-local builds)
- **CustomVocabularyService** / **WordReplacementService** — Personal dictionary and text replacement
- **DictionaryMigrationService** — One-time migration from UserDefaults to SwiftData

### Key Patterns

- Services use `@MainActor` extensively since they interact with UI state.
- Logging uses `os.Logger` with subsystem `be.hiha.voice` and per-class categories.
- `UserDefaults` managed via `AppDefaults.registerDefaults()` and `@AppStorage`.
- The app runs as both a regular window and a menu bar extra (`MenuBarManager`).
- Keyboard shortcuts via the `KeyboardShortcuts` package, managed by `HotkeyManager`.
- Auto-updates via Sparkle (`SPUStandardUpdaterController`).

## Dependencies

- **whisper.cpp** — Core local transcription (XCFramework, built from source)
- **FluidAudio** — Parakeet model inference
- **Sparkle** — Auto-updates
- **KeyboardShortcuts** — Global hotkeys
- **LaunchAtLogin** — Login item
- **MediaRemoteAdapter** — Media playback control during recording
- **Zip** — File compression
- **SelectedTextKit** — macOS selected text retrieval
- **Swift Atomics** — Thread-safe atomic operations

## Contributing

The project is **not currently accepting pull requests**. Contributions are limited to bug reports and feature suggestions via GitHub issues.
