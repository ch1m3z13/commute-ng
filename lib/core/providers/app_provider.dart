import 'package:flutter/foundation.dart';
import '../models/models.dart';

class AppProvider with ChangeNotifier {
  // User state
  UserProfile? _user;
  UserProfile? get user => _user;

  // Wallet
  int _walletBalance = 12500; // Default starting balance
  int get walletBalance => _walletBalance;

  // Available rides (for riders)
  List<Ride> _availableRides = [];
  List<Ride> get availableRides => _availableRides;

  // User's bookings (for riders)
  List<Booking> _myBookings = [];
  List<Booking> get myBookings => _myBookings;

  // Driver's routes
  List<DriverRoute> _myRoutes = [];
  List<DriverRoute> get myRoutes => _myRoutes;

  // Incoming ride requests (for drivers)
  RideRequest? _incomingRequest;
  RideRequest? get incomingRequest => _incomingRequest;

  // Drive state (for drivers)
  DriveState _driveState = DriveState.idle;
  DriveState get driveState => _driveState;

  // Transactions
  List<Transaction> _transactions = [];
  List<Transaction> get transactions => _transactions;

  // Active booking (current ride in progress)
  Booking? _activeBooking;
  Booking? get activeBooking => _activeBooking;

  /// Initialize app with mock data
  void initializeMockData() {
    _availableRides = [
      Ride(
        id: 'r1',
        driverId: 'd1',
        driverName: 'Tunde Bakare',
        driverAvatar: 'Tunde',
        driverRating: 4.8,
        driverVerified: true,
        car: 'Honda Civic',
        plateNumber: 'LND-123-AA',
        availableSeats: 3,
        price: 1200,
        departureTime: '07:15 AM',
        fromLocation: 'Maryland Mall',
        toLocation: 'Victoria Island',
      ),
      Ride(
        id: 'r2',
        driverId: 'd2',
        driverName: 'Sarah J.',
        driverAvatar: 'Sarah',
        driverRating: 5.0,
        driverVerified: true,
        car: 'Hyundai Tucson',
        plateNumber: 'ABJ-456-YZ',
        availableSeats: 1,
        price: 1500,
        departureTime: '07:30 AM',
        fromLocation: 'Ikeja City Mall',
        toLocation: 'Lekki Phase 1',
      ),
      Ride(
        id: 'r3',
        driverId: 'd3',
        driverName: 'Emmanuel Kalu',
        driverAvatar: 'Emmanuel',
        driverRating: 4.6,
        driverVerified: false,
        car: 'Toyota Corolla',
        plateNumber: 'KJA-789-BB',
        availableSeats: 2,
        price: 1000,
        departureTime: '06:45 AM',
        fromLocation: 'Surulere',
        toLocation: 'Marina',
      ),
    ];

    _transactions = [
      Transaction(
        id: 't1',
        title: 'Top Up',
        date: 'Today, 9:00 AM',
        amount: 5000,
        type: TransactionType.credit,
      ),
      Transaction(
        id: 't2',
        title: 'Ride to VI',
        date: 'Yesterday',
        amount: -1200,
        type: TransactionType.debit,
      ),
    ];

    notifyListeners();
  }

  /// Set user profile after authentication
  void setUser(UserProfile user) {
    _user = user;
    notifyListeners();
  }

  /// Update user profile
  void updateUser(UserProfile updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }

  /// Top up wallet
  void topUpWallet(int amount) {
    _walletBalance += amount;
    _transactions.insert(
      0,
      Transaction(
        id: 't_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Top Up',
        date: 'Just now',
        amount: amount,
        type: TransactionType.credit,
      ),
    );
    notifyListeners();
  }

  /// Book a ride (for riders)
  bool bookRide(Ride ride) {
    if (_walletBalance < ride.price) {
      return false; // Insufficient funds
    }

    // Deduct from wallet
    _walletBalance -= ride.price;

    // Add transaction
    _transactions.insert(
      0,
      Transaction(
        id: 't_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Ride with ${ride.driverName}',
        date: 'Just now',
        amount: -ride.price,
        type: TransactionType.debit,
      ),
    );

    // Create booking
    final booking = Booking(
      id: 'b_${DateTime.now().millisecondsSinceEpoch}',
      ride: ride,
      status: RideStatus.scheduled,
      bookingTime: DateTime.now(),
      safetyPin: _generateSafetyPin(),
    );

    _myBookings.insert(0, booking);
    _activeBooking = booking;

    notifyListeners();
    return true;
  }

