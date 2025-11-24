package com.personamarket.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "dialogues")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Dialogue {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "persona_id")
    private Persona persona;
    
    @Column(length = 5000, nullable = false)
    private String userMessage;
    
    @Column(name = "is_training_data")
    @Builder.Default
    private Boolean isTrainingData = false;

    @Column(length = 5000, nullable = false)
    private String aiResponse;
    
    @Enumerated(EnumType.STRING)
    private EmotionFeedback emotionFeedback;
    
    @Column(length = 1000)
    private String feedbackComment;
    
    @Column(nullable = false)
    private Boolean isTrainingData = false;
    
    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    public enum EmotionFeedback {
        LOVED, LIKED, NEUTRAL, DISLIKED, HATED
    }
}
