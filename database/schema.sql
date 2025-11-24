CREATE DATABASE persona_market;

\c persona_market;

CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    profile_image VARCHAR(500),
    bio TEXT,
    role VARCHAR(50) NOT NULL DEFAULT 'USER',
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE personas (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    personality TEXT,
    tone TEXT,
    worldview TEXT,
    system_prompt TEXT,
    avatar_image VARCHAR(500),
    creator_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(50) NOT NULL DEFAULT 'DRAFT',
    pricing_type VARCHAR(50) NOT NULL DEFAULT 'FREE',
    price DECIMAL(10, 2),
    download_count INTEGER NOT NULL DEFAULT 0,
    rating DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    review_count INTEGER NOT NULL DEFAULT 0,
    tags VARCHAR(1000),
    evolution_level INTEGER NOT NULL DEFAULT 1,
    training_data_count INTEGER NOT NULL DEFAULT 0,
    finetune_model_id VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dialogues (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    persona_id BIGINT REFERENCES personas(id) ON DELETE CASCADE,
    user_message TEXT NOT NULL,
    ai_response TEXT NOT NULL,
    emotion_feedback VARCHAR(50),
    feedback_comment TEXT,
    is_training_data BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE training_logs (
    id BIGSERIAL PRIMARY KEY,
    persona_id BIGINT REFERENCES personas(id) ON DELETE CASCADE,
    training_type VARCHAR(50) NOT NULL,
    input_data TEXT,
    training_result TEXT,
    is_successful BOOLEAN NOT NULL DEFAULT true,
    error_message TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_personas_creator ON personas(creator_id);
CREATE INDEX idx_personas_status ON personas(status);
CREATE INDEX idx_dialogues_user_persona ON dialogues(user_id, persona_id);
CREATE INDEX idx_dialogues_persona ON dialogues(persona_id);
CREATE INDEX idx_training_logs_persona ON training_logs(persona_id);
