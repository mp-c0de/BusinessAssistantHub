# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

mpAgents is an iOS SwiftUI application that provides access to multiple AI assistants, each specialized for different business tasks. The app uses the Google Gemini API (gemini-2.0-flash-lite model) for real-time chat interactions with streaming responses and typing animations. The UI is in Lithuanian language.

## Architecture

### Core Components

- **mpAgentsApp.swift** - Main app entry point
- **ContentView.swift** - Single-file architecture containing all models, views, and business logic:
  - `Assistant` model - Defines each AI assistant with name, description, and system prompt
  - `ChatMessage` model - Codable message structure for persistence
  - `TokenCounterManager` - ObservableObject tracking daily token and request usage with automatic midnight reset
  - `ChatHistoryManager` - ObservableObject managing chat histories per assistant using UserDefaults
  - `ContentView` - Navigation list of available assistants with message count badges and token counter header
  - `TokenCounterView` - Always-visible header displaying token/request usage with progress bar
  - `ChatView` - Main chat interface with streaming API integration
  - `ChatBubble` - Individual message display component
  - API models: `GeminiRequest`, `GeminiStreamResponse`, `GeminiError`

### AI Assistants

The app includes 12 specialized assistants (defined in the `assistants` array):
- Buddy (Business Development)
- Cassie (Customer Service)
- Commet (E-commerce)
- Dexter (Data Analytics)
- Emmie (Email Marketing)
- Gigi (Personal Growth)
- Penn (Copywriting)
- Scouty (Recruitment)
- Seomi (SEO)
- Soshie (Social Media)
- Vizzy (Virtual Assistant)
- Milli (Sales)

Each assistant has a unique system prompt in Lithuanian that defines its personality and expertise.

### Key Features

1. **Token Usage Tracking** - Real-time monitoring of daily API quota with automatic midnight reset
   - Displays tokens used / 1M daily limit
   - Shows requests made / 1,500 daily limit
   - Visual progress bar with warning colors at 80% usage
   - Persistent storage across app sessions
2. **Chat Persistence** - Chat histories are stored per assistant in UserDefaults using JSON encoding
3. **Streaming Responses** - API responses are streamed and displayed with a typing animation (configurable speed via `responseSpeed` variable)
4. **Natural Typing Effect** - Words appear progressively with configurable delay
5. **Error Handling** - Network errors, API errors, and HTTP errors are handled with user-friendly Lithuanian messages
6. **Auto-scrolling** - Chat view automatically scrolls to latest message

## Development Commands

### Building and Running

```bash
# Open project in Xcode
open mpAgents.xcodeproj

# Build from command line
xcodebuild -project mpAgents.xcodeproj -scheme mpAgents -configuration Debug

# Run on simulator
xcodebuild -project mpAgents.xcodeproj -scheme mpAgents -destination 'platform=iOS Simulator,name=iPhone 15' -configuration Debug
```

### Testing

Currently no test suite is configured.

## Important Implementation Details

### API Integration

- **API Key Location**: Hardcoded in `ChatView.swift:140` (apiKey constant) - Get your free key from https://makersuite.google.com/app/apikey
- **API Endpoint**: Google Generative Language API v1 (`https://generativelanguage.googleapis.com/v1/models/gemini-2.0-flash-lite:streamGenerateContent`)
- **Model**: gemini-2.0-flash-lite (free tier)
- **Max Output Tokens**: 2048
- **Authentication**: API key passed as URL query parameter (`?key=API_KEY&alt=sse`)
- **Streaming**: Enabled via SSE (Server-Sent Events) with `alt=sse` parameter
- **System Prompts**: Combined with user message since v1 doesn't support separate systemInstruction field
- **Token Tracking**: API responses include `usageMetadata` with token counts for quota monitoring

### Typing Animation

The typing effect collects the full streaming response first, then displays it word-by-word at a configurable speed:
- `responseSpeed` variable (line 137): 1 (fastest) to 10 (slowest)
- Base delay calculation: `0.03 + Double(responseSpeed - 1) * 0.07` seconds per word
- Typing indicator shown with "●" character appended to current text

### Data Persistence

- **Chat Histories**: Stored in UserDefaults under key "chatHistories"
  - Structure: `[String: [ChatMessage]]` where key is assistant name
  - Messages include: UUID, text, isUser flag, timestamp
  - Automatic save after each message addition
- **Token Usage**: Stored in UserDefaults with daily tracking
  - `tokensUsedToday`: Current day's token count
  - `requestsToday`: Current day's request count
  - `lastResetDate`: Date of last midnight reset
  - Automatic reset when new day is detected

### UI Language

All user-facing text is in Lithuanian:
- "Pasirinkite Asistentą" (Choose Assistant)
- "Galvoja..." (Thinking...)
- "Įveskite savo užklausą" (Enter your request)
- "Išvalyti pokalbį" (Clear conversation)
- Error messages in Lithuanian

## Code Style Notes

- Uses SwiftUI lifecycle
- iOS 17+ features (onChange with old/new value parameters)
- Async/await for API calls with @MainActor annotations
- ObservableObject pattern for state management
- FocusState for keyboard management
- Silent error handling in persistence layer (catch blocks without user notification)

## Security Considerations

**WARNING**: The Google Gemini API key is hardcoded in the source code. For production deployment:
1. Move API key to secure configuration (e.g., environment variables, keychain, or backend proxy)
2. Never commit API keys to version control
3. Consider using a backend service to proxy API requests
4. Note: Gemini free tier has rate limits (15 requests per minute, 1 million tokens per day, 1500 per minute)

---

Made by mpcode (mpcode@icloud.com)
