import 'package:flutter/material.dart';
import '../config/constants.dart';

class LabButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool isSecondary;

  const LabButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isSecondary = false,
  });

  @override
  State<LabButton> createState() => _LabButtonState();
}

class _LabButtonState extends State<LabButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 56,
        decoration: BoxDecoration(
          gradient: widget.onPressed == null && !widget.isLoading
              ? const LinearGradient(colors: [AppColors.border, AppColors.border])
              : widget.isSecondary
                  ? null
                  : AppColors.subtleGradient,
          color: widget.isSecondary ? AppColors.surface : null,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          border: widget.isSecondary
              ? Border.all(color: AppColors.primary, width: 1.5)
              : null,
        ),
        transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          color: widget.isSecondary ? AppColors.primary : Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.text,
                        style: TextStyle(
                          color: widget.isSecondary ? AppColors.primary : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
