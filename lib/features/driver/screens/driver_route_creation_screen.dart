import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/models.dart';
import '../../../core/providers/app_provider.dart';
import '../../../widgets/shared_widgets.dart';

class DriverRouteCreationScreen extends StatefulWidget {
  const DriverRouteCreationScreen({super.key});

  @override
  State<DriverRouteCreationScreen> createState() =>
      _DriverRouteCreationScreenState();
}

class _DriverRouteCreationScreenState extends State<DriverRouteCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  String _fromLocation = '';
  String _toLocation = '';
  TimeOfDay? _departureTime;
  String _seats = '';
  String _pricePerSeat = '';
  bool _isLoading = false;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.emerald600,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.slate900,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _departureTime = picked;
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  void _createRoute() async {
    if (!_formKey.currentState!.validate()) return;
    if (_departureTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a departure time'),
          backgroundColor: AppColors.red500,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    final provider = Provider.of<AppProvider>(context, listen: false);
    
    final route = DriverRoute(
      id: 'route_${DateTime.now().millisecondsSinceEpoch}',
      fromLocation: _fromLocation,
      toLocation: _toLocation,
      departureTime: _formatTimeOfDay(_departureTime!),
      totalSeats: int.parse(_seats),
      pricePerSeat: int.parse(_pricePerSeat),
      isActive: true,
    );

    provider.createRoute(route);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Route created successfully!'),
          backgroundColor: AppColors.emerald600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );

      // Simulate incoming request after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          provider.setIncomingRequest(
            RideRequest(
              id: 'req_${DateTime.now().millisecondsSinceEpoch}',
              riderId: 'rider_1',
              riderName: 'Amara N.',
              riderAvatar: 'Amara',
              riderRating: 4.9,
              riderVerified: true,
              pickupLocation: _fromLocation,
              dropoffLocation: _toLocation,
              requestedTime: _formatTimeOfDay(_departureTime!),
              seatsRequested: 1,
              offerPrice: int.parse(_pricePerSeat),
              requestTime: DateTime.now(),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Create Route'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.slate900,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            AppInput(
              label: 'Where from?',
              placeholder: 'Start location',
              icon: Icons.location_on,
              value: _fromLocation,
              onChanged: (value) => setState(() => _fromLocation = value),
            ),
            const SizedBox(height: 20),
            
            AppInput(
              label: 'Where to?',
              placeholder: 'End location',
              icon: Icons.location_on,
              value: _toLocation,
              onChanged: (value) => setState(() => _toLocation = value),
            ),
            const SizedBox(height: 20),
            
            // Time picker
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DEPARTURE TIME',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.slate400,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _selectTime(context),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.slate200,
                        width: 1,
                      ),
                      boxShadow: AppTheme.shadowSm,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          color: AppColors.slate400,
                          size: 20,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            _departureTime != null
                                ? _formatTimeOfDay(_departureTime!)
                                : 'Select departure time',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: _departureTime != null
                                  ? AppColors.slate800
                                  : AppColors.slate300,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: AppColors.slate300,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: AppInput(
                    label: 'Available Seats',
                    placeholder: '3',
                    keyboardType: TextInputType.number,
                    value: _seats,
                    onChanged: (value) => setState(() => _seats = value),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppInput(
                    label: 'Price per Seat',
                    placeholder: '1500',
                    keyboardType: TextInputType.number,
                    icon: Icons.attach_money,
                    value: _pricePerSeat,
                    onChanged: (value) => setState(() => _pricePerSeat = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Info card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.emerald50.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.emerald100),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.emerald100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      size: 20,
                      color: AppColors.emerald700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Your route will be visible to riders on your path. We\'ll notify you of booking requests.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.slate700,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            AppButton(
              text: 'Publish Route',
              onPressed: _createRoute,
              fullWidth: true,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}