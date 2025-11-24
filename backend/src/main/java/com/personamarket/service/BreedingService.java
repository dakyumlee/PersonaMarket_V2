package com.personamarket.service;

import com.personamarket.entity.Persona;
import com.personamarket.entity.User;
import com.personamarket.repository.PersonaRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class BreedingService {
    
    private final PersonaRepository personaRepository;
    private final Random random = new Random();
    
    @Transactional
    public Persona breedPersonas(Long parent1Id, Long parent2Id, String childName, User creator) {
        Persona parent1 = personaRepository.findById(parent1Id)
            .orElseThrow(() -> new RuntimeException("부모 페르소나 1을 찾을 수 없습니다"));
        
        Persona parent2 = personaRepository.findById(parent2Id)
            .orElseThrow(() -> new RuntimeException("부모 페르소나 2를 찾을 수 없습니다"));
        
        log.info("브리딩 시작: {} + {} = {}", parent1.getName(), parent2.getName(), childName);
        
        Persona child = Persona.builder()
            .name(childName)
            .description(combineDescriptions(parent1.getDescription(), parent2.getDescription()))
            .personality(combineTraits(parent1.getPersonality(), parent2.getPersonality()))
            .tone(combineTone(parent1.getTone(), parent2.getTone()))
            .worldview(combineWorldview(parent1.getWorldview(), parent2.getWorldview()))
            .tags(combineTags(parent1.getTags(), parent2.getTags()))
            .creator(creator)
            .status(Persona.PersonaStatus.DRAFT)
            .pricingType(Persona.PricingType.FREE)
            .downloadCount(0)
            .rating(0.0)
            .reviewCount(0)
            .evolutionLevel(calculateChildLevel(parent1.getEvolutionLevel(), parent2.getEvolutionLevel()))
            .trainingDataCount(0)
            .build();
        
        String systemPrompt = buildSystemPrompt(child);
        child.setSystemPrompt(systemPrompt);
        
        Persona savedChild = personaRepository.save(child);
        
        log.info("브리딩 완료: {} (Lv.{})", savedChild.getName(), savedChild.getEvolutionLevel());
        
        return savedChild;
    }
    
    private String combineDescriptions(String desc1, String desc2) {
        if (desc1 == null && desc2 == null) return "두 페르소나의 특성을 결합한 독특한 AI입니다.";
        if (desc1 == null) return desc2;
        if (desc2 == null) return desc1;
        
        return String.format("%s와 %s의 특성을 결합한 AI입니다.", 
            extractKeyPhrase(desc1), extractKeyPhrase(desc2));
    }
    
    private String combineTraits(String trait1, String trait2) {
        if (trait1 == null && trait2 == null) return null;
        if (trait1 == null) return trait2;
        if (trait2 == null) return trait1;
        
        List<String> traits1 = splitTraits(trait1);
        List<String> traits2 = splitTraits(trait2);
        
        List<String> combined = Arrays.asList(
            selectTrait(traits1),
            selectTrait(traits2),
            selectTrait(traits1),
            selectTrait(traits2)
        );
        
        return combined.stream()
            .distinct()
            .collect(Collectors.joining(", "));
    }
    
    private String combineTone(String tone1, String tone2) {
        if (tone1 == null && tone2 == null) return null;
        if (tone1 == null) return tone2;
        if (tone2 == null) return tone1;
        
        return random.nextBoolean() 
            ? String.format("%s하면서도 %s", tone1, tone2)
            : String.format("%s하고 %s", tone2, tone1);
    }
    
    private String combineWorldview(String world1, String world2) {
        if (world1 == null && world2 == null) return null;
        if (world1 == null) return world2;
        if (world2 == null) return world1;
        
        return String.format("%s\n\n%s", world1, world2);
    }
    
    private String combineTags(String tags1, String tags2) {
        if (tags1 == null && tags2 == null) return "브리딩,하이브리드";
        if (tags1 == null) return tags2 + ",브리딩";
        if (tags2 == null) return tags1 + ",브리딩";
        
        return tags1 + "," + tags2 + ",브리딩,하이브리드";
    }
    
    private Integer calculateChildLevel(Integer level1, Integer level2) {
        if (level1 == null) level1 = 1;
        if (level2 == null) level2 = 1;
        
        return (int) Math.ceil((level1 + level2) / 2.0) + random.nextInt(2);
    }
    
    private List<String> splitTraits(String traits) {
        return Arrays.stream(traits.split("[,，.]"))
            .map(String::trim)
            .filter(s -> !s.isEmpty())
            .collect(Collectors.toList());
    }
    
    private String selectTrait(List<String> traits) {
        if (traits.isEmpty()) return "독특한";
        return traits.get(random.nextInt(traits.size()));
    }
    
    private String extractKeyPhrase(String text) {
        if (text.length() <= 20) return text;
        return text.substring(0, Math.min(20, text.length())) + "...";
    }
    
    private String buildSystemPrompt(Persona persona) {
        StringBuilder prompt = new StringBuilder();
        prompt.append("당신은 ").append(persona.getName()).append("입니다.\n\n");
        
        if (persona.getPersonality() != null) {
            prompt.append("성격: ").append(persona.getPersonality()).append("\n");
        }
        if (persona.getTone() != null) {
            prompt.append("말투: ").append(persona.getTone()).append("\n");
        }
        if (persona.getWorldview() != null) {
            prompt.append("세계관: ").append(persona.getWorldview()).append("\n");
        }
        
        return prompt.toString();
    }
}
