import 'package:decoratable_text/decoratable_text.dart';
import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("DecoratableText Example")),
        body: DecoratableTextExamples(),
      ),
    );
  }
}

class DecoratableTextExamples extends StatelessWidget {
  static const _linkStyle = TextStyle(color: Colors.blue);
  static const _idStyle = TextStyle(color: Colors.amber);
  static const _tagStyle = TextStyle(color: Colors.teal);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const DecoratableText(
            text: "url: https://flutter.dev/",
            decorations: [
              DecorationOption(
                pattern: TextPattern.url,
                style: _linkStyle,
                tapAction: TapAction.launchUrl,
                showRipple: true,
              ),
            ],
          ),
          const DecoratableText(
            text: "mail: hogehoge@foomail.com",
            decorations: [
              DecorationOption(
                pattern: TextPattern.mail,
                style: _linkStyle,
                tapAction: TapAction.launchMail,
                showRipple: true,
              ),
            ],
          ),
          const DecoratableText(
            text:
                "You can change the text that matches the pattern. -> https://flutter.dev/",
            decorations: [
              DecorationOption(
                pattern: TextPattern.url,
                displayText: "Tap hare",
                style: _linkStyle,
                tapAction: TapAction.launchUrl,
                showRipple: true,
              ),
            ],
          ),
          const DecoratableText(
            text: "@You can set custom patterns.",
            decorations: [
              DecorationOption(
                pattern: r"@[a-zA-Z0-9]+",
                style: _idStyle,
              ),
            ],
          ),
          DecoratableText(
            text: "You can set custom tap actions. #SnackBar",
            decorations: [
              DecorationOption(
                pattern: r"#[a-zA-Z0-9_]+",
                style: _tagStyle,
                onTap: () => Scaffold.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Tapped #SnackBar"),
                  ),
                ),
                showRipple: true,
              ),
            ],
          ),
          const DecoratableText(
            text:
                "You can set multiple decoration options. \nFlutter: https://flutter.dev/ #flutter \nDart: https://dart.dev/ #dart",
            decorations: [
              DecorationOption(
                pattern: r"#[a-zA-Z0-9_]+",
                style: _tagStyle,
              ),
              DecorationOption(
                pattern: TextPattern.url,
                style: _linkStyle,
                tapAction: TapAction.launchUrl,
                showRipple: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