  /// Generate random 4-digit safety PIN
  String _generateSafetyPin() {
    return (1000 + (DateTime.now().millisecondsSinceEpoch % 9000)).toString();
  }

  /// Start active ride
  void startRide(Booking booking) {
    final index = _myBookings.indexWhere((b) => b.id == booking.id);
    if (index != -1) {
      _myBookings[index] = booking.copyWith(status: RideStatus.active);
      _activeBooking = _myBookings[index];
      notifyListeners();
    }
  }

  /// Complete ride
  void completeRide(Booking booking) {
    final index = _myBookings.indexWhere((b) => b.id == booking.id);
    if (index != -1) {
      _myBookings[index] = booking.copyWith(status: RideStatus.completed);
      _activeBooking = null;
      notifyListeners();
    }
  }

  /// Cancel ride
  void cancelRide(Booking booking) {
    final index = _myBookings.indexWhere((b) => b.id == booking.id);
    if (index != -1) {
      // Refund to wallet
      _walletBalance += booking.ride.price;

      // Add refund transaction
      _transactions.insert(
        0,
        Transaction(
          id: 't_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Ride Cancelled - Refund',
          date: 'Just now',
          amount: booking.ride.price,
          type: TransactionType.credit,
        ),
      );

      _myBookings[index] = booking.copyWith(status: RideStatus.cancelled);
      if (_activeBooking?.id == booking.id) {
        _activeBooking = null;
      }
      notifyListeners();
    }
  }

  /// Create driver route
  void createRoute(DriverRoute route) {
    _myRoutes.insert(0, route);
    notifyListeners();
  }

  /// Update driver route
  void updateRoute(DriverRoute updatedRoute) {
    final index = _myRoutes.indexWhere((r) => r.id == updatedRoute.id);
    if (index != -1) {
      _myRoutes[index] = updatedRoute;
      notifyListeners();
    }
  }

  /// Delete driver route
  void deleteRoute(String routeId) {
    _myRoutes.removeWhere((r) => r.id == routeId);
    notifyListeners();
  }

  /// Set incoming ride request (for drivers)
  void setIncomingRequest(RideRequest? request) {
    _incomingRequest = request;
    notifyListeners();
  }

  /// Accept ride request (for drivers)
  void acceptRideRequest(RideRequest request) {
    // Update route with booked seat
    if (_myRoutes.isNotEmpty) {
      final route = _myRoutes[0];
      updateRoute(route.copyWith(
        bookedSeats: route.bookedSeats + request.seatsRequested,
      ));
    }

    // Clear incoming request
    _incomingRequest = null;

    // Set drive state to scheduled
    _driveState = DriveState.scheduled;

    notifyListeners();
  }

  /// Decline ride request (for drivers)
  void declineRideRequest() {
    _incomingRequest = null;
    notifyListeners();
  }

  /// Update drive state
  void setDriveState(DriveState state) {
    _driveState = state;
    notifyListeners();
  }

  /// Complete driver commute and add earnings
  void completeDriverCommute(int earnings) {
    _walletBalance += earnings;

    _transactions.insert(
      0,
      Transaction(
        id: 't_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Ride Earnings',
        date: 'Just now',
        amount: earnings,
        type: TransactionType.credit,
      ),
    );

    // Update user stats if driver
    if (_user != null && _user!.role == UserRole.driver) {
      _user = _user!.copyWith(
        totalTrips: _user!.totalTrips + 1,
      );
    }

    // Reset drive state
    _driveState = DriveState.idle;
    _incomingRequest = null;

    notifyListeners();
  }

  /// Search rides by location
  List<Ride> searchRides(String query) {
    if (query.isEmpty) return _availableRides;

    final lowerQuery = query.toLowerCase();
    return _availableRides.where((ride) {
      return ride.fromLocation.toLowerCase().contains(lowerQuery) ||
          ride.toLocation.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Clear all data (for logout)
  void clearData() {
    _user = null;
    _walletBalance = 0;
    _availableRides = [];
    _myBookings = [];
    _myRoutes = [];
    _incomingRequest = null;
    _driveState = DriveState.idle;
    _transactions = [];
    _activeBooking = null;
    notifyListeners();
  }

  /// Reset to initial state
  void reset() {
    clearData();
    _walletBalance = 12500;
    initializeMockData();
  }
}