import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/models.dart';
import '../../../widgets/shared_widgets.dart';

class AuthFlowScreen extends StatefulWidget {
  final UserRole role;
  final Function(UserProfile) onAuthComplete;

  const AuthFlowScreen({
    super.key,
    required this.role,
    required this.onAuthComplete,
  });

  @override
  State<AuthFlowScreen> createState() => _AuthFlowScreenState();
}

class _AuthFlowScreenState extends State<AuthFlowScreen> {
  int _currentStep = 0;
  bool _isLoading = false;

  // Form data
  String _phone = '';
  final List<String> _otp = ['', '', '', ''];
  String _name = '';
  String _dob = '';
  String _nin = '';
  bool _selfieVerified = false;

  EmploymentVerificationType _employmentType = EmploymentVerificationType.idCard;
  bool _employmentDocUploaded = false;
  String _company = '';
  String _jobTitle = '';
  String _workAddress = '';
  String _workStartTime = '';
  String _workEndTime = '';

  // Driver-specific
  String _vehicleMake = '';
  String _vehicleModel = '';
  String _vehicleYear = '';
  String _vehicleColor = '';
  String _plateNumber = '';
  String _availableSeats = '';

  DriverDocuments _driverDocs = DriverDocuments();

  Future<void> _wait(int milliseconds) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }

  Future<void> _nextStep() async {
    setState(() => _isLoading = true);
    await _wait(1000);
    setState(() => _isLoading = false);

    // Validation
    if (_currentStep == 0) {
      if (_phone.replaceAll(RegExp(r'\D'), '').length != 11) {
        _showError('Phone number must be 11 digits');
        return;
      }
      setState(() => _currentStep++);
    } else if (_currentStep == 1) {
      setState(() => _currentStep++);
    } else if (_currentStep == 2) {
      if (_nin.length != 11) {
        _showError('NIN must be 11 digits');
        return;
      }
      if (!_selfieVerified) {
        _showError('Please complete the live face check');
        return;
      }
      setState(() => _currentStep++);
    } else if (_currentStep == 3) {
      if (widget.role == UserRole.driver) {
        setState(() => _currentStep++);
      } else {
        setState(() => _currentStep = 5); // Skip to review
      }
    } else if (_currentStep == 4) {
      setState(() => _currentStep++);
    } else if (_currentStep == 5) {
      _submitVerification();
    }
  }

  void _submitVerification() {
    final user = UserProfile(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      phone: _phone,
      name: _name,
      dateOfBirth: _dob,
      nin: _nin,
      selfieVerified: _selfieVerified,
      role: widget.role,
      employmentType: _employmentType,
      employmentDocUploaded: _employmentDocUploaded,
      company: _company,
      jobTitle: _jobTitle,
      workAddress: _workAddress,
      workStartTime: _workStartTime,
      workEndTime: _workEndTime,
      vehicle: widget.role == UserRole.driver
          ? VehicleDetails(
              make: _vehicleMake,
              model: _vehicleModel,
              year: _vehicleYear,
              color: _vehicleColor,
              plateNumber: _plateNumber,
              availableSeats: int.tryParse(_availableSeats) ?? 0,
            )
          : null,
      driverDocs: widget.role == UserRole.driver ? _driverDocs : null,
      isVerified: true,
      rating: 4.9,
      totalTrips: 0,
    );

    widget.onAuthComplete(user);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.red500,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            if (_currentStep > 0)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: _previousStep,
                      color: AppColors.slate400,
                    ),
                  ],
                ),
              ),
            Expanded(
              child: _buildCurrentStep(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _PhoneStep(
          phone: _phone,
          onPhoneChanged: (value) => setState(() => _phone = value),
          onNext: _nextStep,
          isLoading: _isLoading,
        );
      case 1:
        return _OTPStep(
          otp: _otp,
          onOtpChanged: (index, value) => setState(() => _otp[index] = value),
          onNext: _nextStep,
          isLoading: _isLoading,
        );
      case 2:
        return _IdentityStep(
          name: _name,
          dob: _dob,
          nin: _nin,
          selfieVerified: _selfieVerified,
          onNameChanged: (value) => setState(() => _name = value),
          onDobChanged: (value) => setState(() => _dob = value),
          onNinChanged: (value) => setState(() => _nin = value),
          onSelfieTaken: () => setState(() => _selfieVerified = true),
          onNext: _nextStep,
          isLoading: _isLoading,
        );
      case 3:
        return _EmploymentStep(
          employmentType: _employmentType,
          employmentDocUploaded: _employmentDocUploaded,
          company: _company,
          jobTitle: _jobTitle,
          workAddress: _workAddress,
          workStartTime: _workStartTime,
          workEndTime: _workEndTime,
          onEmploymentTypeChanged: (value) =>
              setState(() => _employmentType = value),
          onDocUploaded: () => setState(() => _employmentDocUploaded = true),
          onCompanyChanged: (value) => setState(() => _company = value),
          onJobTitleChanged: (value) => setState(() => _jobTitle = value),
          onWorkAddressChanged: (value) => setState(() => _workAddress = value),
          onWorkStartTimeChanged: (value) =>
              setState(() => _workStartTime = value),
          onWorkEndTimeChanged: (value) =>
              setState(() => _workEndTime = value),
          onNext: _nextStep,
          isLoading: _isLoading,
        );
      case 4:
        return _VehicleStep(
          vehicleMake: _vehicleMake,
          vehicleModel: _vehicleModel,
          vehicleYear: _vehicleYear,
          vehicleColor: _vehicleColor,
          plateNumber: _plateNumber,
          availableSeats: _availableSeats,
          driverDocs: _driverDocs,
          onVehicleMakeChanged: (value) => setState(() => _vehicleMake = value),
          onVehicleModelChanged: (value) =>
              setState(() => _vehicleModel = value),
          onVehicleYearChanged: (value) => setState(() => _vehicleYear = value),
          onVehicleColorChanged: (value) =>
              setState(() => _vehicleColor = value),
          onPlateNumberChanged: (value) => setState(() => _plateNumber = value),
          onAvailableSeatsChanged: (value) =>
              setState(() => _availableSeats = value),
          onDocUploaded: (field) {
            setState(() {
              switch (field) {
                case 'license':
                  _driverDocs =
                      _driverDocs.copyWith(licenseUploaded: true);
                  break;
                case 'registration':
                  _driverDocs =
                      _driverDocs.copyWith(registrationUploaded: true);
                  break;
                case 'front':
                  _driverDocs =
                      _driverDocs.copyWith(photoFrontUploaded: true);
                  break;
                case 'rear':
                  _driverDocs =
                      _driverDocs.copyWith(photoRearUploaded: true);
                  break;
                case 'interior':
                  _driverDocs =
                      _driverDocs.copyWith(photoInteriorUploaded: true);
                  break;
              }
            });
          },
          onNext: _nextStep,
          isLoading: _isLoading,
        );
      case 5:
        return _ReviewStep(
          name: _name,
          nin: _nin,
          company: _company,
          jobTitle: _jobTitle,
          workStartTime: _workStartTime,
          workEndTime: _workEndTime,
          role: widget.role,
          vehicle: widget.role == UserRole.driver
              ? VehicleDetails(
                  make: _vehicleMake,
                  model: _vehicleModel,
                  year: _vehicleYear,
                  color: _vehicleColor,
                  plateNumber: _plateNumber,
                  availableSeats: int.tryParse(_availableSeats) ?? 0,
                )
              : null,
          onEditIdentity: () => setState(() => _currentStep = 2),
          onEditEmployment: () => setState(() => _currentStep = 3),
          onEditVehicle: () => setState(() => _currentStep = 4),
          onNext: _nextStep,
          isLoading: _isLoading,
        );
      default:
        return const SizedBox();
    }
  }
}

