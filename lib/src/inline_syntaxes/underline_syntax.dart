import 'package:markdown/markdown.dart';

class UnderlineInlineSyntax extends DelimiterSyntax {
  UnderlineInlineSyntax()
      : super(
          '<u>',
          requiresDelimiterRun: true,
          allowIntraWord: true,
          tags: [
            DelimiterTag(
              'u',
              1,
            ),
          ],
        );
}
