package com.personamarket.entity;

import com.personamarket.entity.enums.PersonaStatus;
import com.personamarket.entity.enums.PricingType;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

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

    @Column(nullable = false, length = 100)
    private String name;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(columnDefinition = "TEXT")
    private String personality;

    @Column(columnDefinition = "TEXT")
    private String tone;

    @Column(columnDefinition = "TEXT")
    private String worldview;

    @Column(columnDefinition = "TEXT")
    private String tags;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "creator_id")
    private User creator;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private PersonaStatus status = PersonaStatus.DRAFT;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private PricingType pricingType = PricingType.FREE;

    @Column
    @Builder.Default
    private Integer downloadCount = 0;

    @Column
    @Builder.Default
    private Double rating = 0.0;

    @Column
    @Builder.Default
    private Integer reviewCount = 0;

    @Column(length = 500)
    private String avatarImage;

    @Column
    @Builder.Default
    private Integer evolutionLevel = 1;

    @Column
    @Builder.Default
    private Integer trainingDataCount = 0;

    @Column(columnDefinition = "TEXT")
    private String systemPrompt;

    @Column(length = 100)
    private String finetuneModelId;

    @Column
    private Double price;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(nullable = false)
    private LocalDateTime updatedAt;
}
