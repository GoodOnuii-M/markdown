import '../../markdown.dart';

class SupInlineSyntax extends DelimiterSyntax {
  SupInlineSyntax()
      : super(
          '<sup>',
          requiresDelimiterRun: true,
          allowIntraWord: true,
          tags: [
            DelimiterTag(
              'sup',
              1,
            ),
          ],
        );
}
