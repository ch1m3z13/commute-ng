/// User role enum
enum UserRole { rider, driver }

/// Employment verification type
enum EmploymentVerificationType { idCard, email, letter }

/// Ride status
enum RideStatus { scheduled, active, completed, cancelled }

/// Drive state for drivers
enum DriveState { idle, scheduled, pickingUp, inProgress, completed }

/// Transaction type
enum TransactionType { credit, debit }

/// User profile model
class UserProfile {
  final String id;
  final String phone;
  final String name;
  final String dateOfBirth;
  final String nin;
  final bool selfieVerified;
  final UserRole role;
  
  // Employment details
  final EmploymentVerificationType employmentType;
  final bool employmentDocUploaded;
  final String company;
  final String jobTitle;
  final String workAddress;
  final String workStartTime;
  final String workEndTime;
  
  // Driver-specific (nullable)
  final VehicleDetails? vehicle;
  final DriverDocuments? driverDocs;
  
  // Status
  final bool isVerified;
  final double rating;
  final int totalTrips;
  
  UserProfile({
    required this.id,
    required this.phone,
    required this.name,
    required this.dateOfBirth,
    required this.nin,
    required this.selfieVerified,
    required this.role,
    required this.employmentType,
    required this.employmentDocUploaded,
    required this.company,
    required this.jobTitle,
    required this.workAddress,
    required this.workStartTime,
    required this.workEndTime,
    this.vehicle,
    this.driverDocs,
    this.isVerified = false,
    this.rating = 0.0,
    this.totalTrips = 0,
  });

  UserProfile copyWith({
    String? id,
    String? phone,
    String? name,
    String? dateOfBirth,
    String? nin,
    bool? selfieVerified,
    UserRole? role,
    EmploymentVerificationType? employmentType,
    bool? employmentDocUploaded,
    String? company,
    String? jobTitle,
    String? workAddress,
    String? workStartTime,
    String? workEndTime,
    VehicleDetails? vehicle,
    DriverDocuments? driverDocs,
    bool? isVerified,
    double? rating,
    int? totalTrips,
  }) {
    return UserProfile(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      nin: nin ?? this.nin,
      selfieVerified: selfieVerified ?? this.selfieVerified,
      role: role ?? this.role,
      employmentType: employmentType ?? this.employmentType,
      employmentDocUploaded: employmentDocUploaded ?? this.employmentDocUploaded,
      company: company ?? this.company,
      jobTitle: jobTitle ?? this.jobTitle,
      workAddress: workAddress ?? this.workAddress,
      workStartTime: workStartTime ?? this.workStartTime,
      workEndTime: workEndTime ?? this.workEndTime,
      vehicle: vehicle ?? this.vehicle,
      driverDocs: driverDocs ?? this.driverDocs,
      isVerified: isVerified ?? this.isVerified,
      rating: rating ?? this.rating,
      totalTrips: totalTrips ?? this.totalTrips,
    );
  }
}

/// Vehicle details for drivers
class VehicleDetails {
  final String make;
  final String model;
  final String year;
  final String color;
  final String plateNumber;
  final int availableSeats;

  VehicleDetails({
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.plateNumber,
    required this.availableSeats,
  });

  VehicleDetails copyWith({
    String? make,
    String? model,
    String? year,
    String? color,
    String? plateNumber,
    int? availableSeats,
  }) {
    return VehicleDetails(
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      color: color ?? this.color,
      plateNumber: plateNumber ?? this.plateNumber,
      availableSeats: availableSeats ?? this.availableSeats,
    );
  }
}

/// Driver documents
class DriverDocuments {
  final bool licenseUploaded;
  final bool registrationUploaded;
  final bool photoFrontUploaded;
  final bool photoRearUploaded;
  final bool photoInteriorUploaded;

  DriverDocuments({
    this.licenseUploaded = false,
    this.registrationUploaded = false,
    this.photoFrontUploaded = false,
    this.photoRearUploaded = false,
    this.photoInteriorUploaded = false,
  });

  bool get allUploaded =>
      licenseUploaded &&
      registrationUploaded &&
      photoFrontUploaded &&
      photoRearUploaded &&
      photoInteriorUploaded;

  DriverDocuments copyWith({
    bool? licenseUploaded,
    bool? registrationUploaded,
    bool? photoFrontUploaded,
    bool? photoRearUploaded,
    bool? photoInteriorUploaded,
  }) {
    return DriverDocuments(
      licenseUploaded: licenseUploaded ?? this.licenseUploaded,
      registrationUploaded: registrationUploaded ?? this.registrationUploaded,
      photoFrontUploaded: photoFrontUploaded ?? this.photoFrontUploaded,
      photoRearUploaded: photoRearUploaded ?? this.photoRearUploaded,
      photoInteriorUploaded: photoInteriorUploaded ?? this.photoInteriorUploaded,
    );
  }
}

/// Ride model (for riders searching for rides)
class Ride {
  final String id;
  final String driverId;
  final String driverName;
  final String driverAvatar;
  final double driverRating;
  final bool driverVerified;
  final String car;
  final String plateNumber;
  final int availableSeats;
  final int price;
  final String departureTime;
  final String fromLocation;
  final String toLocation;

