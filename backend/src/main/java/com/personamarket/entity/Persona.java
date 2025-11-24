package com.personamarket.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "personas")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Persona {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String name;
    
    @Column(length = 2000)
    private String description;
    
    @Column(length = 5000)
    private String personality;
    
    @Column(length = 2000)
    private String tone;
    
    @Column(length = 2000)
    private String worldview;
    
    @Column(length = 5000)
    private String systemPrompt;
    
    private String avatarImage;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "creator_id")
    private User creator;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private PersonaStatus status = PersonaStatus.DRAFT;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private PricingType pricingType = PricingType.FREE;
    
    private BigDecimal price;
    
    @Column(nullable = false)
    private Integer downloadCount = 0;
    
    @Column(nullable = false)
    private Double rating = 0.0;
    
    @Column(nullable = false)
    private Integer reviewCount = 0;
    
    @Column(length = 1000)
    private String tags;
    
    @Column(nullable = false)
    private Integer evolutionLevel = 1;
    
    @Column(nullable = false)
    private Integer trainingDataCount = 0;
    
    private String finetuneModelId;
    
    @OneToMany(mappedBy = "persona", cascade = CascadeType.ALL)
    @Builder.Default
    private List<Dialogue> dialogues = new ArrayList<>();
    
    @OneToMany(mappedBy = "persona", cascade = CascadeType.ALL)
    @Builder.Default
    private List<TrainingLog> trainingLogs = new ArrayList<>();
    
    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @UpdateTimestamp
    private LocalDateTime updatedAt;
    
    public enum PersonaStatus {
        DRAFT, PUBLISHED, PRIVATE, ARCHIVED
    }
    
    public enum PricingType {
        FREE, PAID
    }
}
