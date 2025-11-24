package com.personamarket.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FineTuneResponse {
    private String status;
    private String message;
    private String jobId;
    private Integer trainingDataCount;
    private String modelId;
}
