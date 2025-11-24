package com.personamarket.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.personamarket.dto.ChatRequest;
import com.personamarket.dto.ChatResponse;
import com.personamarket.entity.Dialogue;
import com.personamarket.entity.Persona;
import com.personamarket.entity.User;
import com.personamarket.repository.DialogueRepository;
import com.personamarket.repository.PersonaRepository;
import com.personamarket.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import okhttp3.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ChatService {
    
    private final PersonaRepository personaRepository;
    private final UserRepository userRepository;
    private final DialogueRepository dialogueRepository;
    private final OkHttpClient httpClient = new OkHttpClient();
    private final ObjectMapper objectMapper = new ObjectMapper();
    
    @Value("${openai.api-key}")
    private String openaiApiKey;
    
    @Value("${openai.model}")
    private String model;
    
    @Transactional
    public ChatResponse chat(ChatRequest request, String userEmail) throws Exception {
        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        Persona persona = personaRepository.findById(request.getPersonaId())
                .orElseThrow(() -> new RuntimeException("Persona not found"));
        
        List<Dialogue> history = dialogueRepository.findByPersonaIdAndUserId(persona.getId(), user.getId());
        
        String aiResponse = callOpenAI(persona, request.getMessage(), history);
        
        Dialogue dialogue = Dialogue.builder()
                .user(user)
                .persona(persona)
                .userMessage(request.getMessage())
                .aiResponse(aiResponse)
                .build();
        
        dialogue = dialogueRepository.save(dialogue);
        
        return ChatResponse.builder()
                .dialogueId(dialogue.getId())
                .response(aiResponse)
                .timestamp(LocalDateTime.now())
                .build();
    }
    
    private String callOpenAI(Persona persona, String userMessage, List<Dialogue> history) throws Exception {
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("model", model);
        
        List<Map<String, String>> messages = new java.util.ArrayList<>();
        
        messages.add(Map.of("role", "system", "content", persona.getSystemPrompt()));
        
        for (Dialogue dialogue : history) {
            messages.add(Map.of("role", "user", "content", dialogue.getUserMessage()));
            messages.add(Map.of("role", "assistant", "content", dialogue.getAiResponse()));
        }
        
        messages.add(Map.of("role", "user", "content", userMessage));
        
        requestBody.put("messages", messages);
        requestBody.put("max_tokens", 500);
        requestBody.put("temperature", 0.7);
        
        String json = objectMapper.writeValueAsString(requestBody);
        
        RequestBody body = RequestBody.create(json, MediaType.get("application/json; charset=utf-8"));
        
        Request httpRequest = new Request.Builder()
                .url("https://api.openai.com/v1/chat/completions")
                .post(body)
                .addHeader("Authorization", "Bearer " + openaiApiKey)
                .addHeader("Content-Type", "application/json")
                .build();
        
        try (Response response = httpClient.newCall(httpRequest).execute()) {
            if (!response.isSuccessful()) {
                throw new RuntimeException("OpenAI API call failed: " + response);
            }
            
            String responseBody = response.body().string();
            JsonNode jsonNode = objectMapper.readTree(responseBody);
            return jsonNode.path("choices").get(0).path("message").path("content").asText();
        }
    }
}
