import 'package:flutter/material.dart';
import '../config/constants.dart';

class LabCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final bool hasBorder;

  const LabCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        child: Container(
          padding: padding ?? const EdgeInsets.all(AppSizes.paddingMedium),
          decoration: BoxDecoration(
            gradient: AppColors.cardGradient,
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            border: hasBorder
                ? Border.all(color: AppColors.border, width: 1)
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
