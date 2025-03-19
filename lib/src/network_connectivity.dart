import 'package:connectivity_plus/connectivity_plus.dart';


/// Checking if the device is connected to the internet.
class NetworkConnectivity {
  static final NetworkConnectivity _singleton = NetworkConnectivity._internal();

  factory NetworkConnectivity() {
    return _singleton;
  }

  NetworkConnectivity._internal();

  Future<bool> get connected async => !(await (Connectivity().checkConnectivity())).contains(ConnectivityResult.none);
}
