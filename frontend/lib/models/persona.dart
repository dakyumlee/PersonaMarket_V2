class Persona {
  final int id;
  final String name;
  final String? description;
  final String? personality;
  final String? tone;
  final String? worldview;
  final String? avatarImage;
  final int creatorId;
  final String creatorUsername;
  final String status;
  final String pricingType;
  final double? price;
  final int downloadCount;
  final double rating;
  final int reviewCount;
  final String? tags;
  final int evolutionLevel;
  final int trainingDataCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Persona({
    required this.id,
    required this.name,
    this.description,
    this.personality,
    this.tone,
    this.worldview,
    this.avatarImage,
    required this.creatorId,
    required this.creatorUsername,
    required this.status,
    required this.pricingType,
    this.price,
    required this.downloadCount,
    required this.rating,
    required this.reviewCount,
    this.tags,
    required this.evolutionLevel,
    required this.trainingDataCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      personality: json['personality'],
      tone: json['tone'],
      worldview: json['worldview'],
      avatarImage: json['avatarImage'],
      creatorId: json['creatorId'],
      creatorUsername: json['creatorUsername'],
      status: json['status'],
      pricingType: json['pricingType'],
      price: json['price']?.toDouble(),
      downloadCount: json['downloadCount'],
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'],
      tags: json['tags'],
      evolutionLevel: json['evolutionLevel'],
      trainingDataCount: json['trainingDataCount'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'personality': personality,
      'tone': tone,
      'worldview': worldview,
      'avatarImage': avatarImage,
      'creatorId': creatorId,
      'creatorUsername': creatorUsername,
      'status': status,
      'pricingType': pricingType,
      'price': price,
      'downloadCount': downloadCount,
      'rating': rating,
      'reviewCount': reviewCount,
      'tags': tags,
      'evolutionLevel': evolutionLevel,
      'trainingDataCount': trainingDataCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