// STEP 1: Phone Number
class _PhoneStep extends StatelessWidget {
  final String phone;
  final ValueChanged<String> onPhoneChanged;
  final VoidCallback onNext;
  final bool isLoading;

  const _PhoneStep({
    required this.phone,
    required this.onPhoneChanged,
    required this.onNext,
    required this.isLoading,
  });

  String _formatPhone(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length <= 4) return digits;
    if (digits.length <= 7) {
      return '${digits.substring(0, 4)} ${digits.substring(4)}';
    }
    return '${digits.substring(0, 4)} ${digits.substring(4, 7)} ${digits.substring(7, digits.length > 11 ? 11 : digits.length)}';
  }

  @override
  Widget build(BuildContext context) {
    final digits = phone.replaceAll(RegExp(r'\D'), '').length;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What's your number?",
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            "We'll text you a code to verify your account.",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.slate500,
                ),
          ),
          const SizedBox(height: 32),
          AppInput(
            label: 'Phone Number',
            placeholder: '0800 123 4567',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            value: phone,
            maxLength: 13,
            onChanged: (value) => onPhoneChanged(_formatPhone(value)),
          ),
          if (digits > 0 && digits < 11)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 4),
              child: Text(
                '${11 - digits} digits remaining',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.red500,
                ),
              ),
            ),
          const Spacer(),
          AppButton(
            text: 'Continue',
            onPressed: digits == 11 ? onNext : null,
            fullWidth: true,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}

