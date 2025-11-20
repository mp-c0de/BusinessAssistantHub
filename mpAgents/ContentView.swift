import SwiftUI
import Combine

struct Assistant {
    let name: String
    let description: String
    let systemPrompt: String
}

let assistants: [Assistant] = [
    Assistant(name: "Buddy", description: "Verslo plėtros vadovas", systemPrompt: "Jūs esate Buddy, verslo plėtros vadovas. Kurkite augimo strategijas, teikite verslo įžvalgas, puikiai išmanote AI rinkodarai, produktų pristatymams, auditorijos analizei. Būkite profesionalus ir įžvalgus. Atsakykite lietuvių kalba."),
    Assistant(name: "Cassie", description: "Klientų aptarnavimo specialistas", systemPrompt: "Jūs esate Cassie, klientų aptarnavimo specialistas. Kurkite pritaikytus atsakymus į klientų užklausas, išlaikydami prekės ženklo unikalų balsą. Būkite empatiškas ir naudingas. Atsakykite lietuvių kalba."),
    Assistant(name: "Commet", description: "Elektroninės komercijos vadovas", systemPrompt: "Jūs esate Commet, elektroninės komercijos vadovas. Vadovaukite per internetinės parduotuvės nustatymą, produktų pristatymus ir optimizuokite verslo procesus. Būkite praktiškas ir efektyvus. Atsakykite lietuvių kalba."),
    Assistant(name: "Dexter", description: "Duomenų analitikas", systemPrompt: "Jūs esate Dexter, duomenų analitikas. Paverskite sudėtingus duomenis skaičiavimais, prognozėmis ir veiksmingomis verslo įžvalgomis. Būkite analitiškas ir tikslus. Atsakykite lietuvių kalba."),
    Assistant(name: "Emmie", description: "El. pašto rinkodaros specialistas", systemPrompt: "Jūs esate Emmie, el. pašto rinkodaros specialistas. Kurkite patrauklius el. laiškus ir generuokite atgavimo srautus, kad prenumeratorių sąrašai taptų pajamomis. Būkite kūrybiškas ir įtikinamas. Atsakykite lietuvių kalba."),
    Assistant(name: "Gigi", description: "Asmeninio augimo treneris", systemPrompt: "Jūs esate Gigi, asmeninio augimo treneris. Palaikykite produktyvumą su maitinimo planavimu, mokymosi sesijomis ir treniruočių rutinomis. Būkite motyvuojantis ir palaikantis. Atsakykite lietuvių kalba."),
    Assistant(name: "Penn", description: "Tekstų kūrėjas", systemPrompt: "Jūs esate Penn, tekstų kūrėjas. Rašykite patrauklius tekstus reklamoms, tinklaraščio įrašams, svetainėms, reklaminiams straipsniams ir rinkodaros kampanijoms. Būkite kūrybiškas ir patrauklus. Atsakykite lietuvių kalba."),
    Assistant(name: "Scouty", description: "Darbuotojų atrankos specialistas", systemPrompt: "Jūs esate Scouty, darbuotojų atrankos specialistas. Kurkite darbo skelbimus, vadovaukite komandos įvedimui ir tvarkykite su atranka susijusius klausimus. Būkite profesionalus ir strateginis. Atsakykite lietuvių kalba."),
    Assistant(name: "Seomi", description: "SEO specialistas", systemPrompt: "Jūs esate Seomi, SEO specialistas. Teikite SEO strategijas, SEO optimizuotus tinklaraščio įrašus ir AI pagrindu veikiančius sprendimus, kad pagerintumėte svetainės reitingus. Būkite ekspertas ir duomenimis pagrįstas. Atsakykite lietuvių kalba."),
    Assistant(name: "Soshie", description: "Socialinių tinklų vadovas", systemPrompt: "Jūs esate Soshie, socialinių tinklų vadovas. Generuokite turinį, planuokite strategijas, planuokite įrašus ir raskite tendencijas naudojant verslo automatizavimo įrankius. Būkite madingas ir kūrybiškas. Atsakykite lietuvių kalba."),
    Assistant(name: "Vizzy", description: "Virtualus asistentas", systemPrompt: "Jūs esate Vizzy, virtualus asistentas. Tvarkykite kalendorius, planuokite susitikimus, planuokite keliones ir atsakykite į kasdienius iššūkių klausimus. Būkite organizuotas ir naudingas. Atsakykite lietuvių kalba."),
    Assistant(name: "Milli", description: "Pardavimų vadovas", systemPrompt: "Jūs esate Milli, pardavimų vadovas. Kurkite šaltų skambučių scenarijus, kurkite šaltus el. laiškus ir kurkite pristatymus, kad uždarytumėte sandorius. Būkite įtikinamas ir profesionalus. Atsakykite lietuvių kalba.")
]

