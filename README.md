# BusinessAssistantHub

An enterprise AI assistant platform featuring 12 specialized business experts powered by Google Gemini API, with Lithuanian language support, real-time streaming responses, and comprehensive usage tracking.

## Overview

BusinessAssistantHub is a sophisticated multi-AI assistant application that provides access to 12 domain-specific business experts, each powered by Google's Gemini 2.0 Flash Lite model. The app features real-time streaming responses, persistent chat history, token usage tracking, and a Lithuanian language interface, making it an ideal business productivity tool.

## Features

### 12 Specialized AI Assistants
1. **Business Development** - Market expansion and growth strategies
2. **Customer Service** - Client support and satisfaction
3. **E-commerce** - Online sales and digital commerce
4. **Data Analytics** - Business intelligence and insights
5. **Email Marketing** - Campaign management and automation
6. **Personal Growth** - Professional development coaching
7. **Copywriting** - Content creation and messaging
8. **Recruitment** - Talent acquisition and HR
9. **SEO** - Search engine optimization strategies
10. **Social Media** - Digital marketing and engagement
11. **Virtual Assistant** - General business support
12. **Sales** - Revenue generation and client acquisition

### Advanced Features
- **Streaming Responses**: Real-time typing animation as AI generates responses
- **Chat History**: Persistent conversation storage per assistant
- **Usage Tracking**: Real-time token and request counters
- **Daily Quotas**: 1M tokens/day, 1.5K requests/day monitoring
- **Automatic Reset**: Midnight quota reset
- **Progress Indicators**: Visual token usage bars
- **Lithuanian Interface**: Native language support

## Technical Stack

- **Framework**: SwiftUI
- **AI API**: Google Gemini 2.0 Flash Lite (gemini-2.0-flash-lite)
- **Networking**: URLSession with streaming
- **Reactive Programming**: Combine framework
- **iOS Version**: iOS 15+
- **Architecture**: ObservableObject pattern with specialized managers
- **Storage**: UserDefaults for chat history and quota tracking

## Key Learning Concepts

This project demonstrates:
- Streaming API integration with Server-Sent Events (SSE)
- Multi-assistant architecture with shared infrastructure
- Token usage tracking and quota management
- Persistent chat history per context
- Combine for reactive data flow
- Advanced URLSession streaming techniques
- State management across multiple views

## Project Structure

```
BusinessAssistantHub/
├── Models/
│   ├── Assistant.swift              # Assistant definitions
│   ├── Message.swift                # Chat message model
│   └── ChatHistory.swift            # Conversation storage
├── Managers/
│   ├── ChatHistoryManager.swift     # Persistent chat storage
│   └── TokenCounterManager.swift    # Usage tracking
├── Services/
│   └── GeminiService.swift          # API integration
├── Views/
│   ├── AssistantListView.swift      # Main assistant selector
│   ├── ChatView.swift               # Conversation interface
│   └── UsageStatsView.swift         # Token/request tracking
└── BusinessAssistantHubApp.swift
```

## API Integration

### Google Gemini API
```swift
// Model: gemini-2.0-flash-lite
// Streaming: Server-Sent Events (SSE)
// Rate Limits: 1M tokens/day, 1.5K requests/day
```

### Streaming Implementation
```swift
func streamResponse(prompt: String, assistant: String) -> AsyncStream<String> {
    AsyncStream { continuation in
        // URLSession streaming
        // Parse SSE chunks
        // Extract text deltas
        // Update UI in real-time
    }
}
```

## Code Highlights

### Chat History Manager
```swift
class ChatHistoryManager: ObservableObject {
    @Published var histories: [String: [Message]] = [:]

    func saveMessage(assistant: String, message: Message) {
        // Persist to UserDefaults
        // Update published histories
    }
}
```

### Token Counter Manager
```swift
class TokenCounterManager: ObservableObject {
    @Published var tokensUsed: Int = 0
    @Published var requestsUsed: Int = 0
    let tokenLimit = 1_000_000  // 1M per day
    let requestLimit = 1500     // 1.5K per day

    func checkMidnightReset() {
        // Automatic daily reset logic
    }
}
```

### Streaming UI Updates
Real-time text rendering with typing animation as tokens arrive from API.

## Skills Demonstrated

- Advanced API integration with streaming
- Multi-context state management
- Persistent storage strategies
- Quota and rate limiting
- Combine reactive programming
- Async/await patterns
- Server-Sent Events parsing
- Lithuanian localization
- Professional UI/UX for chat interfaces

## Usage Tracking

### Daily Quotas
- **Tokens**: 1,000,000 per day
- **Requests**: 1,500 per day
- **Reset**: Automatic at midnight
- **Display**: Real-time progress bars

### Token Counting
Tracks both input and output tokens for accurate quota management.

## Use Cases

- Business consulting automation
- Multi-domain expert system
- Enterprise productivity tool
- AI-powered business intelligence
- Professional coaching platform
- Marketing automation assistant

## Localization

- **Primary Language**: Lithuanian
- **UI Elements**: Lithuanian labels and prompts
- **Assistant Responses**: Configurable per assistant

## Future Enhancements

- Export chat history to PDF
- Voice input/output integration
- Multi-language support expansion
- Custom assistant training
- Team collaboration features
- Analytics dashboard for assistant usage
- Cost tracking and billing integration
- Offline mode with cached responses
- Image analysis capabilities (Gemini Vision)
- Document upload and analysis

## Setup Instructions

1. Obtain Google Gemini API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Replace API key in `GeminiService.swift`
3. Build and run

## API Costs

- **Model**: Gemini 2.0 Flash Lite
- **Pricing**: Free tier available
- **Quotas**: Check Google AI Studio for current limits

---

**Author**: Martynas Prascevicius
**Contact**: mpcode@icloud.com
**Purpose**: Advanced AI integration demonstrating enterprise assistant platform
