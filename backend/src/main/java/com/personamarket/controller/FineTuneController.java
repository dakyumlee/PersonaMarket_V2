package com.personamarket.controller;

import com.personamarket.dto.FineTuneRequest;
import com.personamarket.dto.FineTuneResponse;
import com.personamarket.service.FineTuneService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/finetune")
@RequiredArgsConstructor
public class FineTuneController {
    
    private final FineTuneService fineTuneService;
    
    @PostMapping("/start")
    public ResponseEntity<FineTuneResponse> startFineTuning(@RequestBody FineTuneRequest request) {
        try {
            String jobId = fineTuneService.startFineTuning(request.getPersonaId());
            
            return ResponseEntity.ok(FineTuneResponse.builder()
                .status("started")
                .message("파인튜닝이 시작되었습니다!")
                .jobId(jobId)
                .build());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(FineTuneResponse.builder()
                .status("error")
                .message(e.getMessage())
                .build());
        }
    }
    
    @GetMapping("/status/{jobId}")
    public ResponseEntity<FineTuneResponse> checkStatus(@PathVariable String jobId) {
        try {
            String status = fineTuneService.checkFineTuneStatus(jobId);
            
            return ResponseEntity.ok(FineTuneResponse.builder()
                .status(status)
                .message("훈련 상태: " + status)
                .jobId(jobId)
                .build());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(FineTuneResponse.builder()
                .status("error")
                .message(e.getMessage())
                .build());
        }
    }
}
