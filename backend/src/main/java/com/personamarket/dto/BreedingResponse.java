package com.personamarket.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BreedingResponse {
    private Long personaId;
    private String name;
    private String description;
    private String personality;
    private String tone;
    private String worldview;
    private String message;
}