// STEP 2: OTP Verification
class _OTPStep extends StatefulWidget {
  final List<String> otp;
  final Function(int, String) onOtpChanged;
  final VoidCallback onNext;
  final bool isLoading;

  const _OTPStep({
    required this.otp,
    required this.onOtpChanged,
    required this.onNext,
    required this.isLoading,
  });

  @override
  State<_OTPStep> createState() => _OTPStepState();
}

class _OTPStepState extends State<_OTPStep> {
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Verify it's you",
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Enter the 4-digit code sent to your phone.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.slate500,
                ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) {
              return SizedBox(
                width: 56,
                height: 64,
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.slate800,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: AppColors.slate50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.slate100,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.emerald500,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    widget.onOtpChanged(index, value);
                    if (value.isNotEmpty && index < 3) {
                      _focusNodes[index + 1].requestFocus();
                    }
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              );
            }),
          ),
          const Spacer(),
          AppButton(
            text: 'Verify',
            onPressed: widget.onNext,
            fullWidth: true,
            isLoading: widget.isLoading,
          ),
        ],
      ),
    );
  }
}

// STEP 3: Identity Verification
class _IdentityStep extends StatelessWidget {
  final String name;
  final String dob;
  final String nin;
  final bool selfieVerified;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onDobChanged;
  final ValueChanged<String> onNinChanged;
  final VoidCallback onSelfieTaken;
  final VoidCallback onNext;
  final bool isLoading;