// Token Counter Manager
class TokenCounterManager: ObservableObject {
    @Published var tokensUsedToday: Int = 0
    @Published var requestsToday: Int = 0

    private let dailyTokenLimit = 1_000_000
    private let dailyRequestLimit = 1_500

    init() {
        loadTokenData()
        checkAndResetIfNewDay()
    }

    func addTokens(_ count: Int) {
        tokensUsedToday += count
        saveTokenData()
    }

    func incrementRequest() {
        requestsToday += 1
        saveTokenData()
    }

    var tokenPercentage: Double {
        return Double(tokensUsedToday) / Double(dailyTokenLimit)
    }

    var requestPercentage: Double {
        return Double(requestsToday) / Double(dailyRequestLimit)
    }

    var isNearLimit: Bool {
        return tokenPercentage > 0.8 || requestPercentage > 0.8
    }

    private func saveTokenData() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        UserDefaults.standard.set(tokensUsedToday, forKey: "tokensUsedToday")
        UserDefaults.standard.set(requestsToday, forKey: "requestsToday")
        UserDefaults.standard.set(today, forKey: "lastResetDate")
    }

    private func loadTokenData() {
        tokensUsedToday = UserDefaults.standard.integer(forKey: "tokensUsedToday")
        requestsToday = UserDefaults.standard.integer(forKey: "requestsToday")
    }

    private func checkAndResetIfNewDay() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        if let lastResetDate = UserDefaults.standard.object(forKey: "lastResetDate") as? Date {
            if !calendar.isDate(lastResetDate, inSameDayAs: today) {
                tokensUsedToday = 0
                requestsToday = 0
                saveTokenData()
            }
        } else {
            saveTokenData()
        }
    }
}

// Chat History Manager
class ChatHistoryManager: ObservableObject {
    @Published private var chatHistories: [String: [ChatMessage]] = [:]

    init() {
        loadChatHistories()
    }

    func getChatHistory(for assistantName: String) -> [ChatMessage] {
        return chatHistories[assistantName] ?? []
    }

    func addMessage(_ message: ChatMessage, for assistantName: String) {
        if chatHistories[assistantName] == nil {
            chatHistories[assistantName] = []
        }
        chatHistories[assistantName]?.append(message)
        saveChatHistories()
    }

    func setChatHistory(_ messages: [ChatMessage], for assistantName: String) {
        chatHistories[assistantName] = messages
        saveChatHistories()
    }

    func clearHistory(for assistantName: String) {
        chatHistories[assistantName] = []
        saveChatHistories()
    }

    private func saveChatHistories() {
        do {
            let data = try JSONEncoder().encode(chatHistories)
            UserDefaults.standard.set(data, forKey: "chatHistories")
        } catch {
            // Silent error handling
        }
    }

    private func loadChatHistories() {
        guard let data = UserDefaults.standard.data(forKey: "chatHistories") else { return }
        do {
            chatHistories = try JSONDecoder().decode([String: [ChatMessage]].self, from: data)
        } catch {
            // Silent error handling
        }
    }
}

struct ContentView: View {
    @StateObject private var chatHistoryManager = ChatHistoryManager()
    @StateObject private var tokenCounterManager = TokenCounterManager()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Token Counter Header
                TokenCounterView(tokenCounterManager: tokenCounterManager)

                List(assistants, id: \.name) { assistant in
                    NavigationLink(destination: ChatView(assistant: assistant, chatHistoryManager: chatHistoryManager, tokenCounterManager: tokenCounterManager)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(assistant.name)
                                .font(.headline)
                                .foregroundColor(.blue)
                            Text(assistant.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        let messageCount = chatHistoryManager.getChatHistory(for: assistant.name).count
                        if messageCount > 0 {
                            Text("\(messageCount / 2)")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                    }
                }
            }
            .navigationTitle("Pasirinkite Asistentą")
            .listStyle(.plain)
            }
        }
    }
}

