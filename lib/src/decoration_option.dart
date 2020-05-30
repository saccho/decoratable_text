import 'package:flutter/widgets.dart';

@immutable
class DecorationOption {
  const DecorationOption({
    @required this.pattern,
    this.displayText,
    this.style,
    this.tapAction,
    this.onTap,
    this.showRipple = false,
  });

  /// Pattern of the text to decorate.
  final String pattern;

  /// The text for display.
  final String displayText;

  /// Style of the text to decorate.
  final TextStyle style;

  /// Action when tapping the decorated text.
  final TapAction tapAction;

  /// Custom callback when tapping the decorated text.
  final VoidCallback onTap;

  /// Whether to show the ripple effect.
  final bool showRipple;
}

class TextPattern {
  static const url = r"https?://[\w!?/\+\-_~=;\.,*&@#$%\(\)\'\[\]]+";
  static const mail =
      r"[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*";
}

enum TapAction { launchUrl, launchMail }
