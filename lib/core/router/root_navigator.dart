import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/auth/screens/role_selection_screen.dart';
import '../../features/auth/screens/auth_flow_screen.dart';
import '../../features/rider/screens/rider_app.dart';
import '../../features/driver/screens/driver_app.dart';

/// App navigation state
enum AppState {
  splash,
  roleSelection,
  authentication,
  app,
}

/// Root navigator managing app state machine
class RootNavigator extends StatefulWidget {
  const RootNavigator({super.key});

  @override
  State<RootNavigator> createState() => _RootNavigatorState();
}

class _RootNavigatorState extends State<RootNavigator> {
  AppState _currentState = AppState.splash;
  UserRole? _selectedRole;

  @override
  Widget build(BuildContext context) {
    switch (_currentState) {
      case AppState.splash:
        return OnboardingScreen(
          onComplete: () {
            setState(() {
              _currentState = AppState.roleSelection;
            });
          },
        );

      case AppState.roleSelection:
        return RoleSelectionScreen(
          onRoleSelected: (role) {
            setState(() {
              _selectedRole = UserRole.values.firstWhere((e) => e.toString().split('.').last == role);
              _currentState = AppState.authentication;
            });
          },
        );

      case AppState.authentication:
        return AuthFlowScreen(
          role: _selectedRole!,
          onAuthComplete: (userData) {
            // Set user in provider
            final provider = Provider.of<AppProvider>(context, listen: false);
            provider.setUser(userData);
            provider.initializeMockData();

            setState(() {
              _currentState = AppState.app;
            });
          },
        );

      case AppState.app:
        final provider = Provider.of<AppProvider>(context, listen: false);
        final user = provider.user;

        if (user == null) {
          // Shouldn't happen, but handle gracefully
          return const Center(child: CircularProgressIndicator());
        }

        if (user.role == UserRole.rider) {
          return RiderApp(
            onLogout: () {
              provider.clearData();
              setState(() {
                _currentState = AppState.splash;
                _selectedRole = null;
              });
            },
          );
        } else {
          return DriverApp(
            onLogout: () {
              provider.clearData();
              setState(() {
                _currentState = AppState.splash;
                _selectedRole = null;
              });
            },
          );
        }
    }
  }
}