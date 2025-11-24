package com.personamarket.repository;

import com.personamarket.entity.Dialogue;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DialogueRepository extends JpaRepository<Dialogue, Long> {
    List<Dialogue> findByPersonaIdAndUserId(Long personaId, Long userId);
    Page<Dialogue> findByPersonaId(Long personaId, Pageable pageable);
    List<Dialogue> findByPersonaIdAndIsTrainingDataTrue(Long personaId);
}
