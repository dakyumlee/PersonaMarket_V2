package com.personamarket.repository;

import com.personamarket.entity.TrainingLog;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TrainingLogRepository extends JpaRepository<TrainingLog, Long> {
    List<TrainingLog> findByPersonaIdOrderByCreatedAtDesc(Long personaId);
    Page<TrainingLog> findByPersonaId(Long personaId, Pageable pageable);
}
