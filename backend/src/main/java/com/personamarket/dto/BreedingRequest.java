package com.personamarket.dto;

import lombok.Data;

@Data
public class BreedingRequest {
    private Long parent1Id;
    private Long parent2Id;
    private String childName;
}
