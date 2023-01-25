import '../../markdown.dart';

class HighlightInlineSyntax extends InlineSyntax {
  HighlightInlineSyntax() : super(r'\<mark\>((.|\n)*?)\<mark\>');

  @override
  bool onMatch(InlineParser parser, Match match) {
    final hasMatch = match.groupCount > 0;

    if (hasMatch) {
      /// 매칭 문자열
      final matchedString = match.group(1)!;

      Element mark = Element.text(
        'mark',
        matchedString,
      );

      bool strongCode = strongCodePattern.hasMatch(matchedString);
      bool strikeThrough = strikeThroughPattern.hasMatch(matchedString);

      Map<String, dynamic> strongCodeOption = {};
      Map<String, dynamic> strikeThroughOption = {};

      /// 구분자(delimiter) 처리를 위한 코드
      // ~ ~
      // ~~ ~~
      // ~~~ ~~~
      // * * : tilt, italic
      // ** ** : bold
      // *** ***: bold + tilt

      if (strongCode) {
        Iterable<RegExpMatch> matches =
            strongCodePattern.allMatches(matchedString);

        for (var m in matches) {
          if (m.groupCount > 2) {
            // 같은 길이의 syntax인 경우에
            if (m.group(1) == m.group(3)) {
              // 위치를 저장했다가 스타일 적용하는데 활용
              String txt = m.group(0)!;
              // int start = m.group(1)!.length;
              // int end = txt.length - m.group(3)!.length;

              int start = m.start + m.group(1)!.length;
              int end = m.end - m.group(3)!.length;
              int tagSize = m.group(3)!.length;
              TagPos pos = TagPos(
                length: txt.length,
                startWholePos: m.start,
                endWholePos: m.end,
                tag: txt,
                tagSize: tagSize,
              );
              strongCodeOption[txt] = pos;
            }
          }
        }
      }

      if (strikeThrough) {
        Iterable<RegExpMatch> matches =
            strikeThroughPattern.allMatches(matchedString);
        for (var m in matches) {
          if (m.groupCount > 2) {
            // 같은 길이의 syntax인 경우에
            if (m.group(1) == m.group(3)) {
              // 위치를 저장했다가 스타일 적용하는데 활용
              String txt = m.group(0)!;
              TagPos pos = TagPos(
                length: txt.length,
                startWholePos: m.start,
                endWholePos: m.end,
                tag: txt,
              );
              strikeThroughOption[txt] = pos;
            }
          }
        }
      }

      mark.setTagOption('strongCode', strongCodeOption);
      mark.setTagOption('strikeThrough', strikeThroughOption);

      /// Element mark 태그 부착
      parser.addNode(mark);
    }
    return hasMatch;
  }
}
