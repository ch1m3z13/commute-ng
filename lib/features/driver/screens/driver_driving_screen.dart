import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/models.dart';
import '../../../core/providers/app_provider.dart';
import '../../../widgets/shared_widgets.dart';
import 'driver_commute_summary_screen.dart';

class DriverDrivingScreen extends StatefulWidget {
  final RideRequest request;

  const DriverDrivingScreen({
    super.key,
    required this.request,
  });

  @override
  State<DriverDrivingScreen> createState() => _DriverDrivingScreenState();
}

class _DriverDrivingScreenState extends State<DriverDrivingScreen> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AppProvider>(context, listen: false);
    // Start with picking up state
    provider.setDriveState(DriveState.pickingUp);
  }

  void _handleConfirmPickup() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.setDriveState(DriveState.inProgress);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Pickup confirmed'),
        backgroundColor: AppColors.emerald600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _handleCompleteCommute() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.completeDriverCommute(widget.request.offerPrice);
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DriverCommuteSummaryScreen(
          earnings: widget.request.offerPrice,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final driveState = provider.driveState;
    final isPickingUp = driveState == DriveState.pickingUp;

    return Scaffold(
      body: Stack(
        children: [
          // Map
          const Positioned.fill(
            child: MockMap(
              height: double.infinity,
              showCurrentLocation: true,
              showRoute: true,
            ),
          ),

          // Top HUD
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.emerald600,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.emerald900.withOpacity(0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: AppColors.emerald600,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '200m',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.emerald100,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Turn right at Ozumba Mbadiwe',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                                height: 1.2,
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
          ),

          // Bottom action sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
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
                      // Stop info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isPickingUp ? 'NEXT STOP' : 'DROP OFF',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.slate400,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isPickingUp
                                    ? 'Pick up ${widget.request.riderName.split(' ')[0]}'
                                    : 'Drop off ${widget.request.riderName.split(' ')[0]}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.slate900,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: AppColors.emerald100,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text(
                                '2m',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.emerald700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Passenger info
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.slate50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            UserAvatar(
                              name: widget.request.riderName,
                              verified: widget.request.riderVerified,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.request.riderName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.slate900,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 12,
                                        color: AppColors.amber400,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        widget.request.riderRating.toString(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.slate700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: AppColors.emerald100,
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
                      ),
                      const SizedBox(height: 16),

                      // Action buttons
                      if (isPickingUp)
                        AppButton(
                          text: 'Confirm Pickup',
                          onPressed: _handleConfirmPickup,
                          fullWidth: true,
                        )
                      else
                        AppButton(
                          text: 'Complete Commute',
                          onPressed: _handleCompleteCommute,
                          fullWidth: true,
                        ),
                      const SizedBox(height: 12),

                      // Cancel button
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Cancel Ride?'),
                              content: const Text(
                                'Are you sure you want to cancel this ride?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close dialog
                                    Navigator.pop(context); // Close driving screen
                                    final provider = Provider.of<AppProvider>(
                                      context,
                                      listen: false,
                                    );
                                    provider.setDriveState(DriveState.idle);
                                    provider.setIncomingRequest(null);
                                  },
                                  child: const Text(
                                    'Yes, Cancel',
                                    style: TextStyle(color: AppColors.red500),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text(
                          'Report Issue / Cancel Ride',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.slate400,
                          ),
                        ),
                      ),
                    ],
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