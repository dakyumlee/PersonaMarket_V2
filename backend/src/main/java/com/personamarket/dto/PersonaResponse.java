package com.personamarket.dto;

import com.personamarket.entity.Persona;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
@AllArgsConstructor
public class PersonaResponse {
    private Long id;
    private String name;
    private String description;
    private String personality;
    private String tone;
    private String worldview;
    private String avatarImage;
    private Long creatorId;
    private String creatorUsername;
    private Persona.PersonaStatus status;
    private Persona.PricingType pricingType;
    private BigDecimal price;
    private Integer downloadCount;
    private Double rating;
    private Integer reviewCount;
    private String tags;
    private Integer evolutionLevel;
    private Integer trainingDataCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
