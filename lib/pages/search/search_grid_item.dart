import 'package:flutter/material.dart';

class AnimatedGridItem extends StatefulWidget {
  final Widget child;
  final int index;
  const AnimatedGridItem({super.key, required this.child, required this.index});

  @override
  State<AnimatedGridItem> createState() => _AnimatedGridItemState();
}

class _AnimatedGridItemState extends State<AnimatedGridItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

    final delay = (widget.index * 40).clamp(0, 300);
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(_anim),
        child: widget.child,
      ),
    );
  }
}
