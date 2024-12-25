import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  LocationPermission? _permission;

  @override
  void initState() {
    super.initState();
    checkAndRequestLocation();
  }

  Future<void> checkAndRequestLocation() async {
    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied) {
        showPermissionDeniedDialog();
        return;
      }
    }
    if (_permission == LocationPermission.deniedForever) {
      showPermissionDeniedDialog(permanentlyDenied: true);
      return;
    }
    getLocation();
  }

  Future<void> getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      print('Location: $position');
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void showPermissionDeniedDialog({bool permanentlyDenied = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Denied'),
        content: Text(
          permanentlyDenied
              ? 'Location permissions are permanently denied. Please enable them from app settings.'
              : 'Location permissions are required for this feature.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          if (permanentlyDenied)
            TextButton(
              onPressed: () {
                Geolocator.openAppSettings();
                Navigator.pop(context);
              },
              child: const Text('Open Settings'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location Example')),
      body: const Center(
        child: ElevatedButton(
          onPressed: null, // Disabled, now auto-requests on init
          child: Text('Get Location'),
        ),
      ),
    );
  }
}
