import SwiftUI
import LLMkit

struct APIKeyManagementView: View {
    @EnvironmentObject private var aiService: AIService
    @State private var apiKey: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isVerifying = false
    @State private var ollamaBaseURL: String = UserDefaults.standard.string(forKey: "ollamaBaseURL") ?? "http://localhost:11434"
    @State private var ollamaModels: [OllamaModel] = []
    @State private var selectedOllamaModel: String = UserDefaults.standard.string(forKey: "ollamaSelectedModel") ?? "mistral"
    @State private var isCheckingOllama = false
    @State private var isEditingURL = false
    @State private var localCLICommandTemplate: String = ""
    @State private var localCLITimeoutSeconds: Double = LocalCLIService.defaultTimeoutSeconds
    @State private var isSyncingLocalCLIState = false
    
    var body: some View {
        Section("Intégration IA") {
            HStack {
                Picker("Fournisseur", selection: $aiService.selectedProvider) {
                    ForEach(AIProvider.allCases.filter { $0 != .elevenLabs && $0 != .deepgram && $0 != .soniox && $0 != .speechmatics }, id: \.self) { provider in
                        Text(provider.rawValue).tag(provider)
                    }
                }
                .pickerStyle(.automatic)
                .tint(.blue)
                
                if aiService.isAPIKeyValid && aiService.selectedProvider != .ollama {
                    Spacer()
                    Circle()
                        .fill(Color.HiHa.auroraCyan)
                        .frame(width: 8, height: 8)
                    Text("Connecté")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else if aiService.selectedProvider == .ollama {
                    Spacer()
                    if isCheckingOllama {
                        ProgressView()
                            .controlSize(.small)
                    } else if !ollamaModels.isEmpty {
                        Circle()
                            .fill(Color.HiHa.auroraCyan)
                            .frame(width: 8, height: 8)
                        Text("Connecté")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        Circle()
                            .fill(Color.HiHa.signalCoral)
                            .frame(width: 8, height: 8)
                        Text("Déconnecté")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .onChange(of: aiService.selectedProvider) { oldValue, newValue in
                if aiService.selectedProvider == .ollama {
                    checkOllamaConnection()
                }
                if aiService.selectedProvider == .localCLI {
                    syncLocalCLIStateFromService()
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                // Model Selection
                if aiService.selectedProvider == .openRouter {
                    if aiService.availableModels.isEmpty {
                        HStack {
                            Text("Aucun modèle chargé")
                                .foregroundColor(.secondary)
                            Spacer()
                            Button(action: {
                                Task {
                                    await aiService.fetchOpenRouterModels()
                                }
                            }) {
                                Label("Rafraîchir", systemImage: "arrow.clockwise")
                            }
                        }
                    } else {
                        HStack {
                            Picker("Modèle", selection: Binding(
                                get: { aiService.currentModel },
                                set: { aiService.selectModel($0) }
                            )) {
                                ForEach(aiService.availableModels, id: \.self) { model in
                                    Text(model).tag(model)
                                }
                            }

                            Spacer()

                            Button(action: {
                                Task {
                                    await aiService.fetchOpenRouterModels()
                                }
                            }) {
                                Label("Rafraîchir", systemImage: "arrow.clockwise")
                            }
                        }
                    }
                    
                } else if !aiService.availableModels.isEmpty &&
                            aiService.selectedProvider != .ollama &&
                            aiService.selectedProvider != .custom {
                    Picker("Modèle", selection: Binding(
                        get: { aiService.currentModel },
                        set: { aiService.selectModel($0) }
                    )) {
                        ForEach(aiService.availableModels, id: \.self) { model in
                            Text(model).tag(model)
                        }
                    }
                }

                if aiService.selectedProvider == .ollama {
                    if isEditingURL {
                        HStack {
                            TextField("URL de base", text: $ollamaBaseURL)
                                .textFieldStyle(.roundedBorder)
                            
                            Button("Enregistrer") {
                                aiService.updateOllamaBaseURL(ollamaBaseURL)
                                checkOllamaConnection()
                                isEditingURL = false
                            }
                        }
                    } else {
                        HStack {
                            Text("Serveur : \(ollamaBaseURL)")
                            Spacer()
                            Button("Modifier") { isEditingURL = true }
                            Button(action: {
                                ollamaBaseURL = "http://localhost:11434"
                                aiService.updateOllamaBaseURL(ollamaBaseURL)
                                checkOllamaConnection()
                            }) {
                                Image(systemName: "arrow.counterclockwise")
                            }
                            .help("Rétablir par défaut")
                        }
                    }

                    if !ollamaModels.isEmpty {
                        Divider()

                        Picker("Modèle", selection: $selectedOllamaModel) {
                            ForEach(ollamaModels) { model in
                                Text(model.name).tag(model.name)
                            }
                        }
                        .onChange(of: selectedOllamaModel) { oldValue, newValue in
                            aiService.updateSelectedOllamaModel(newValue)
                        }
                    }

                } else if aiService.selectedProvider == .localCLI {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Commande")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Menu("Charger un modèle") {
                                ForEach(LocalCLITemplate.allCases) { template in
                                    Button(template.displayName) {
                                        aiService.loadLocalCLITemplate(template)
                                        syncLocalCLIStateFromService()
                                    }
                                }
                            }
                        }

                        TextEditor(text: $localCLICommandTemplate)
                            .font(.system(.body, design: .monospaced))
                            .multilineTextAlignment(.leading)
                            .frame(minHeight: 100)
                            .padding(4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(NSColor.textBackgroundColor))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.secondary.opacity(0.25), lineWidth: 1)
                            )
                            .onChange(of: localCLICommandTemplate) { _, newValue in
                                guard !isSyncingLocalCLIState else { return }
                                if newValue != aiService.localCLICommandTemplate {
                                    aiService.updateLocalCLICommandTemplate(newValue)
                                }
                            }
                    }

                    Picker("Timeout", selection: $localCLITimeoutSeconds) {
                        Text("15s").tag(15.0)
                        Text("30s").tag(30.0)
                        Text("45s").tag(45.0)
                        Text("60s").tag(60.0)
                        Text("90s").tag(90.0)
                        Text("120s").tag(120.0)
                        Text("180s").tag(180.0)
                        Text("300s").tag(300.0)
                    }
                    .onChange(of: localCLITimeoutSeconds) { _, newValue in
                        aiService.updateLocalCLITimeoutSeconds(newValue)
                    }

                    Text("Variables d'environnement disponibles : HIHA_SYSTEM_PROMPT, HIHA_USER_PROMPT, HIHA_FULL_PROMPT. Hi-Ha Voice écrit aussi HIHA_FULL_PROMPT dans stdin pour chaque commande.")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    if !aiService.isAPIKeyValid {
                        Text("Charge un template ou entre une commande pour activer l'amélioration CLI locale.")
                            .font(.caption)
                            .foregroundColor(Color.HiHa.electricViolet)
                    }

                } else if aiService.selectedProvider == .custom {
                    TextField("URL du point d'accès API", text: $aiService.customBaseURL, prompt: Text("ex. https://vllm.sanfilippo.be/v1/chat/completions"))
                        .textFieldStyle(.roundedBorder)
                        .disableAutocorrection(true)
                        .autocorrectionDisabled(true)

                    Text("⚠️ L'URL doit inclure le chemin complet `/chat/completions` (endpoint OpenAI-compatible).")
                        .font(.caption)
                        .foregroundColor(Color.HiHa.mutedForeground)

                    Divider()

                    TextField("Nom du modèle", text: $aiService.customModel, prompt: Text("ex. gemini-3.1-pro-preview, gpt-oss-120b"))
                        .textFieldStyle(.roundedBorder)
                        .disableAutocorrection(true)
                        .autocorrectionDisabled(true)

                    Divider()

                    if aiService.isAPIKeyValid {
                        HStack {
                            Text("Clé API définie")
                            Spacer()
                            Button("Retirer la clé", role: .destructive) {
                                aiService.clearAPIKey()
                            }
                        }
                    } else {
                        SecureField("Clé API", text: $apiKey)
                            .textFieldStyle(.roundedBorder)

                        Button("Vérifier et enregistrer") {
                            isVerifying = true
                            aiService.saveAPIKey(apiKey) { success, errorMessage in
                                isVerifying = false
                                if !success {
                                    alertMessage = errorMessage ?? "Échec de la vérification"
                                    showAlert = true
                                }
                                apiKey = ""
                            }
                        }
                        .disabled(aiService.customBaseURL.isEmpty || aiService.customModel.isEmpty || apiKey.isEmpty)
                    }
                    
                } else {
                    if aiService.isAPIKeyValid {
                        HStack {
                            Text("Clé API")
                            Spacer()
                            Text("••••••••")
                                .foregroundColor(.secondary)
                            Button("Retirer", role: .destructive) {
                                aiService.clearAPIKey()
                            }
                        }
                    } else {
                        SecureField("Clé API", text: $apiKey)
                            .textFieldStyle(.roundedBorder)

                        HStack {
                            if let url = getAPIKeyURL() {
                                Link(destination: url) {
                                    HStack {
                                        Image(systemName: "key.fill")
                                        Text("Obtenir une clé API")
                                    }
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 8)
                                    .background(Color.HiHa.sovereignMarine.opacity(0.1))
                                    .cornerRadius(6)
                                }
                                .buttonStyle(.plain)
                            }

                            Spacer()

                            Button(action: {
                                isVerifying = true
                                aiService.saveAPIKey(apiKey) { success, errorMessage in
                                    isVerifying = false
                                    if !success {
                                        alertMessage = errorMessage ?? "Échec de la vérification"
                                        showAlert = true
                                    }
                                    apiKey = ""
                                }
                            }) {
                                HStack {
                                    if isVerifying {
                                        ProgressView().controlSize(.small)
                                    }
                                    Text("Vérifier et enregistrer")
                                }
                            }
                            .disabled(apiKey.isEmpty)
                        }
                    }
                }
            }
        }
        .alert("Erreur", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .onAppear {
            if aiService.selectedProvider == .ollama {
                checkOllamaConnection()
            }
            if aiService.selectedProvider == .localCLI {
                syncLocalCLIStateFromService()
            }
        }
    }

