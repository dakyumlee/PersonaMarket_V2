import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../models/persona.dart';
import '../widgets/lab_button.dart';
import '../widgets/lab_card.dart';
import 'chat_screen.dart';

class PersonaDetailScreen extends StatelessWidget {
  final Persona persona;

  const PersonaDetailScreen({super.key, required this.persona});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              backgroundColor: AppColors.background,
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: const Icon(Icons.arrow_back, color: AppColors.primary, size: 20),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withOpacity(0.2),
                        AppColors.accent.withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.subtleGradient,
                      ),
                      child: Center(
                        child: Text(
                          persona.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            persona.name,
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: persona.pricingType == 'FREE'
                                ? LinearGradient(colors: [Colors.green, Colors.green.shade700])
                                : AppColors.subtleGradient,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            persona.pricingType == 'FREE' ? AppStrings.free : AppStrings.paid,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${AppStrings.by} ${persona.creatorUsername}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        _buildStatChip(
                          context,
                          Icons.star,
                          persona.rating.toStringAsFixed(1),
                          Colors.amber,
                        ),
                        const SizedBox(width: 12),
                        _buildStatChip(
                          context,
                          Icons.download,
                          '${persona.downloadCount}',
                          AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        _buildStatChip(
                          context,
                          Icons.trending_up,
                          '${AppStrings.level} ${persona.evolutionLevel}',
                          AppColors.accent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildSection(
                      context,
                      AppStrings.description,
                      persona.description ?? '설명이 없습니다',
                      Icons.description_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      context,
                      AppStrings.personality,
                      persona.personality ?? '지정되지 않음',
                      Icons.psychology_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      context,
                      AppStrings.tone,
                      persona.tone ?? '지정되지 않음',
                      Icons.record_voice_over_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      context,
                      AppStrings.worldview,
                      persona.worldview ?? '지정되지 않음',
                      Icons.public_outlined,
                    ),
                    const SizedBox(height: 32),
                    LabButton(
                      text: AppStrings.startConversation,
                      icon: Icons.chat_bubble_outline,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(persona: persona),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(BuildContext context, IconData icon, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppColors.subtleGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LabCard(
          hasBorder: true,
          child: Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
