import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/models.dart';
import '../../../core/providers/app_provider.dart';
import '../../../widgets/shared_widgets.dart';
import 'driver_route_creation_screen.dart';
import 'driver_request_review_screen.dart';
import 'driver_driving_screen.dart';

class DriverApp extends StatefulWidget {
  final VoidCallback onLogout;

  const DriverApp({
    super.key,
    required this.onLogout,
  });

  @override
  State<DriverApp> createState() => _DriverAppState();
}

class _DriverAppState extends State<DriverApp> {
  @override
  void initState() {
    super.initState();
    // Listen for incoming requests
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForIncomingRequests();
    });
  }

  void _checkForIncomingRequests() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.addListener(_handleProviderUpdate);
  }

  void _handleProviderUpdate() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final request = provider.incomingRequest;
    
    if (request != null && provider.driveState == DriveState.idle) {
      // Show request notification
      _showRequestNotification(request);
    }
  }

  void _showRequestNotification(RideRequest request) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            UserAvatar(
              name: request.riderName,
              size: 32,
              verified: request.riderVerified,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'New Ride Request',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    'Pick up ${request.riderName} • ₦${request.offerPrice}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.slate900,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'VIEW',
          textColor: AppColors.emerald400,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DriverRequestReviewScreen(request: request),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.removeListener(_handleProviderUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final user = provider.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.slate50,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.slate900,
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Top bar
                      Row(
                        children: [
                          GestureDetector(
                            onTap: widget.onLogout,
                            child: Row(
                              children: [
                                UserAvatar(
                                  name: user.name,
                                  size: 32,
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Driver Mode',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 14,
                                  color: AppColors.amber400,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  user.rating.toString(),
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
                      const SizedBox(height: 32),

                      // Earnings
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Today's Earnings",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.slate400,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '₦0.00',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.white,
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'View History',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.emerald400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Quick stats
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.white.withOpacity(0.1),
                                ),
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reliability',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.slate400,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'High',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.emerald400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.white.withOpacity(0.1),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Trips',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.slate400,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user.totalTrips.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Main content
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Empty state
                if (provider.myRoutes.isEmpty) ...[
                  const SizedBox(height: 32),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.emerald50,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.map,
                            size: 32,
                            color: AppColors.emerald600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Where are you driving?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.slate900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Set your daily home-work route to start\ngetting matched with riders.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.slate500,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        AppButton(
                          text: 'Create Your Daily Route',
                          icon: Icons.add,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DriverRouteCreationScreen(),
                              ),
                            );
                          },
                          fullWidth: true,
                        ),
                      ],
                    ),
                  ),
                ],
                
                // Route card if exists
                if (provider.myRoutes.isNotEmpty) ...[
                  const Text(
                    "Today's Commute",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.slate800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _RouteCard(
                    route: provider.myRoutes[0],
                    driveState: provider.driveState,
                    request: provider.incomingRequest,
                    onStartCommute: () {
                      if (provider.incomingRequest != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DriverDrivingScreen(
                              request: provider.incomingRequest!,
                            ),
                          ),
                        );
                      }
                    },
                    onManage: () {
                      // TODO: Navigate to manage route
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Info card
                  if (provider.driveState == DriveState.idle) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.slate50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.slate100),
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
                              Icons.notifications_active,
                              size: 16,
                              color: AppColors.emerald600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Your route is live. We\'ll notify you when a rider on your path requests a seat.',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.slate900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],

                // Quick actions
                const SizedBox(height: 32),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    _QuickAction(
                      icon: Icons.add,
                      label: 'New Route',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DriverRouteCreationScreen(),
                          ),
                        );
                      },
                    ),
                    _QuickAction(
                      icon: Icons.person,
                      label: 'Riders',
                      onTap: () {},
                    ),
                    _QuickAction(
                      icon: Icons.schedule,
                      label: 'Availability',
                      onTap: () {},
                    ),
                    _QuickAction(
                      icon: Icons.lock,
                      label: 'Pause',
                      onTap: () {},
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.slate100),
              boxShadow: AppTheme.shadowSm,
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppColors.slate600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.slate500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  final DriverRoute route;
  final DriveState driveState;
  final RideRequest? request;
  final VoidCallback onStartCommute;
  final VoidCallback onManage;

  const _RouteCard({
    required this.route,
    required this.driveState,
    this.request,
    required this.onStartCommute,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    final isScheduled = driveState == DriveState.scheduled;
    final borderColor = isScheduled ? AppColors.amber500 : AppColors.emerald500;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate100),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isScheduled
                      ? AppColors.amber500
                      : AppColors.emerald50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isScheduled
                      ? 'PASSENGER CONFIRMED'
                      : 'SCHEDULED • ${route.departureTime}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isScheduled
                        ? AppColors.amber600
                        : AppColors.emerald600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, size: 18),
                color: AppColors.slate400,
                onPressed: onManage,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Route
          Text(
            '${route.fromLocation} → ${route.toLocation}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.slate900,
            ),
          ),
          const SizedBox(height: 16),

          // Passengers
          Row(
            children: [
              // Avatar circles
              SizedBox(
                width: 80,
                height: 32,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.slate200,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 2),
                        ),
                      ),
                    ),
                    if (isScheduled && request != null)
                      Positioned(
                        left: 24,
                        child: UserAvatar(
                          name: request!.riderName,
                          size: 32,
                        ),
                      )
                    else
                      Positioned(
                        left: 24,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.slate50,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.white,
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 14,
                            color: AppColors.slate300,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                isScheduled
                    ? '1 Rider Confirmed'
                    : 'Waiting for riders...',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.slate500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Actions
          if (isScheduled)
            AppButton(
              text: 'Start Commute',
              onPressed: onStartCommute,
              fullWidth: true,
            )
          else
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Manage',
                    variant: ButtonVariant.secondary,
                    onPressed: onManage,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.slate100),
                  ),
                  child: const Icon(
                    Icons.settings,
                    size: 18,
                    color: AppColors.slate400,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}