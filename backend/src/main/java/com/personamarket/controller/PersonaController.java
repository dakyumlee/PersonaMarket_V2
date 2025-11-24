package com.personamarket.controller;

import com.personamarket.dto.PersonaRequest;
import com.personamarket.dto.PersonaResponse;
import com.personamarket.service.PersonaService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/personas")
@RequiredArgsConstructor
public class PersonaController {
    
    private final PersonaService personaService;
    
    @PostMapping
    public ResponseEntity<PersonaResponse> createPersona(
            @Valid @RequestBody PersonaRequest request,
            Authentication authentication) {
        return ResponseEntity.ok(personaService.createPersona(request, authentication.getName()));
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<PersonaResponse> updatePersona(
            @PathVariable Long id,
            @Valid @RequestBody PersonaRequest request,
            Authentication authentication) {
        return ResponseEntity.ok(personaService.updatePersona(id, request, authentication.getName()));
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<PersonaResponse> getPersona(@PathVariable Long id) {
        return ResponseEntity.ok(personaService.getPersona(id));
    }
    
    @GetMapping("/public")
    public ResponseEntity<Page<PersonaResponse>> getPublicPersonas(Pageable pageable) {
        return ResponseEntity.ok(personaService.getPublicPersonas(pageable));
    }
    
    @GetMapping("/search")
    public ResponseEntity<Page<PersonaResponse>> searchPersonas(
            @RequestParam String keyword,
            Pageable pageable) {
        return ResponseEntity.ok(personaService.searchPersonas(keyword, pageable));
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePersona(
            @PathVariable Long id,
            Authentication authentication) {
        personaService.deletePersona(id, authentication.getName());
        return ResponseEntity.noContent().build();
    }
}
