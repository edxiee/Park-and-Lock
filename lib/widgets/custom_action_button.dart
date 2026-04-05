import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;
  final VoidCallback? onPressed;

  const CustomActionButton({
    super.key,
    required this.label,
    required this.bgColor,
    required this.textColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          disabledBackgroundColor: bgColor.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            color: onPressed == null ? textColor.withValues(alpha: 0.5) : textColor,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
