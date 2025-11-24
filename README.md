# Persona Market

자아가 팔리는 세상 - AI 인격을 생성, 훈련, 판매하는 실험적 마켓플레이스

## 프로젝트 구조

```
persona-market/
├── backend/           Spring Boot REST API
├── frontend/          Flutter Mobile/Web App
├── ai/                Python GPT Fine-tuning Scripts
├── database/          PostgreSQL Schemas
└── assets/            Project Assets
```

## 기술 스택

- **Backend**: Spring Boot 3.2, PostgreSQL, JWT
- **Frontend**: Flutter 3.0+, Provider
- **AI**: OpenAI GPT-4o-mini, Fine-tuning API
- **Database**: PostgreSQL 15+

## 시작하기

### Backend

```bash
cd backend
./gradlew bootRun
```

환경변수:
- `OPENAI_API_KEY`: OpenAI API Key
- `JWT_SECRET`: JWT Secret Key

### Frontend

```bash
cd frontend
flutter pub get
flutter run
```

### Database

```bash
psql -U postgres -f database/schema.sql
```

### AI Fine-tuning

```bash
cd ai
pip install -r requirements.txt
python finetune_persona.py
```

## 주요 기능

1. **Creator**: AI 훈련 및 생성
2. **Market**: 페르소나 거래 마켓
3. **User**: 페르소나와 대화
4. **Training**: GPT 파인튜닝 기반 성격 진화

## 컬러 팔레트

- Primary: #B091F2
- Secondary: #7D5CF2
- Tertiary: #52428C
- Accent: #9379F2
- Background: #0D0D0D
