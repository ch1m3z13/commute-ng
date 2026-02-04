import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/models.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/utils/number_utils.dart';
import '../../../widgets/shared_widgets.dart';

class RiderSearchScreen extends StatefulWidget {
  const RiderSearchScreen({super.key});

  @override
  State<RiderSearchScreen> createState() => _RiderSearchScreenState();
}

class _RiderSearchScreenState extends State<RiderSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Ride? _selectedRide;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedRide != null) {
      return _BookingConfirmScreen(
        ride: _selectedRide!,
        onBack: () => setState(() => _selectedRide = null),
      );
    }

    final provider = Provider.of<AppProvider>(context);
    final rides = _searchController.text.isEmpty
        ? provider.availableRides
        : provider.searchRides(_searchController.text);

    return Scaffold(
      backgroundColor: AppColors.slate50,
      body: SafeArea(
        child: Column(
          children: [
            // Search header
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => Navigator.pop(context),
                    color: AppColors.slate600,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.slate100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            size: 18,
                            color: AppColors.slate400,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              autofocus: true,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Where to?',
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Rides list
            Expanded(
              child: rides.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppColors.slate100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.search_off,
                              size: 32,
                              color: AppColors.slate300,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No rides found matching "${_searchController.text}"',
                            style: const TextStyle(
                              color: AppColors.slate400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: rides.length,
                      itemBuilder: (context, index) {
                        final ride = rides[index];
                        return _RideCard(
                          ride: ride,
                          onTap: () => setState(() => _selectedRide = ride),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RideCard extends StatelessWidget {
  final Ride ride;
  final VoidCallback onTap;

  const _RideCard({
    required this.ride,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.slate100),
          boxShadow: AppTheme.shadowSm,
        ),
        child: Column(
          children: [
            // Driver info
            Row(
              children: [
                UserAvatar(
                  name: ride.driverName,
                  verified: ride.driverVerified,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.driverName,
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
                            ride.driverRating.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.slate700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '• ${ride.car}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.slate500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₦${ride.price}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.emerald600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Route details
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
                          border: Border.all(
                            color: AppColors.slate300,
                            width: 2,
                          ),
                          color: AppColors.white,
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 48,
                        color: AppColors.slate200,
                      ),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.emerald500,
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
                      Text(
                        ride.departureTime,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.slate400,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        ride.fromLocation,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.slate900,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        '~1hr',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.slate400,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        ride.toLocation,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.slate900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Footer
            Container(
              padding: const EdgeInsets.only(top: 16),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.slate50),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.emerald50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${ride.availableSeats} seats left',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.emerald600,
                      ),
                    ),
                  ),
                  const Text(
                    'Book →',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.slate400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingConfirmScreen extends StatelessWidget {
  final Ride ride;
  final VoidCallback onBack;

  const _BookingConfirmScreen({
    required this.ride,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.slate50,
      body: Column(
        children: [
          // Map section
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.33,
            child: Stack(
              children: [
                const MockMap(
                  height: double.infinity,
                  showRoute: true,
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IconButton(
                      icon: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.chevron_left,
                          color: AppColors.slate800,
                        ),
                      ),
                      onPressed: onBack,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Booking details
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle
                    Center(
                      child: Container(
                        width: 48,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.slate200,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Confirm Ride',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.slate900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'with ${ride.driverName}',
                              style: const TextStyle(
                                color: AppColors.slate500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '₦${ride.price}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.emerald600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Payment method
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.emerald50.withOpacity(0.5),
                        border: Border.all(color: AppColors.emerald100),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.account_balance_wallet,
                            color: AppColors.emerald600,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Wallet (₦${provider.walletBalance.toLocaleString()})',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColors.slate700,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.emerald600,
                                width: 4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Book button
                    AppButton(
                      text: 'Pay ₦${ride.price} & Book',
                      onPressed: () {
                        final success = provider.bookRide(ride);
                        if (success) {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Ride booked successfully!'),
                              backgroundColor: AppColors.emerald600,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Insufficient funds! Please top up.',
                              ),
                              backgroundColor: AppColors.red500,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        }
                      },
                      fullWidth: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}