import 'package:calculator/features/calculator/models/history_item.dart';
import 'package:get_storage/get_storage.dart';

/// Service handled local data persistence using GetStorage.
class StorageService {
  static final _storage = GetStorage();

  // Storage Keys
  static const String keyPrecision = 'decimal_precision';
  static const String keyHistory = 'calc_history';
  static const String keyIsDarkMode = 'is_dark_mode';

  /// Initializes the GetStorage instance. Must be called in main().
  static Future<void> init() async {
    await GetStorage.init();
  }

  /// Retrieves the saved decimal precision, defaults to 2.
  static int getPrecision() {
    return _storage.read<int>(keyPrecision) ?? 2;
  }

  /// Saves the user's preferred decimal precision.
  static Future<void> savePrecision(int precision) async {
    await _storage.write(keyPrecision, precision);
  }

  /// Retrieves the stored calculation history as structured items.
  static List<HistoryItem> getHistory() {
    final raw = _storage.read<String>(keyHistory);
    if (raw == null) return [];
    try {
      return HistoryItem.decode(raw);
    } catch (e) {
      // Return empty if legacy data format doesn't match
      return [];
    }
  }

  /// Saves the updated calculation history items.
  static Future<void> saveHistory(List<HistoryItem> history) async {
    await _storage.write(keyHistory, HistoryItem.encode(history));
  }

  /// Checks if dark mode was previously enabled, defaults to true.
  static bool isDarkMode() {
    return _storage.read<bool>(keyIsDarkMode) ?? true;
  }

  /// Saves the user's theme preference.
  static Future<void> saveThemeMode(bool isDark) async {
    await _storage.write(keyIsDarkMode, isDark);
  }
}
