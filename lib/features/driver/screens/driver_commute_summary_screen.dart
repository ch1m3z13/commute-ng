import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/number_utils.dart';
import '../../../widgets/shared_widgets.dart';

class DriverCommuteSummaryScreen extends StatelessWidget {
  final int earnings;

  const DriverCommuteSummaryScreen({
    super.key,
    required this.earnings,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.emerald600,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Success icon
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 48,
                        color: AppColors.emerald600,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Title
              const Text(
                'Commute Complete!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 12),
              
              const Text(
                'You helped a commuter and earned money.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.emerald100,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Earnings card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.white.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'TOTAL EARNINGS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.emerald200,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₦${earnings.toLocaleString()}',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Reliability score
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.white.withOpacity(0.2),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reliability Score',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.trending_up,
                          size: 16,
                          color: AppColors.lime400,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '+2 pts',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.lime400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Back button
              AppButton(
                text: 'Back to Dashboard',
                variant: ButtonVariant.white,
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}