// Token Counter View
struct TokenCounterView: View {
    @ObservedObject var tokenCounterManager: TokenCounterManager

    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .font(.caption)
                    .foregroundColor(tokenCounterManager.isNearLimit ? .orange : .blue)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Tokens: \(formatNumber(tokenCounterManager.tokensUsedToday))/1M")
                        .font(.caption)
                        .fontWeight(.medium)

                    Text("Requests: \(tokenCounterManager.requestsToday)/1,500")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Text("\(Int(tokenCounterManager.tokenPercentage * 100))%")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(tokenCounterManager.isNearLimit ? .orange : .blue)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 4)

                    Rectangle()
                        .fill(tokenCounterManager.isNearLimit ? Color.orange : Color.blue)
                        .frame(width: geometry.size.width * CGFloat(tokenCounterManager.tokenPercentage), height: 4)
                }
            }
            .frame(height: 4)
            .padding(.horizontal)
        }
        .background(Color(UIColor.systemBackground))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 2)
    }

    private func formatNumber(_ number: Int) -> String {
        if number >= 1000 {
            return String(format: "%.1fk", Double(number) / 1000.0)
        }
        return "\(number)"
    }
}

// Chat message model
struct ChatMessage: Identifiable, Codable {
    var id: UUID = UUID()  // Changed to 'var' to fix the decoding warning
    let text: String
    let isUser: Bool
    let timestamp: Date
    
    init(text: String, isUser: Bool) {
        self.id = UUID()
        self.text = text
        self.isUser = isUser
        self.timestamp = Date()
    }
}

struct ChatView: View {
    let assistant: Assistant
    @ObservedObject var chatHistoryManager: ChatHistoryManager
    @ObservedObject var tokenCounterManager: TokenCounterManager
    @State private var userMessage: String = ""
    @State private var chatHistory: [ChatMessage] = []
    @State private var isLoading: Bool = false
    @State private var isTyping: Bool = false
    @State private var currentTypedText: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
    let responseSpeed = 1 // 1 (fastest) ... 10 (slowest)

    // Replace with your Google Gemini API key from https://makersuite.google.com/app/apikey
    let apiKey = "YOUR_GEMINI_API_KEY"
    let apiUrl = URL(string: "https://generativelanguage.googleapis.com/v1/models/gemini-2.0-flash-lite:streamGenerateContent")!
    
