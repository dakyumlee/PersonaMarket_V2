import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../services/persona_service.dart';
import '../widgets/lab_button.dart';

class CreatePersonaScreen extends StatefulWidget {
  const CreatePersonaScreen({super.key});

  @override
  State<CreatePersonaScreen> createState() => _CreatePersonaScreenState();
}

class _CreatePersonaScreenState extends State<CreatePersonaScreen> {
  final _formKey = GlobalKey<FormState>();
  final PersonaService _personaService = PersonaService();
  
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _personalityController = TextEditingController();
  final _toneController = TextEditingController();
  final _worldviewController = TextEditingController();
  final _tagsController = TextEditingController();
  
  bool _isLoading = false;
  String _status = 'DRAFT';
  String _pricingType = 'FREE';

  Future<void> _createPersona() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _personaService.createPersona({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'personality': _personalityController.text,
        'tone': _toneController.text,
        'worldview': _worldviewController.text,
        'tags': _tagsController.text,
        'status': _status,
        'pricingType': _pricingType,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✨ 페르소나가 생성되었습니다!'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            ),
          ),
        );
        _clearForm();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ 생성 실패: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            ),
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _personalityController.clear();
    _toneController.clear();
    _worldviewController.clear();
    _tagsController.clear();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(color: AppColors.textTertiary),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.subtleGradient,
                      ),
                      child: const Icon(
                        Icons.science,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.createTitle,
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            AppStrings.createSubtitle,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildTextField(
                  controller: _nameController,
                  label: AppStrings.name,
                  placeholder: AppStrings.namePlaceholder,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이름을 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _descriptionController,
                  label: AppStrings.description,
                  placeholder: AppStrings.descriptionPlaceholder,
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _personalityController,
                  label: AppStrings.personality,
                  placeholder: AppStrings.personalityPlaceholder,
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _toneController,
                  label: AppStrings.tone,
                  placeholder: AppStrings.tonePlaceholder,
                  maxLines: 2,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _worldviewController,
                  label: AppStrings.worldview,
                  placeholder: AppStrings.worldviewPlaceholder,
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _tagsController,
                  label: AppStrings.tags,
                  placeholder: AppStrings.tagsPlaceholder,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            AppStrings.status,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                              border: Border.all(color: AppColors.border, width: 1),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: _status,
                              dropdownColor: AppColors.surface,
                              style: const TextStyle(color: AppColors.textPrimary),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'DRAFT', child: Text(AppStrings.draft)),
                                DropdownMenuItem(value: 'PUBLISHED', child: Text(AppStrings.published)),
                                DropdownMenuItem(value: 'PRIVATE', child: Text(AppStrings.private)),
                              ],
                              onChanged: (value) => setState(() => _status = value!),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            AppStrings.pricing,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                              border: Border.all(color: AppColors.border, width: 1),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: _pricingType,
                              dropdownColor: AppColors.surface,
                              style: const TextStyle(color: AppColors.textPrimary),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'FREE', child: Text(AppStrings.free)),
                                DropdownMenuItem(value: 'PAID', child: Text(AppStrings.paid)),
                              ],
                              onChanged: (value) => setState(() => _pricingType = value!),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                LabButton(
                  text: AppStrings.createButton,
                  icon: Icons.add_circle_outline,
                  onPressed: _isLoading ? null : _createPersona,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _personalityController.dispose();
    _toneController.dispose();
    _worldviewController.dispose();
    _tagsController.dispose();
    super.dispose();
  }
}
