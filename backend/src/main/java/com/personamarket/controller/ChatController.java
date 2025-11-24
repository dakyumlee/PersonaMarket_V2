package com.personamarket.controller;

import com.personamarket.dto.ChatRequest;
import com.personamarket.dto.ChatResponse;
import com.personamarket.service.ChatService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/chat")
@RequiredArgsConstructor
public class ChatController {
    
    private final ChatService chatService;
    
    @PostMapping
    public ResponseEntity<ChatResponse> chat(
            @Valid @RequestBody ChatRequest request,
            Authentication authentication) throws Exception {
        return ResponseEntity.ok(chatService.chat(request, authentication.getName()));
    }
}
