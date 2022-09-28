import 'package:markdown/markdown.dart';

class HighlightInlineSyntax extends DelimiterSyntax {
  HighlightInlineSyntax()
      : super(
          '<mark>',
          requiresDelimiterRun: true,
          allowIntraWord: true,
          tags: [
            DelimiterTag(
              'mark',
              1,
            ),
          ],
        );
}
