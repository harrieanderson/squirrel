import 'package:shared_preferences/shared_preferences.dart';

const String userIdKey = 'USERKEY';
const String userNameKey = 'USERNAMEKEY';
const String displayNameKey = 'USERDISPLAYNAMEKEY';
const String userEmailKey = 'USEREMAILKEY';
const String userProfilePicKey = 'USERPROFILEPICKEY';

class SharedPreferenceHelper {
  static final instance = SharedPreferenceHelper._();

  String? userName;
  String? email;
  String? userId;
  String? displayName;
  String? userProfileUrl;

  SharedPreferenceHelper._();

  factory SharedPreferenceHelper() => instance;

  Future<void> initialise() async {
    await Future.wait([
      getUserName().then((value) => userName = value),
      getUserEmail().then((value) => email = value),
      getUserId().then((value) => userId = value),
      getDisplayName().then((value) => displayName = value),
      getUserProfileUrl().then((value) => userProfileUrl),
    ]);
  }

  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, getUserName);
  }

  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getUserEmail);
  }

  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

  Future<bool> saveDisplayName(String getDisplayName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(displayNameKey, getDisplayName);
  }

  Future<bool> saveUserProfileUrl(String getUserProfile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userProfilePicKey, getUserProfile);
  }

  // get data
  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<String?> getDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(displayNameKey);
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getUserProfileUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userProfilePicKey);
  }
}
