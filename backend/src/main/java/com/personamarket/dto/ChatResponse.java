package com.personamarket.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
@AllArgsConstructor
public class ChatResponse {
    private Long dialogueId;
    private String response;
    private LocalDateTime timestamp;
}