  const _IdentityStep({
    required this.name,
    required this.dob,
    required this.nin,
    required this.selfieVerified,
    required this.onNameChanged,
    required this.onDobChanged,
    required this.onNinChanged,
    required this.onSelfieTaken,
    required this.onNext,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Identity Verification',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Government regulations require us to verify your identity.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.slate500,
                ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AppInput(
                    label: 'Full Legal Name',
                    placeholder: 'As on ID card',
                    icon: Icons.person,
                    value: name,
                    onChanged: onNameChanged,
                  ),
                  const SizedBox(height: 20),
                  AppInput(
                    label: 'Date of Birth',
                    placeholder: 'YYYY-MM-DD',
                    icon: Icons.calendar_today,
                    keyboardType: TextInputType.datetime,
                    value: dob,
                    onChanged: onDobChanged,
                  ),
                  const SizedBox(height: 20),
                  AppInput(
                    label: 'NIN (11 Digits)',
                    placeholder: '12345678901',
                    icon: Icons.shield,
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                    value: nin,
                    onChanged: onNinChanged,
                  ),
                  if (nin.isNotEmpty && nin.length < 11)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 4),
                      child: Text(
                        '${11 - nin.length} digits remaining',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.red500,
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  _SelfieCapture(
                    verified: selfieVerified,
                    onCapture: onSelfieTaken,
                    name: name,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'Continue',
            onPressed: selfieVerified && nin.length == 11 ? onNext : null,
            fullWidth: true,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}

class _SelfieCapture extends StatefulWidget {
  final bool verified;
  final VoidCallback onCapture;
  final String name;

  const _SelfieCapture({
    required this.verified,
    required this.onCapture,
    required this.name,
  });

  @override
  State<_SelfieCapture> createState() => _SelfieCaptureState();
}

class _SelfieCaptureState extends State<_SelfieCapture> {
  bool _showCamera = false;
  bool _capturing = false;

  void _startCamera() {
    setState(() {
      _showCamera = true;
      _capturing = true;
    });

    // Simulate capture after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _capturing) {
        setState(() => _capturing = false);
      }
    });
  }

