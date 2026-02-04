import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/models.dart';
import '../../../core/providers/app_provider.dart';
import '../../../widgets/shared_widgets.dart';

class RiderActiveRideScreen extends StatefulWidget {
  final Booking booking;

  const RiderActiveRideScreen({
    super.key,
    required this.booking,
  });

  @override
  State<RiderActiveRideScreen> createState() => _RiderActiveRideScreenState();
}

class _RiderActiveRideScreenState extends State<RiderActiveRideScreen> {
  String _ridePhase = 'arriving'; // arriving, in_progress

  @override
  void initState() {
    super.initState();
    // Simulate driver arriving then starting trip
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() => _ridePhase = 'in_progress');
        final provider = Provider.of<AppProvider>(context, listen: false);
        provider.startRide(widget.booking);
      }
    });
  }

  void _completeRide() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.completeRide(widget.booking);
    Navigator.popUntil(context, (route) => route.isFirst);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Ride completed successfully!'),
        backgroundColor: AppColors.emerald600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ride = widget.booking.ride;
    final isArriving = _ridePhase == 'arriving';

    return Scaffold(
      backgroundColor: AppColors.slate900,
      body: Stack(
        children: [
          // Map background
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: const MockMap(
                height: double.infinity,
                showCurrentLocation: true,
              ),
            ),
          ),

          // Top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.chevron_left,
                          color: AppColors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.emerald600,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.emerald600.withOpacity(0.2),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.schedule,
                            size: 14,
                            color: AppColors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isArriving
                                ? 'Driver arriving in 5m'
                                : 'On Trip • 15m left',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 300.0, end: 0.0),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, value),
                  child: child,
                );
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 40,
                      offset: Offset(0, -10),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Driver info
                        Row(
                          children: [
                            UserAvatar(
                              name: ride.driverName,
                              size: 72,
                              verified: ride.driverVerified,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ride.driverName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.slate900,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        ride.car,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.slate500,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.slate100,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          ride.plateNumber,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.slate700,
                                            fontFamily: 'monospace',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                color: AppColors.emerald50,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.phone,
                                color: AppColors.emerald600,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Route
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24,
                              child: Column(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isArriving
                                          ? AppColors.emerald500
                                          : AppColors.slate300,
                                    ),
                                  ),
                                  Container(
                                    width: 2,
                                    height: 48,
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    color: AppColors.slate100,
                                  ),
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.slate300,
                                        width: 2,
                                      ),
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'PICKING UP',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.slate400,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    ride.fromLocation,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.slate800,
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  const Text(
                                    'DROPPING OFF',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.slate400,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    ride.toLocation,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.slate800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Safety PIN
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.slate50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.slate100),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Safety PIN',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.slate500,
                                ),
                              ),
                              Text(
                                widget.booking.safetyPin ?? '0000',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.slate900,
                                  fontFamily: 'monospace',
                                  letterSpacing: 4,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Test complete button (for demo)
                        if (!isArriving) ...[
                          const SizedBox(height: 16),
                          AppButton(
                            text: 'Simulate Arrival',
                            variant: ButtonVariant.secondary,
                            onPressed: _completeRide,
                            fullWidth: true,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}