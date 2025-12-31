import 'package:connectivity_plus/connectivity_plus.dart';

/// Helper class to check network connectivity status.
/// Provides a singleton instance for easy access.
class NetworkConnectivity {
  static final NetworkConnectivity _singleton = NetworkConnectivity._internal();

  factory NetworkConnectivity() {
    return _singleton;
  }

  NetworkConnectivity._internal();

  /// Check if the device is currently connected to the internet.
  Future<bool> get connected async {
    final result = await Connectivity().checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  /// Check if the device is connected via WiFi.
  Future<bool> get isWifi async {
    final result = await Connectivity().checkConnectivity();
    return result.contains(ConnectivityResult.wifi);
  }

  /// Check if the device is connected via mobile data.
  Future<bool> get isMobile async {
    final result = await Connectivity().checkConnectivity();
    return result.contains(ConnectivityResult.mobile);
  }

  /// Get the current connectivity type(s).
  Future<List<ConnectivityResult>> get connectivityTypes async {
    return await Connectivity().checkConnectivity();
  }

  /// Stream of connectivity changes.
  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return Connectivity().onConnectivityChanged;
  }
}
