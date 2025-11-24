package com.personamarket.service;

import com.personamarket.entity.Persona;
import com.personamarket.entity.Dialogue;
import com.personamarket.entity.TrainingLog;
import com.personamarket.entity.TrainingLog.TrainingType;
import com.personamarket.repository.PersonaRepository;
import com.personamarket.repository.DialogueRepository;
import com.personamarket.repository.TrainingLogRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import okhttp3.*;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class FineTuneService {
    
    private final PersonaRepository personaRepository;
    private final DialogueRepository dialogueRepository;
    private final TrainingLogRepository trainingLogRepository;
    private final OkHttpClient httpClient = new OkHttpClient();
    
    @Value("${openai.api.key}")
    private String openaiApiKey;
    
    private static final String OPENAI_API_URL = "https://api.openai.com/v1";
    private static final int MIN_TRAINING_DIALOGUES = 10;
    
    public String startFineTuning(Long personaId) throws IOException {
        Persona persona = personaRepository.findById(personaId)
            .orElseThrow(() -> new RuntimeException("페르소나를 찾을 수 없습니다"));
        
        List<Dialogue> dialogues = dialogueRepository.findByPersonaIdAndIsTrainingDataTrue(personaId);
        
        if (dialogues.size() < MIN_TRAINING_DIALOGUES) {
            throw new RuntimeException("훈련 데이터가 부족합니다 (최소 " + MIN_TRAINING_DIALOGUES + "개 필요)");
        }
        
        log.info("페르소나 {} 파인튜닝 시작 - 훈련 데이터: {}개", persona.getName(), dialogues.size());
        
        String fileId = uploadTrainingData(persona, dialogues);
        
        String jobId = createFineTuneJob(fileId, persona);
        
        persona.setFinetuneModelId(jobId);
        personaRepository.save(persona);
        
        TrainingLog trainingLog = TrainingLog.builder()
            .persona(persona)
            .trainingType(TrainingType.FINE_TUNING)
            .inputData(dialogues.size() + " dialogues")
            .trainingResult("Fine-tuning job started: " + jobId)
            .isSuccessful(true)
            .build();
        trainingLogRepository.save(trainingLog);
        
        log.info("파인튜닝 작업 생성 완료 - Job ID: {}", jobId);
        
        return jobId;
    }
    
    private String uploadTrainingData(Persona persona, List<Dialogue> dialogues) throws IOException {
        JSONArray trainingData = new JSONArray();
        
        String systemPrompt = buildSystemPrompt(persona);
        
        for (Dialogue dialogue : dialogues) {
            JSONObject example = new JSONObject();
            
            JSONArray messages = new JSONArray();
            messages.put(new JSONObject().put("role", "system").put("content", systemPrompt));
            messages.put(new JSONObject().put("role", "user").put("content", dialogue.getUserMessage()));
            messages.put(new JSONObject().put("role", "assistant").put("content", dialogue.getAiResponse()));
            
            example.put("messages", messages);
            trainingData.put(example);
        }
        
        String jsonlData = convertToJsonl(trainingData);
        
        RequestBody body = new MultipartBody.Builder()
            .setType(MultipartBody.FORM)
            .addFormDataPart("purpose", "fine-tune")
            .addFormDataPart("file", persona.getName() + "_training.jsonl",
                RequestBody.create(jsonlData.getBytes(), MediaType.parse("application/jsonl")))
            .build();
        
        Request request = new Request.Builder()
            .url(OPENAI_API_URL + "/files")
            .addHeader("Authorization", "Bearer " + openaiApiKey)
            .post(body)
            .build();
        
        try (Response response = httpClient.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                throw new IOException("파일 업로드 실패: " + response.body().string());
            }
            
            JSONObject jsonResponse = new JSONObject(response.body().string());
            String fileId = jsonResponse.getString("id");
            
            log.info("훈련 데이터 업로드 완료 - File ID: {}", fileId);
            return fileId;
        }
    }
    
    private String createFineTuneJob(String fileId, Persona persona) throws IOException {
        JSONObject requestBody = new JSONObject();
        requestBody.put("training_file", fileId);
        requestBody.put("model", "gpt-4o-mini-2024-07-18");
        requestBody.put("suffix", persona.getName().replaceAll("[^a-zA-Z0-9]", ""));
        
        RequestBody body = RequestBody.create(
            requestBody.toString(),
            MediaType.parse("application/json")
        );
        
        Request request = new Request.Builder()
            .url(OPENAI_API_URL + "/fine_tuning/jobs")
            .addHeader("Authorization", "Bearer " + openaiApiKey)
            .addHeader("Content-Type", "application/json")
            .post(body)
            .build();
        
        try (Response response = httpClient.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                throw new IOException("파인튜닝 작업 생성 실패: " + response.body().string());
            }
            
            JSONObject jsonResponse = new JSONObject(response.body().string());
            return jsonResponse.getString("id");
        }
    }
    
    public String checkFineTuneStatus(String jobId) throws IOException {
        Request request = new Request.Builder()
            .url(OPENAI_API_URL + "/fine_tuning/jobs/" + jobId)
            .addHeader("Authorization", "Bearer " + openaiApiKey)
            .get()
            .build();
        
        try (Response response = httpClient.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                throw new IOException("상태 확인 실패: " + response.body().string());
            }
            
            JSONObject jsonResponse = new JSONObject(response.body().string());
            String status = jsonResponse.getString("status");
            
            if ("succeeded".equals(status)) {
                String fineTunedModel = jsonResponse.getString("fine_tuned_model");
                log.info("파인튜닝 완료! 모델: {}", fineTunedModel);
                return fineTunedModel;
            }
            
            return status;
        }
    }
    
    private String buildSystemPrompt(Persona persona) {
        StringBuilder prompt = new StringBuilder();
        prompt.append("당신은 ").append(persona.getName()).append("입니다.\n\n");
        
        if (persona.getPersonality() != null) {
            prompt.append("성격: ").append(persona.getPersonality()).append("\n");
        }
        if (persona.getTone() != null) {
            prompt.append("말투: ").append(persona.getTone()).append("\n");
        }
        if (persona.getWorldview() != null) {
            prompt.append("세계관: ").append(persona.getWorldview()).append("\n");
        }
        
        return prompt.toString();
    }
    
    private String convertToJsonl(JSONArray jsonArray) {
        StringBuilder jsonl = new StringBuilder();
        for (int i = 0; i < jsonArray.length(); i++) {
            jsonl.append(jsonArray.getJSONObject(i).toString()).append("\n");
        }
        return jsonl.toString();
    }
}
