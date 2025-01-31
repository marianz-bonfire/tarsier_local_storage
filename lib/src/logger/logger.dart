import 'package:flutter/foundation.dart';

enum DebugType { error, info, warning, success, verbose }

/// Terminal color codes for styled log outputs.
/// These ANSI escape codes enable text formatting in the console.
const green = '\x1B[32m';
const red = '\x1B[31m';
const blue = '\x1B[36m';
const yellow = '\x1B[33m';
const reset = '\x1B[0m';

const greenBg = '\x1B[48;5;10m';
const redBg = '\x1B[48;5;9m';
const blueBg = '\x1B[48;5;12m';
const lightBlueBg = '\x1B[48;5;117m';
const yellowBg = '\x1B[48;5;11m';

class Logger {
  static String _formatInBrackets(String text, [int width = 8]) {
    int padding =
        (width - text.length) ~/ 2; // Calculate spaces needed on both sides
    String paddedText = text.padLeft(text.length + padding).padRight(width);
    return "[$paddedText]"; // Enclose in brackets
  }

  static void _printDebug(Object? object) {
    if (kDebugMode) {
      print(object);
    }
  }

  // Logs a message only when in debug mode
  static void log(String tag, String message,
      {DebugType type = DebugType.verbose}) {
    if (type == DebugType.info) {
      info(message);
    } else if (type == DebugType.success) {
      success(message);
    } else if (type == DebugType.warning) {
      warn(message);
    } else if (type == DebugType.error) {
      error(message);
    } else {
      _printDebug('$reset${"${_formatInBrackets(tag)}: $message"}$reset');
    }
  }

  // Logs an error message with optional stack trace
  static void error(String message, [StackTrace? stackTrace]) {
    _printDebug('$red${"${_formatInBrackets('ERROR')}: $message"}$reset');

    if (stackTrace != null) {
      _printDebug('$reset$stackTrace$reset');
    }
  }

  // Logs a warning message
  static void warn(String message) {
    _printDebug('$yellow${"${_formatInBrackets('WARNING')}: $message"}$reset');
  }

  // Logs an info message
  static void info(String message) {
    _printDebug('$blue${"${_formatInBrackets('INFO')}: $message"}$reset');
  }

  // Logs an info success
  static void success(String message) {
    _printDebug('$green${"${_formatInBrackets('SUCCESS')}: $message"}$reset');
  }
}
