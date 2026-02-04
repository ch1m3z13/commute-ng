/// Number formatting utilities
library;

extension NumberFormatting on int {
  /// Formats number with thousand separators (e.g., 1000 -> "1,000")
  String toLocaleString() {
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}