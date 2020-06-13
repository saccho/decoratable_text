# decoratable_text

Decorate a part of the text, such as changing the style and setting a tap action.

## Installing

https://pub.dev/packages/decoratable_text#-installing-tab-

## Usage

- Decorate url text

``` dart
...
const DecoratableText(
  text: "url: https://flutter.dev/",
  decorations: [
    DecorationOption(
      pattern: TextPattern.url,
      style: TextStyle(color: Colors.blue),
      tapAction: TapAction.launchUrl,
      showRipple: true,
    ),
  ],
),
...
```

<img src="https://user-images.githubusercontent.com/36199796/84576376-3ff48580-adef-11ea-913b-16e47b217c2c.gif" width="320px"> 

- Decorate mail text

``` dart
...
const DecoratableText(
  text: "mail: hogehoge@foomail.com",
  decorations: [
    DecorationOption(
      pattern: TextPattern.mail,
      style: TextStyle(color: Colors.blue),
      tapAction: TapAction.launchMail,
      showRipple: true,
    ),
  ],
),
...
```

<img src="https://user-images.githubusercontent.com/36199796/84576374-3f5bef00-adef-11ea-8c7a-01f1327e7751.gif" width="320px">

- Decorate url text and change url display

``` dart
const DecoratableText(
  text:
      "You can change the text that matches the pattern. -> https://flutter.dev/",
  decorations: [
    DecorationOption(
      pattern: TextPattern.url,
      displayText: "Tap hare",
      style: TextStyle(color: Colors.blue),
      tapAction: TapAction.launchUrl,
      showRipple: true,
    ),
  ],
),
```

<img src="https://user-images.githubusercontent.com/36199796/84576460-dc1e8c80-adef-11ea-955e-ab48ee292540.gif" width="320px">

- Decorate any text

``` dart
DecoratableText(
  text: "You can set custom tap actions. #SnackBar",
  decorations: [
    DecorationOption(
      pattern: r"#[a-zA-Z0-9_]+",
      style: TextStyle(color: Colors.teal),
      onTap: () => Scaffold.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tapped #SnackBar"),
        ),
      ),
      showRipple: true,
    ),
  ],
),
```

<img src="https://user-images.githubusercontent.com/36199796/84576371-3bc86800-adef-11ea-8378-b7854c96e0a1.gif" width="320px">

- Decorate multiple texts

``` dart
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
```
