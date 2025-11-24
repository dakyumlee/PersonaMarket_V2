import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFFB091F2);
  static const secondary = Color(0xFF7D5CF2);
  static const tertiary = Color(0xFF52428C);
  static const accent = Color(0xFF9379F2);
  static const background = Color(0xFF0D0D0D);
  static const surface = Color(0xFF1A1A1A);
  static const cardBackground = Color(0xFF222222);
  static const border = Color(0xFF2D2D2D);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB3B3B3);
  static const textTertiary = Color(0xFF666666);
  
  static const subtleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB091F2), Color(0xFF9379F2)],
    stops: [0.0, 1.0],
  );
  
  static const cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1F1F1F), Color(0xFF252525)],
  );
}

class AppStrings {
  static const String marketTitle = '페르소나 마켓';
  static const String marketSubtitle = '자아가 팔리는 세상';
  static const String searchPlaceholder = '페르소나 검색...';
  static const String noPersonasFound = '페르소나가 없습니다';
  
  static const String createTitle = '페르소나 생성';
  static const String createSubtitle = '독특한 AI 인격을 디자인하세요';
  static const String trainTitle = '페르소나 훈련';
  static const String trainSubtitle = '대화하며 AI를 진화시키세요';
  
  static const String name = '이름';
  static const String namePlaceholder = '페르소나 이름을 입력하세요';
  static const String description = '설명';
  static const String descriptionPlaceholder = '페르소나를 설명해주세요';
  static const String personality = '성격';
  static const String personalityPlaceholder = '친절하고, 재치있고, 철학적인...';
  static const String tone = '말투';
  static const String tonePlaceholder = '캐주얼한, 격식있는, 시적인...';
  static const String worldview = '세계관';
  static const String worldviewPlaceholder = '가치관, 신념, 관점...';
  static const String tags = '태그';
  static const String tagsPlaceholder = '친절함, 창의적, 기술 (쉼표로 구분)';
  
  static const String status = '상태';
  static const String pricing = '가격 설정';
  static const String draft = '임시저장';
  static const String published = '공개';
  static const String private = '비공개';
  static const String free = '무료';
  static const String paid = '유료';
  static const String createButton = '페르소나 생성';
  static const String startTraining = '훈련 시작';
  
  static const String profileTitle = '프로필';
  static const String myPersonas = '내 페르소나';
  static const String chatHistory = '대화 기록';
  static const String settings = '설정';
  static const String logout = '로그아웃';
  
  static const String loginTitle = '로그인';
  static const String loginSubtitle = 'Persona Market에 오신 것을 환영합니다';
  static const String registerTitle = '회원가입';
  static const String registerSubtitle = 'AI 인격을 만들고 세상과 공유하세요';
  static const String email = '이메일';
  static const String emailPlaceholder = 'email@example.com';
  static const String password = '비밀번호';
  static const String username = '사용자명';
  static const String usernamePlaceholder = '3-20자의 사용자명';
  static const String confirmPassword = '비밀번호 확인';
  static const String loginButton = '로그인';
  static const String registerButton = '회원가입';
  static const String noAccount = '계정이 없으신가요? ';
  static const String register = '회원가입';
  
  static const String startConversation = '대화 시작하기';
  static const String typePlaceholder = '메시지를 입력하세요...';
  static const String thinking = '생각 중...';
  
  static const String by = 'by';
  static const String evolutionLevel = '진화 레벨';
  static const String downloads = '다운로드';
  static const String level = '레벨';
  
  static const String trainingMessages = '훈련 메시지';
  static const String minRequired = '최소 필요';
}

class AppSizes {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  static const double borderRadius = 12.0;
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusLarge = 16.0;
  
  static const double iconSize = 24.0;
  static const double iconSizeSmall = 20.0;
  static const double iconSizeLarge = 32.0;
}

class AppConfig {
  static const String apiBaseUrl = 'http://localhost:8080/api';
  static const String appName = 'Persona Market';
}
