// ─── Gradient Button ──────────────────────────────────────────────────────────
import 'package:aula/global/ITColors.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool loading;

  const GradientButton(
      {required this.label, required this.onTap, this.loading = false});

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween(begin: 1.0, end: 0.96)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            gradient: ITColors.gradientAccent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: ITColors.blue500.withOpacity(0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 8)),
            ],
          ),
          child: Center(
            child: widget.loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5))
                : Text(widget.label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        letterSpacing: 0.3)),
          ),
        ),
      ),
    );
  }
}