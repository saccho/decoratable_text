import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'decoration_option.dart';

class DecoratableText extends StatefulWidget {
  const DecoratableText({
    Key key,
    @required this.text,
    @required this.decorations,
    this.style,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
  }) : super(key: key);

  /// The text to display in this widget.
  final String text;

  /// The decoration Settings.
  final List<DecorationOption> decorations;

  /// Style for plain text.
  final TextStyle style;

  // RichText

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// The directionality of the text.
  ///
  /// This decides how [textAlign] values like [TextAlign.start] and
  /// [TextAlign.end] are interpreted.
  ///
  /// This is also used to disambiguate how to render bidirectional text. For
  /// example, if the [text] is an English phrase followed by a Hebrew phrase,
  /// in a [TextDirection.ltr] context the English phrase will be on the left
  /// and the Hebrew phrase to its right, while in a [TextDirection.rtl]
  /// context, the English phrase will be on the right and the Hebrew phrase on
  /// its left.
  ///
  /// Defaults to the ambient [Directionality], if any. If there is no ambient
  /// [Directionality], then this must not be null.
  final TextDirection textDirection;

  /// Whether the text should break at soft line breaks.
  ///
  /// If false, the glyphs in the text will be positioned as if there was unlimited horizontal space.
  final bool softWrap;

  /// How visual overflow should be handled.
  final TextOverflow overflow;

  /// The number of font pixels for each logical pixel.
  ///
  /// For example, if the text scale factor is 1.5, text will be 50% larger than
  /// the specified font size.
  final double textScaleFactor;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be truncated according
  /// to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  final int maxLines;

  /// Used to select a font when the same Unicode character can
  /// be rendered differently, depending on the locale.
  ///
  /// It's rarely necessary to set this property. By default its value
  /// is inherited from the enclosing app with `Localizations.localeOf(context)`.
  ///
  /// See [RenderParagraph.locale] for more information.
  final Locale locale;

  /// {@macro flutter.painting.textPainter.strutStyle}
  final StrutStyle strutStyle;

  /// {@macro flutter.widgets.text.DefaultTextStyle.textWidthBasis}
  final TextWidthBasis textWidthBasis;

  /// {@macro flutter.dart:ui.textHeightBehavior}
  final TextHeightBehavior textHeightBehavior;

  @override
  State<StatefulWidget> createState() => _DecoratableTextState();
}

class _DecoratableTextState extends State<DecoratableText> {
  final _recognizers = <String, TapGestureRecognizer>{};

  @override
  void dispose() {
    for (var recognizer in _recognizers.values) {
      recognizer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: _buildTextSpans(context)),
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      softWrap: widget.softWrap,
      overflow: widget.overflow,
      textScaleFactor: widget.textScaleFactor,
      maxLines: widget.maxLines,
      locale: widget.locale,
      strutStyle: widget.strutStyle,
      textWidthBasis: widget.textWidthBasis,
      textHeightBehavior: widget.textHeightBehavior,
    );
  }

  List<InlineSpan> _buildTextSpans(BuildContext context) {
    final plainTextStyle = widget.style ?? DefaultTextStyle.of(context).style;
    if (widget.decorations.isEmpty) {
      return [
        TextSpan(
          text: widget.text,
          style: plainTextStyle,
        )
      ];
    }
    final patterns = Set<String>();
    final decorations = <String, DecorationOption>{};
    for (var decoration in widget.decorations) {
      if (patterns.add(decoration.pattern)) {
        var matches = RegExp(decoration.pattern).allMatches(widget.text);
        for (var match in matches) {
          var matchedText = match.group(0);
          decorations[matchedText] = decoration;
          _recognizers[matchedText] = _buildRecognizer(matchedText, decoration);
        }
      }
    }
    final texts = _splitPlainAndLinkText(decorations.keys);
    final textSpans = <InlineSpan>[];
    for (var text in texts) {
      if (decorations.containsKey(text)) {
        textSpans.add(
          TextSpan(
            text: decorations[text].displayText ?? text,
            style: decorations[text].style ?? plainTextStyle,
            recognizer: _recognizers[text],
          ),
        );
      } else {
        textSpans.add(
          TextSpan(
            text: text,
            style: plainTextStyle,
          ),
        );
      }
    }
    return textSpans;
  }

  TapGestureRecognizer _buildRecognizer(
      String url, DecorationOption decoration) {
    if (decoration.onTap != null) {
      return TapGestureRecognizer()..onTap = decoration.onTap;
    } else {
      switch (decoration.tapAction) {
        case TapAction.launchUrl:
          return TapGestureRecognizer()..onTap = () => _launch(url);
          break;
        case TapAction.launchMail:
          return TapGestureRecognizer()..onTap = () => _launch("mailto:$url");
          break;
        default:
          return TapGestureRecognizer()..onTap = () {};
      }
    }
  }

  _launch(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<String> _splitPlainAndLinkText(Iterable patterns) {
    final joinedPattern = patterns.join("|");
    return widget.text
        .split(RegExp("((?<=$joinedPattern)|(?=$joinedPattern))"));
  }
}
