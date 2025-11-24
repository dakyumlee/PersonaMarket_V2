package com.personamarket.dto;

import com.personamarket.entity.Persona;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class PersonaRequest {
    
    @NotBlank(message = "Name is required")
    @Size(max = 100, message = "Name must not exceed 100 characters")
    private String name;
    
    @Size(max = 2000, message = "Description must not exceed 2000 characters")
    private String description;
    
    @Size(max = 5000, message = "Personality must not exceed 5000 characters")
    private String personality;
    
    @Size(max = 2000, message = "Tone must not exceed 2000 characters")
    private String tone;
    
    @Size(max = 2000, message = "Worldview must not exceed 2000 characters")
    private String worldview;
    
    private String avatarImage;
    
    private Persona.PersonaStatus status;
    
    private Persona.PricingType pricingType;
    
    private BigDecimal price;
    
    private String tags;
}
