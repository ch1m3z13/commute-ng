import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';

class RoleSelectionScreen extends StatelessWidget {
  final Function(String) onRoleSelected;
  const RoleSelectionScreen({super.key, required this.onRoleSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.slate50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How will you use\nCommuteNG?',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.slate900,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You can switch modes later.',
                style: TextStyle(color: AppColors.slate500),
              ),
              const SizedBox(height: 40),
              _RoleCard(
                title: 'I need a ride',
                subtitle: 'Find verified professionals on your route.',
                icon: Icons.person,
                bgColor: AppColors.emerald50,
                iconColor: AppColors.emerald600,
                onTap: () => onRoleSelected('rider'),
              ),
              const SizedBox(height: 16),
              _RoleCard(
                title: 'I have a car',
                subtitle: 'Share your empty seats and earn.',
                icon: Icons.directions_car,
                bgColor: Colors.lime.shade100,
                iconColor: Colors.lime.shade700,
                onTap: () => onRoleSelected('driver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _RoleCard  — animated scale on tap for tactile feedback
// ---------------------------------------------------------------------------
class _RoleCard extends StatefulWidget {
  final String title, subtitle;
  final IconData icon;
  final Color bgColor, iconColor;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    await _ctrl.forward();
    await _ctrl.reverse();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
      child: GestureDetector(
        onTap: _onTap,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.slate100),
            boxShadow: [
              BoxShadow(color: AppColors.slate100, blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.bgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(widget.icon, color: widget.iconColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.slate900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(fontSize: 13, color: AppColors.slate400),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.slate300),
            ],
          ),
        ),
      ),
    );
  }
}
