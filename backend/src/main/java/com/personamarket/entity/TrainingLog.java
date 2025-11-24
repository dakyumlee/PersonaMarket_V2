package com.personamarket.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "training_logs")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TrainingLog {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "persona_id")
    private Persona persona;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TrainingType trainingType;
    
    @Column(length = 5000)
    private String inputData;
    
    @Column(length = 2000)
    private String trainingResult;
    
    @Column(nullable = false)
    private Boolean isSuccessful = true;
    
    private String errorMessage;
    
    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    public enum TrainingType {
        INITIAL_SETUP,
        CONVERSATION_FEEDBACK,
        TEXT_UPLOAD,
        EMOTION_BASED,
        FINE_TUNING
    }
}
