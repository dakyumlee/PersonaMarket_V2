package com.personamarket.service;

import com.personamarket.dto.PersonaRequest;
import com.personamarket.dto.PersonaResponse;
import com.personamarket.entity.Persona;
import com.personamarket.entity.User;
import com.personamarket.repository.PersonaRepository;
import com.personamarket.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class PersonaService {
    
    private final PersonaRepository personaRepository;
    private final UserRepository userRepository;
    
    @Transactional
    public PersonaResponse createPersona(PersonaRequest request, String userEmail) {
        User creator = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        String systemPrompt = buildSystemPrompt(request);
        
        Persona persona = Persona.builder()
                .name(request.getName())
                .description(request.getDescription())
                .personality(request.getPersonality())
                .tone(request.getTone())
                .worldview(request.getWorldview())
                .systemPrompt(systemPrompt)
                .avatarImage(request.getAvatarImage())
                .creator(creator)
                .status(request.getStatus() != null ? request.getStatus() : Persona.PersonaStatus.DRAFT)
                .pricingType(request.getPricingType() != null ? request.getPricingType() : Persona.PricingType.FREE)
                .price(request.getPrice())
                .tags(request.getTags())
                .build();
        
        persona = personaRepository.save(persona);
        return mapToResponse(persona);
    }
    
    @Transactional
    public PersonaResponse updatePersona(Long id, PersonaRequest request, String userEmail) {
        Persona persona = personaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Persona not found"));
        
        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        if (!persona.getCreator().getId().equals(user.getId())) {
            throw new RuntimeException("Unauthorized to update this persona");
        }
        
        persona.setName(request.getName());
        persona.setDescription(request.getDescription());
        persona.setPersonality(request.getPersonality());
        persona.setTone(request.getTone());
        persona.setWorldview(request.getWorldview());
        persona.setSystemPrompt(buildSystemPrompt(request));
        persona.setAvatarImage(request.getAvatarImage());
        persona.setStatus(request.getStatus());
        persona.setPricingType(request.getPricingType());
        persona.setPrice(request.getPrice());
        persona.setTags(request.getTags());
        
        persona = personaRepository.save(persona);
        return mapToResponse(persona);
    }
    
    public PersonaResponse getPersona(Long id) {
        Persona persona = personaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Persona not found"));
        return mapToResponse(persona);
    }
    
    public Page<PersonaResponse> getPublicPersonas(Pageable pageable) {
        return personaRepository.findPublishedPersonasOrderByPopularity(pageable)
                .map(this::mapToResponse);
    }
    
    public Page<PersonaResponse> searchPersonas(String keyword, Pageable pageable) {
        return personaRepository.searchPublishedPersonas(keyword, pageable)
                .map(this::mapToResponse);
    }
    
    @Transactional
    public void deletePersona(Long id, String userEmail) {
        Persona persona = personaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Persona not found"));
        
        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        if (!persona.getCreator().getId().equals(user.getId())) {
            throw new RuntimeException("Unauthorized to delete this persona");
        }
        
        personaRepository.delete(persona);
    }
    
    private String buildSystemPrompt(PersonaRequest request) {
        StringBuilder prompt = new StringBuilder();
        prompt.append("You are a unique AI persona with the following characteristics:\n\n");
        
        if (request.getPersonality() != null && !request.getPersonality().isEmpty()) {
            prompt.append("Personality: ").append(request.getPersonality()).append("\n\n");
        }
        
        if (request.getTone() != null && !request.getTone().isEmpty()) {
            prompt.append("Tone: ").append(request.getTone()).append("\n\n");
        }
        
        if (request.getWorldview() != null && !request.getWorldview().isEmpty()) {
            prompt.append("Worldview: ").append(request.getWorldview()).append("\n\n");
        }
        
        prompt.append("Stay true to these characteristics in all your responses.");
        
        return prompt.toString();
    }
    
    private PersonaResponse mapToResponse(Persona persona) {
        return PersonaResponse.builder()
                .id(persona.getId())
                .name(persona.getName())
                .description(persona.getDescription())
                .personality(persona.getPersonality())
                .tone(persona.getTone())
                .worldview(persona.getWorldview())
                .avatarImage(persona.getAvatarImage())
                .creatorId(persona.getCreator().getId())
                .creatorUsername(persona.getCreator().getUsername())
                .status(persona.getStatus())
                .pricingType(persona.getPricingType())
                .price(persona.getPrice())
                .downloadCount(persona.getDownloadCount())
                .rating(persona.getRating())
                .reviewCount(persona.getReviewCount())
                .tags(persona.getTags())
                .evolutionLevel(persona.getEvolutionLevel())
                .trainingDataCount(persona.getTrainingDataCount())
                .createdAt(persona.getCreatedAt())
                .updatedAt(persona.getUpdatedAt())
                .build();
    }
}
