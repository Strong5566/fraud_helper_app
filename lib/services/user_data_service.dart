class UserDataService {
  static final UserDataService _instance = UserDataService._internal();
  factory UserDataService() => _instance;
  UserDataService._internal();

  String? _userName;
  String? _imagePath;

  void setUserName(String name) {
    _userName = name;
  }

  void setImagePath(String path) {
    _imagePath = path;
  }

  String? get userName => _userName;
  String? get imagePath => _imagePath;

  void clear() {
    _userName = null;
    _imagePath = null;
  }
}