    private func syncLocalCLIStateFromService() {
        isSyncingLocalCLIState = true
        localCLICommandTemplate = aiService.localCLICommandTemplate
        localCLITimeoutSeconds = aiService.localCLITimeoutSeconds
        DispatchQueue.main.async {
            isSyncingLocalCLIState = false
        }
    }
    
    private func checkOllamaConnection() {
        isCheckingOllama = true
        aiService.checkOllamaConnection { connected in
            if connected {
                Task {
                    ollamaModels = await aiService.fetchOllamaModels()
                    isCheckingOllama = false
                }
            } else {
                ollamaModels = []
                isCheckingOllama = false
                alertMessage = "Impossible de se connecter à Ollama. Vérifie qu'Ollama est lancé et que l'URL de base est correcte."
                showAlert = true
            }
        }
    }
    
    private func getAPIKeyURL() -> URL? {
        switch aiService.selectedProvider {
        case .groq: return URL(string: "https://console.groq.com/keys")
        case .openAI: return URL(string: "https://platform.openai.com/api-keys")
        case .gemini: return URL(string: "https://makersuite.google.com/app/apikey")
        case .anthropic: return URL(string: "https://console.anthropic.com/settings/keys")
        case .mistral: return URL(string: "https://console.mistral.ai/api-keys")
        case .elevenLabs: return URL(string: "https://elevenlabs.io/speech-synthesis")
        case .deepgram: return URL(string: "https://console.deepgram.com/api-keys")
        case .soniox: return URL(string: "https://console.soniox.com/")
        case .speechmatics: return URL(string: "https://portal.speechmatics.com/manage-access/")
        case .openRouter: return URL(string: "https://openrouter.ai/keys")
        case .cerebras: return URL(string: "https://cloud.cerebras.ai/")
        default: return nil
        }
    }
}
