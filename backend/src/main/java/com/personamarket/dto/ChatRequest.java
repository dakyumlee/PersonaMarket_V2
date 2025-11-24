package com.personamarket.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class ChatRequest {
    
    @NotNull(message = "Persona ID is required")
    private Long personaId;
    
    @NotBlank(message = "Message is required")
    private String message;
}
