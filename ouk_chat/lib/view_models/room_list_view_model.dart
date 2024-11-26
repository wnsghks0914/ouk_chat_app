import 'package:flutter/foundation.dart';
import '../models/room_model.dart';
import '../services/device_service.dart';
import '../services/api_service.dart';

class RoomListViewModel extends ChangeNotifier {
  final DeviceService _deviceService = DeviceService();
  final ApiService _apiService = ApiService();

  List<Room> _rooms = [];
  List<Room> get rooms => _rooms;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchRooms() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userIdentify = await _deviceService.getUniqueDeviceIdentifier();
      _rooms = await _apiService.getRoomsByUser(userIdentify);
    } catch (e) {
      // 에러 처리
      print('Error fetching rooms: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Room> createNewRoom() async {
    try {
      final userIdentify = await _deviceService.getUniqueDeviceIdentifier();
      final newRoom = await _apiService.createRoom(userIdentify);
      _rooms.add(newRoom);
      notifyListeners();
      return newRoom;
    } catch (e) {
      rethrow;
    }
  }
}