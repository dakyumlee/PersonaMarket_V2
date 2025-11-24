package com.personamarket.controller;

import com.personamarket.dto.BreedingRequest;
import com.personamarket.dto.BreedingResponse;
import com.personamarket.entity.Persona;
import com.personamarket.entity.User;
import com.personamarket.service.BreedingService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/breeding")
@RequiredArgsConstructor
public class BreedingController {
    
    private final BreedingService breedingService;
    
    @PostMapping
    public ResponseEntity<BreedingResponse> breedPersonas(
            @RequestBody BreedingRequest request,
            @AuthenticationPrincipal UserDetails userDetails) {
        
        User creator = (User) userDetails;
        
        Persona child = breedingService.breedPersonas(
            request.getParent1Id(),
            request.getParent2Id(),
            request.getChildName(),
            creator
        );
        
        return ResponseEntity.ok(BreedingResponse.builder()
            .personaId(child.getId())
            .name(child.getName())
            .description(child.getDescription())
            .personality(child.getPersonality())
            .tone(child.getTone())
            .worldview(child.getWorldview())
            .message("브리딩 성공! " + child.getName() + " (Lv." + child.getEvolutionLevel() + ")이 탄생했습니다!")
            .build());
    }
}