  void _confirmPhoto() {
    widget.onCapture();
    setState(() => _showCamera = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_showCamera) {
      return _CameraView(
        capturing: _capturing,
        name: widget.name,
        onRetake: _startCamera,
        onConfirm: _confirmPhoto,
        onClose: () => setState(() => _showCamera = false),
      );
    }

    if (widget.verified) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.emerald50,
          border: Border.all(color: AppColors.emerald100),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.slate200,
                border: Border.all(color: AppColors.white, width: 2),
              ),
              child: const Icon(Icons.person, size: 32, color: AppColors.slate400),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.check, size: 16, color: AppColors.emerald600),
                      SizedBox(width: 4),
                      Text(
                        'Liveness Verified',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.emerald800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: _startCamera,
                    child: const Text(
                      'Retake Photo',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.emerald600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: _startCamera,
      child: Container(
        height: 192,
        decoration: BoxDecoration(
          color: AppColors.slate900,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.shadowXl,
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt, size: 32, color: AppColors.white),
              SizedBox(height: 8),
              Text(
                'Tap to Start Camera',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Good lighting required',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.slate400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CameraView extends StatelessWidget {
  final bool capturing;
  final String name;
  final VoidCallback onRetake;
  final VoidCallback onConfirm;
  final VoidCallback onClose;

  const _CameraView({
    required this.capturing,
    required this.name,
    required this.onRetake,
    required this.onConfirm,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Mock camera feed
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.slate800,
                borderRadius: BorderRadius.circular(16),
              ),
              child: capturing
                  ? Center(
                      child: Container(
                        width: 200,
                        height: 250,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.white.withOpacity(0.3),
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Stack(
                          children: [
                            // Scanning line
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: const Duration(seconds: 2),
                              builder: (context, value, child) {
                                return Positioned(
                                  top: value * 250,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 4,
                                    decoration: const BoxDecoration(
                                      color: AppColors.emerald500,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.emerald500,
                                          blurRadius: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      size: 200,
                      color: AppColors.slate600,
                    ),
            ),
          ),

          // Top bar
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.white),
                  onPressed: onClose,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    capturing ? 'Face Check' : 'Review',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),

          // Bottom instructions/actions
          if (capturing)
            const Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    'Hold still...',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Position your face in the frame',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.slate400,
                    ),
                  ),
                ],
              ),
            ),

          // Bottom buttons
          Positioned(
            bottom: 32,
            left: 32,
            right: 32,
            child: capturing
                ? Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 4),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  )
                : Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'Retake',
                          variant: ButtonVariant.white,
                          onPressed: onRetake,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: AppButton(
                          text: 'Use Photo',
                          onPressed: onConfirm,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

// STEP 4: Employment Verification
class _EmploymentStep extends StatelessWidget {
  final EmploymentVerificationType employmentType;
  final bool employmentDocUploaded;
  final String company;
  final String jobTitle;
  final String workAddress;
  final String workStartTime;
  final String workEndTime;
  final ValueChanged<EmploymentVerificationType> onEmploymentTypeChanged;
  final VoidCallback onDocUploaded;
  final ValueChanged<String> onCompanyChanged;
  final ValueChanged<String> onJobTitleChanged;
  final ValueChanged<String> onWorkAddressChanged;
  final ValueChanged<String> onWorkStartTimeChanged;
  final ValueChanged<String> onWorkEndTimeChanged;
  final VoidCallback onNext;
  final bool isLoading;

  const _EmploymentStep({
    required this.employmentType,
    required this.employmentDocUploaded,
    required this.company,
    required this.jobTitle,
    required this.workAddress,
    required this.workStartTime,
    required this.workEndTime,
    required this.onEmploymentTypeChanged,
    required this.onDocUploaded,
    required this.onCompanyChanged,
    required this.onJobTitleChanged,
    required this.onWorkAddressChanged,
    required this.onWorkStartTimeChanged,
    required this.onWorkEndTimeChanged,
    required this.onNext,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Employment Check',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Prove you are a 9-to-5 professional.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.slate500,
                ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'VERIFICATION METHOD',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.slate400,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _MethodButton(
                        label: 'Staff ID',
                        isSelected: employmentType == EmploymentVerificationType.idCard,
                        onTap: () => onEmploymentTypeChanged(
                            EmploymentVerificationType.idCard),
                      ),
                      const SizedBox(width: 8),
                      _MethodButton(
                        label: 'Work Email',
                        isSelected: employmentType == EmploymentVerificationType.email,
                        onTap: () => onEmploymentTypeChanged(
                            EmploymentVerificationType.email),
                      ),
                      const SizedBox(width: 8),
                      _MethodButton(
                        label: 'Letter',
                        isSelected: employmentType == EmploymentVerificationType.letter,
                        onTap: () => onEmploymentTypeChanged(
                            EmploymentVerificationType.letter),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _UploadBox(
                    label: employmentType == EmploymentVerificationType.idCard
                        ? 'Staff ID Card'
                        : employmentType == EmploymentVerificationType.email
                            ? 'Work Email'
                            : 'Employment Letter',
                    uploaded: employmentDocUploaded,
                    onUpload: onDocUploaded,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    height: 1,
                    color: AppColors.slate100,
                  ),
                  const SizedBox(height: 24),
                  AppInput(
                    label: 'Company Name',
                    placeholder: 'e.g. Access Bank',
                    icon: Icons.business,
                    value: company,
                    onChanged: onCompanyChanged,
                  ),
                  const SizedBox(height: 20),
                  AppInput(
                    label: 'Job Title',
                    placeholder: 'e.g. Product Designer',
                    icon: Icons.work,
                    value: jobTitle,
                    onChanged: onJobTitleChanged,
                  ),
                  const SizedBox(height: 20),
                  AppInput(
                    label: 'Work Address',
                    placeholder: '12 Adetokunbo Ademola, VI',
                    icon: Icons.location_on,
                    value: workAddress,
                    onChanged: onWorkAddressChanged,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: AppInput(
                          label: 'Start Time',
                          placeholder: '09:00',
                          keyboardType: TextInputType.datetime,
                          value: workStartTime,
                          onChanged: onWorkStartTimeChanged,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppInput(
                          label: 'End Time',
                          placeholder: '17:00',
                          keyboardType: TextInputType.datetime,
                          value: workEndTime,
                          onChanged: onWorkEndTimeChanged,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'Continue',
            onPressed: onNext,
            fullWidth: true,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}

class _MethodButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _MethodButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.emerald600 : AppColors.white,
            border: Border.all(
              color: isSelected ? AppColors.emerald600 : AppColors.slate200,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isSelected ? AppColors.white : AppColors.slate500,
            ),
          ),
        ),
      ),
    );
  }
}

class _UploadBox extends StatelessWidget {
  final String label;
  final bool uploaded;
  final VoidCallback onUpload;

  const _UploadBox({
    required this.label,
    required this.uploaded,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: uploaded ? null : onUpload,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: uploaded ? AppColors.emerald500 : AppColors.slate200,
            width: 2,
            style: BorderStyle.solid,
          ),
          color: uploaded ? AppColors.emerald50 : AppColors.slate50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              uploaded ? Icons.check_circle : Icons.upload_file,
              size: 24,
              color: uploaded ? AppColors.emerald600 : AppColors.slate400,
            ),
            const SizedBox(height: 8),
            Text(
              uploaded ? '$label Uploaded' : 'Upload $label',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: uploaded ? AppColors.emerald700 : AppColors.slate600,
              ),
            ),
            if (!uploaded)
              const Text(
                'Tap to browse',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.slate400,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// STEP 5: Vehicle Details (Driver only)
class _VehicleStep extends StatelessWidget {
  final String vehicleMake;
  final String vehicleModel;
  final String vehicleYear;
  final String vehicleColor;
  final String plateNumber;
  final String availableSeats;
  final DriverDocuments driverDocs;
  final ValueChanged<String> onVehicleMakeChanged;
  final ValueChanged<String> onVehicleModelChanged;
  final ValueChanged<String> onVehicleYearChanged;
  final ValueChanged<String> onVehicleColorChanged;
  final ValueChanged<String> onPlateNumberChanged;
  final ValueChanged<String> onAvailableSeatsChanged;
  final Function(String) onDocUploaded;
  final VoidCallback onNext;
  final bool isLoading;

  const _VehicleStep({
    required this.vehicleMake,
    required this.vehicleModel,
    required this.vehicleYear,
    required this.vehicleColor,
    required this.plateNumber,
    required this.availableSeats,
    required this.driverDocs,
    required this.onVehicleMakeChanged,
    required this.onVehicleModelChanged,
    required this.onVehicleYearChanged,
    required this.onVehicleColorChanged,
    required this.onPlateNumberChanged,
    required this.onAvailableSeatsChanged,
    required this.onDocUploaded,
    required this.onNext,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vehicle Details',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Register your car for approval.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.slate500,
                ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppInput(
                    label: 'Plate Number',
                    placeholder: 'ABC-123-XY',
                    icon: Icons.directions_car,
                    value: plateNumber,
                    onChanged: onPlateNumberChanged,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: AppInput(
                          label: 'Make',
                          placeholder: 'Toyota',
                          value: vehicleMake,
                          onChanged: onVehicleMakeChanged,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppInput(
                          label: 'Model',
                          placeholder: 'Camry',
                          value: vehicleModel,
                          onChanged: onVehicleModelChanged,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: AppInput(
                          label: 'Year',
                          placeholder: '2018',
                          keyboardType: TextInputType.number,
                          value: vehicleYear,
                          onChanged: onVehicleYearChanged,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppInput(
                          label: 'Color',
                          placeholder: 'Silver',
                          value: vehicleColor,
                          onChanged: onVehicleColorChanged,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  AppInput(
                    label: 'Available Seats',
                    placeholder: '3',
                    keyboardType: TextInputType.number,
                    value: availableSeats,
                    onChanged: onAvailableSeatsChanged,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    height: 1,
                    color: AppColors.slate100,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Required Documents',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.slate800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.2,
                    children: [
                      _UploadBox(
                        label: 'License',
                        uploaded: driverDocs.licenseUploaded,
                        onUpload: () => onDocUploaded('license'),
                      ),
                      _UploadBox(
                        label: 'Car Reg',
                        uploaded: driverDocs.registrationUploaded,
                        onUpload: () => onDocUploaded('registration'),
                      ),
                      _UploadBox(
                        label: 'Front View',
                        uploaded: driverDocs.photoFrontUploaded,
                        onUpload: () => onDocUploaded('front'),
                      ),
                      _UploadBox(
                        label: 'Back View',
                        uploaded: driverDocs.photoRearUploaded,
                        onUpload: () => onDocUploaded('rear'),
                      ),
                      _UploadBox(
                        label: 'Interior',
                        uploaded: driverDocs.photoInteriorUploaded,
                        onUpload: () => onDocUploaded('interior'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'Review',
            onPressed: onNext,
            fullWidth: true,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}

// STEP 6: Review & Submit
class _ReviewStep extends StatelessWidget {
  final String name;
  final String nin;
  final String company;
  final String jobTitle;
  final String workStartTime;
  final String workEndTime;
  final UserRole role;
  final VehicleDetails? vehicle;
  final VoidCallback onEditIdentity;
  final VoidCallback onEditEmployment;
  final VoidCallback onEditVehicle;
  final VoidCallback onNext;
  final bool isLoading;

  const _ReviewStep({
    required this.name,
    required this.nin,
    required this.company,
    required this.jobTitle,
    required this.workStartTime,
    required this.workEndTime,
    required this.role,
    this.vehicle,
    required this.onEditIdentity,
    required this.onEditEmployment,
    required this.onEditVehicle,
    required this.onNext,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review & Submit',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Double check your details before submitting for verification.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.slate500,
                ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _ReviewSection(
                    icon: Icons.person,
                    title: 'Identity',
                    onEdit: onEditIdentity,
                    children: [
                      _ReviewItem(label: 'Name', value: name),
                      _ReviewItem(label: 'NIN', value: nin),
                      const _ReviewItem(
                        label: '',
                        value: 'Liveness Checked',
                        isSuccess: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _ReviewSection(
                    icon: Icons.work,
                    title: 'Employment',
                    onEdit: onEditEmployment,
                    children: [
                      _ReviewItem(label: 'Company', value: company),
                      _ReviewItem(label: 'Role', value: jobTitle),
                      _ReviewItem(
                        label: 'Hours',
                        value: '$workStartTime - $workEndTime',
                      ),
                      const _ReviewItem(
                        label: '',
                        value: 'Proof Uploaded',
                        isSuccess: true,
                      ),
                    ],
                  ),
                  if (role == UserRole.driver && vehicle != null) ...[
                    const SizedBox(height: 16),
                    _ReviewSection(
                      icon: Icons.directions_car,
                      title: 'Vehicle',
                      onEdit: onEditVehicle,
                      children: [
                        _ReviewItem(
                          label: '',
                          value:
                              '${vehicle!.color} ${vehicle!.make} ${vehicle!.model} (${vehicle!.year})',
                        ),
                        _ReviewItem(label: '', value: vehicle!.plateNumber),
                        const _ReviewItem(
                          label: '',
                          value: '5 Documents Attached',
                          isSuccess: true,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'Submit for Verification',
            onPressed: onNext,
            fullWidth: true,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}

class _ReviewSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onEdit;
  final List<Widget> children;

  const _ReviewSection({
    required this.icon,
    required this.title,
    required this.onEdit,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.slate700),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.slate800,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onEdit,
                child: const Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.emerald600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 1,
            color: AppColors.slate200,
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isSuccess;

  const _ReviewItem({
    required this.label,
    required this.value,
    this.isSuccess = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: isSuccess
          ? Row(
              children: [
                const Icon(
                  Icons.check,
                  size: 12,
                  color: AppColors.emerald600,
                ),
                const SizedBox(width: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.emerald600,
                  ),
                ),
              ],
            )
          : Row(
              children: [
                if (label.isNotEmpty) ...[
                  Text(
                    '$label: ',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.slate400,
                    ),
                  ),
                ],
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.slate600,
                  ),
                ),
              ],
            ),
    );
  }
}