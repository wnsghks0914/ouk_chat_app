import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceService {
  Future<String> getUniqueDeviceIdentifier() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? '';
      }

      throw Exception('Unsupported platform');
    } catch (e) {
      print('Device ID Error: $e');
      return 'unknown_device';
    }
  }
}