  Ride({
    required this.id,
    required this.driverId,
    required this.driverName,
    required this.driverAvatar,
    required this.driverRating,
    required this.driverVerified,
    required this.car,
    required this.plateNumber,
    required this.availableSeats,
    required this.price,
    required this.departureTime,
    required this.fromLocation,
    required this.toLocation,
  });

  Ride copyWith({
    String? id,
    String? driverId,
    String? driverName,
    String? driverAvatar,
    double? driverRating,
    bool? driverVerified,
    String? car,
    String? plateNumber,
    int? availableSeats,
    int? price,
    String? departureTime,
    String? fromLocation,
    String? toLocation,
  }) {
    return Ride(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverAvatar: driverAvatar ?? this.driverAvatar,
      driverRating: driverRating ?? this.driverRating,
      driverVerified: driverVerified ?? this.driverVerified,
      car: car ?? this.car,
      plateNumber: plateNumber ?? this.plateNumber,
      availableSeats: availableSeats ?? this.availableSeats,
      price: price ?? this.price,
      departureTime: departureTime ?? this.departureTime,
      fromLocation: fromLocation ?? this.fromLocation,
      toLocation: toLocation ?? this.toLocation,
    );
  }
}

/// Booking model (rider's booked rides)
class Booking {
  final String id;
  final Ride ride;
  final RideStatus status;
  final DateTime bookingTime;
  final String? safetyPin;

  Booking({
    required this.id,
    required this.ride,
    required this.status,
    required this.bookingTime,
    this.safetyPin,
  });

  Booking copyWith({
    String? id,
    Ride? ride,
    RideStatus? status,
    DateTime? bookingTime,
    String? safetyPin,
  }) {
    return Booking(
      id: id ?? this.id,
      ride: ride ?? this.ride,
      status: status ?? this.status,
      bookingTime: bookingTime ?? this.bookingTime,
      safetyPin: safetyPin ?? this.safetyPin,
    );
  }
}

/// Driver route model
class DriverRoute {
  final String id;
  final String fromLocation;
  final String toLocation;
  final String departureTime;
  final int totalSeats;
  final int bookedSeats;
  final int pricePerSeat;
  final bool isActive;

  DriverRoute({
    required this.id,
    required this.fromLocation,
    required this.toLocation,
    required this.departureTime,
    required this.totalSeats,
    this.bookedSeats = 0,
    required this.pricePerSeat,
    this.isActive = true,
  });

  int get availableSeats => totalSeats - bookedSeats;

  DriverRoute copyWith({
    String? id,
    String? fromLocation,
    String? toLocation,
    String? departureTime,
    int? totalSeats,
    int? bookedSeats,
    int? pricePerSeat,
    bool? isActive,
  }) {
    return DriverRoute(
      id: id ?? this.id,
      fromLocation: fromLocation ?? this.fromLocation,
      toLocation: toLocation ?? this.toLocation,
      departureTime: departureTime ?? this.departureTime,
      totalSeats: totalSeats ?? this.totalSeats,
      bookedSeats: bookedSeats ?? this.bookedSeats,
      pricePerSeat: pricePerSeat ?? this.pricePerSeat,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// Ride request (for drivers receiving booking requests)
class RideRequest {
  final String id;
  final String riderId;
  final String riderName;
  final String riderAvatar;
  final double riderRating;
  final bool riderVerified;
  final String pickupLocation;
  final String dropoffLocation;
  final String requestedTime;
  final int seatsRequested;
  final int offerPrice;
  final DateTime requestTime;

  RideRequest({
    required this.id,
    required this.riderId,
    required this.riderName,
    required this.riderAvatar,
    required this.riderRating,
    required this.riderVerified,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.requestedTime,
    required this.seatsRequested,
    required this.offerPrice,
    required this.requestTime,
  });

  RideRequest copyWith({
    String? id,
    String? riderId,
    String? riderName,
    String? riderAvatar,
    double? riderRating,
    bool? riderVerified,
    String? pickupLocation,
    String? dropoffLocation,
    String? requestedTime,
    int? seatsRequested,
    int? offerPrice,
    DateTime? requestTime,
  }) {
    return RideRequest(
      id: id ?? this.id,
      riderId: riderId ?? this.riderId,
      riderName: riderName ?? this.riderName,
      riderAvatar: riderAvatar ?? this.riderAvatar,
      riderRating: riderRating ?? this.riderRating,
      riderVerified: riderVerified ?? this.riderVerified,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      requestedTime: requestedTime ?? this.requestedTime,
      seatsRequested: seatsRequested ?? this.seatsRequested,
      offerPrice: offerPrice ?? this.offerPrice,
      requestTime: requestTime ?? this.requestTime,
    );
  }
}

/// Transaction model
class Transaction {
  final String id;
  final String title;
  final String date;
  final int amount;
  final TransactionType type;

  Transaction({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.type,
  });

  Transaction copyWith({
    String? id,
    String? title,
    String? date,
    int? amount,
    TransactionType? type,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      type: type ?? this.type,
    );
  }
}