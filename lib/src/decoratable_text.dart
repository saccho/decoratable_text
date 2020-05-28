import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'decoration_option.dart';

class DecoratableText extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: _buildTextSpans(context)),
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  List<InlineSpan> _buildTextSpans(BuildContext context) {
    final plainTextStyle = style ?? DefaultTextStyle.of(context).style;
    if (decorations.isEmpty) {
      return [
        TextSpan(
          text: text,
          style: plainTextStyle,
        )
      ];
    }
    final patterns = Set<String>();
    final decorationOptions = <String, DecorationOption>{};
    for (var decoration in decorations) {
      if (patterns.add(decoration.pattern)) {
        var matches = RegExp(decoration.pattern).allMatches(text);
        for (var match in matches) {
          var matchedText = match.group(0);
          decorationOptions[matchedText] = decoration;
        }
      }
    }
    final texts = _splitPlainAndLinkText(decorationOptions.keys);
    final textSpans = <InlineSpan>[];
    for (var text in texts) {
      if (decorationOptions.containsKey(text)) {
        textSpans.add(
          _buildDecoratedText(
            context,
            text: decorationOptions[text].displayText ?? text,
            style: decorationOptions[text].style ?? plainTextStyle,
            decoration: decorationOptions[text],
            onTap: _tapAction(text, decorationOptions[text]),
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

  InlineSpan _buildDecoratedText(BuildContext context,
      {String text,
      TextStyle style,
      DecorationOption decoration,
      VoidCallback onTap}) {
    if (decoration.showRipple) {
      return WidgetSpan(
        child: InkWell(
          child: Text(
            text,
            style: style,
          ),
          onTap: onTap,
        ),
      );
    } else {
      return WidgetSpan(
        child: GestureDetector(
          child: Text(
            text,
            style: style,
          ),
          onTap: onTap,
        ),
      );
    }
  }

  VoidCallback _tapAction(String url, DecorationOption decoration) {
    if (decoration.onTap != null) {
      return decoration.onTap;
    } else {
      switch (decoration.tapAction) {
        case TapAction.launchUrl:
          return () => _launch(url);
          break;
        case TapAction.launchMail:
          return () => _launch("mailto:$url");
          break;
        default:
          return () {};
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
    return text.split(RegExp("((?<=$joinedPattern)|(?=$joinedPattern))"));
  }
}
