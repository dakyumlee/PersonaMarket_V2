package com.personamarket.repository;

import com.personamarket.entity.Persona;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PersonaRepository extends JpaRepository<Persona, Long> {
    List<Persona> findByCreatorId(Long creatorId);
    Page<Persona> findByStatus(Persona.PersonaStatus status, Pageable pageable);
    
    @Query("SELECT p FROM Persona p WHERE p.status = 'PUBLISHED' ORDER BY p.rating DESC, p.downloadCount DESC")
    Page<Persona> findPublishedPersonasOrderByPopularity(Pageable pageable);
    
    @Query("SELECT p FROM Persona p WHERE p.status = 'PUBLISHED' AND (LOWER(p.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR LOWER(p.description) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    Page<Persona> searchPublishedPersonas(String keyword, Pageable pageable);
}