    var body: some View {
        VStack(spacing: 0) {
            // Chat history
            ScrollViewReader { scrollProxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(chatHistory) { message in
                            ChatBubble(message: message)
                                .id(message.id)
                        }
                        
                        // Show typing animation while AI is typing
                        if isTyping && !currentTypedText.isEmpty {
                            ChatBubble(message: ChatMessage(text: currentTypedText + "●", isUser: false))
                                .id("typing")
                        }
                        
                        if isLoading {
                            HStack {
                                ProgressView()
                                    .scaleEffect(0.8)
                                Text("Galvoja...")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)
                            .id("loading")
                        }
                    }
                    .padding()
                }
                .onChange(of: chatHistory.count) { _, _ in  // Fixed for iOS 17
                    withAnimation {
                        if let lastMessage = chatHistory.last {
                            scrollProxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: isLoading) { _, newValue in  // Fixed for iOS 17
                    if newValue {
                        withAnimation {
                            scrollProxy.scrollTo("loading", anchor: .bottom)
                        }
                    }
                }
                .onChange(of: currentTypedText) { _, _ in  // Fixed for iOS 17
                    if isTyping {
                        withAnimation {
                            scrollProxy.scrollTo("typing", anchor: .bottom)
                        }
                    }
                }
            }
            
            // Input area
            HStack(spacing: 12) {
                TextField("Įveskite savo užklausą", text: $userMessage, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(1...4)
                    .focused($isTextFieldFocused)
                    .onSubmit {
                        if !userMessage.isEmpty {
                            sendMessage()
                        }
                    }
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(userMessage.isEmpty || isLoading || isTyping ? Color.gray : Color.blue)
                        .clipShape(Circle())
                }
                .disabled(userMessage.isEmpty || isLoading || isTyping)
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .shadow(color: .black.opacity(0.1), radius: 2, y: -2)
        }
        .navigationTitle(assistant.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.blue.opacity(0.1), for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Išvalyti pokalbį", role: .destructive) {
                        clearChat()
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .onAppear {
            loadChatHistory()
        }
    }
    
    private func loadChatHistory() {
        chatHistory = chatHistoryManager.getChatHistory(for: assistant.name)
    }
    
    private func clearChat() {
        chatHistory = []
        chatHistoryManager.clearHistory(for: assistant.name)
    }
    
    private func sendMessage() {
        let messageToSend = userMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !messageToSend.isEmpty else { return }
        
        // Add user message to history
        let userChatMessage = ChatMessage(text: messageToSend, isUser: true)
        chatHistory.append(userChatMessage)
        chatHistoryManager.addMessage(userChatMessage, for: assistant.name)
        
        // Clear input field and hide keyboard
        userMessage = ""
        isTextFieldFocused = false
        
        // Start loading
        isLoading = true
        
        Task {
            await performAPICall(with: messageToSend)
        }
    }
    
    @MainActor
    private func performAPICall(with message: String) async {
        do {
            // Combine system prompt with user message for Gemini v1
            let combinedMessage = "\(assistant.systemPrompt)\n\nUser: \(message)"

            // Create user message content
            let userContent = GeminiRequest.GeminiContent(
                parts: [GeminiRequest.GeminiContent.Part(text: combinedMessage)],
                role: "user"
            )

            let requestBody = GeminiRequest(
                contents: [userContent],
                systemInstruction: nil,
                generationConfig: GeminiRequest.GenerationConfig(maxOutputTokens: 2048)
            )

            let data = try JSONEncoder().encode(requestBody)

            // Build URL with API key as query parameter
            let urlString = "https://generativelanguage.googleapis.com/v1/models/gemini-2.0-flash-lite:streamGenerateContent?key=\(apiKey)&alt=sse"

            print("🔍 DEBUG - URL: \(urlString)")

            // Print request body for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("🔍 DEBUG - Request Body: \(jsonString)")
            }

            guard let url = URL(string: urlString) else {
                throw NSError(domain: "Invalid URL", code: 0)
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data

            let (bytes, response) = try await URLSession.shared.bytes(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NSError(domain: "No HTTP response", code: 0)
            }

            print("🔍 DEBUG - Status Code: \(httpResponse.statusCode)")

            if httpResponse.statusCode != 200 {
                var errorBody = ""
                for try await line in bytes.lines {
                    errorBody += line + "\n"
                }

                print("🔍 DEBUG - Error Body: \(errorBody)")

                if let errorData = errorBody.data(using: .utf8) {
                    do {
                        let errorJson = try JSONDecoder().decode(GeminiError.self, from: errorData)
                        let errorMessage = ChatMessage(text: "API Error: \(errorJson.message)", isUser: false)
                        chatHistory.append(errorMessage)
                        chatHistoryManager.addMessage(errorMessage, for: assistant.name)
                    } catch {
                        let errorMessage = ChatMessage(text: "HTTP Error: \(httpResponse.statusCode)\n\(errorBody)", isUser: false)
                        chatHistory.append(errorMessage)
                        chatHistoryManager.addMessage(errorMessage, for: assistant.name)
                    }
                } else {
                    let errorMessage = ChatMessage(text: "HTTP Error: \(httpResponse.statusCode)", isUser: false)
                    chatHistory.append(errorMessage)
                    chatHistoryManager.addMessage(errorMessage, for: assistant.name)
                }
                isLoading = false
                return
            }

            var fullResponse = ""
            var totalTokens = 0

            // Increment request counter
            tokenCounterManager.incrementRequest()

            // Collect full response from Gemini's streaming format
            for try await line in bytes.lines {
                if line.hasPrefix("data: ") {
                    let jsonString = String(line.dropFirst(6))

                    if jsonString.trimmingCharacters(in: .whitespaces).isEmpty {
                        continue
                    }

                    if let jsonData = jsonString.data(using: .utf8) {
                        do {
                            let streamResponse = try JSONDecoder().decode(GeminiStreamResponse.self, from: jsonData)

                            if let error = streamResponse.error {
                                let errorMessage = ChatMessage(text: "API Error: \(error.message)", isUser: false)
                                chatHistory.append(errorMessage)
                                chatHistoryManager.addMessage(errorMessage, for: assistant.name)
                                isLoading = false
                                return
                            }

                            // Extract token usage
                            if let usageMetadata = streamResponse.usageMetadata,
                               let tokenCount = usageMetadata.totalTokenCount {
                                totalTokens = tokenCount
                            }

                            if let candidates = streamResponse.candidates,
                               let firstCandidate = candidates.first,
                               let content = firstCandidate.content,
                               let parts = content.parts {
                                for part in parts {
                                    if let text = part.text {
                                        fullResponse += text
                                    }
                                }
                            }
                        } catch {
                            // Silent error handling for malformed JSON chunks
                        }
                    }
                }
            }

            // Add tokens to counter
            if totalTokens > 0 {
                tokenCounterManager.addTokens(totalTokens)
                print("🔍 DEBUG - Tokens used: \(totalTokens)")
            }

            isLoading = false

            if !fullResponse.isEmpty {
                await typeResponseNaturally(fullResponse)
            } else {
                let errorMessage = ChatMessage(text: "Nepavyko gauti atsakymo. Bandykite dar kartą.", isUser: false)
                chatHistory.append(errorMessage)
                chatHistoryManager.addMessage(errorMessage, for: assistant.name)
            }

        } catch URLError.networkConnectionLost {
            let errorMessage = ChatMessage(text: "Klaida: Prarastas interneto ryšys", isUser: false)
            chatHistory.append(errorMessage)
            chatHistoryManager.addMessage(errorMessage, for: assistant.name)
        } catch URLError.notConnectedToInternet {
            let errorMessage = ChatMessage(text: "Klaida: Nėra interneto ryšio", isUser: false)
            chatHistory.append(errorMessage)
            chatHistoryManager.addMessage(errorMessage, for: assistant.name)
        } catch {
            let errorMessage = ChatMessage(text: "Klaida: \(error.localizedDescription)", isUser: false)
            chatHistory.append(errorMessage)
            chatHistoryManager.addMessage(errorMessage, for: assistant.name)
        }

        isLoading = false
    }
    
    @MainActor
    private func typeResponseNaturally(_ response: String) async {
        isTyping = true
        currentTypedText = ""
        
        let baseDelay = 0.03 + Double(responseSpeed - 1) * 0.07
        
        let words = response.components(separatedBy: " ")
        
        for (index, word) in words.enumerated() {
            // Add the word
            if index == 0 {
                currentTypedText = word
            } else {
                currentTypedText += " " + word
            }
            
            try? await Task.sleep(nanoseconds: UInt64(baseDelay * 1_000_000_000))
        }
        
        // Finish typing
        isTyping = false
        
        // Add the complete message to chat history
        let aiMessage = ChatMessage(text: response, isUser: false)
        chatHistory.append(aiMessage)
        chatHistoryManager.addMessage(aiMessage, for: assistant.name)
        
        // Clear the typing text
        currentTypedText = ""
    }
}

struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser { Spacer(minLength: 50) }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                HStack {
                    Text(message.isUser ? "Jūs" : "AI")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(timeString(from: message.timestamp))
                        .font(.caption2)
                        .foregroundColor(.gray.opacity(0.7))
                }
                
                Text(message.text)
                    .padding(12)
                    .background(message.isUser ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(message.isUser ? .white : .primary)
                    .cornerRadius(16)
            }
            
            if !message.isUser { Spacer(minLength: 50) }
        }
    }
    
    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// Gemini API Models
struct GeminiRequest: Encodable {
    let contents: [GeminiContent]
    let systemInstruction: SystemInstruction?
    let generationConfig: GenerationConfig?

    struct GeminiContent: Encodable {
        let parts: [Part]
        let role: String?

        struct Part: Encodable {
            let text: String
        }
    }

    struct SystemInstruction: Encodable {
        let parts: [GeminiContent.Part]
    }

    struct GenerationConfig: Encodable {
        let maxOutputTokens: Int

        enum CodingKeys: String, CodingKey {
            case maxOutputTokens
        }
    }
}

struct GeminiStreamResponse: Decodable {
    let candidates: [Candidate]?
    let error: GeminiError?
    let usageMetadata: UsageMetadata?

    struct Candidate: Decodable {
        let content: Content?

        struct Content: Decodable {
            let parts: [Part]?

            struct Part: Decodable {
                let text: String?
            }
        }
    }

    struct UsageMetadata: Decodable {
        let promptTokenCount: Int?
        let candidatesTokenCount: Int?
        let totalTokenCount: Int?
    }
}

struct GeminiError: Decodable {
    let code: Int?
    let message: String
    let status: String?
}

#Preview {
    ContentView()
}
