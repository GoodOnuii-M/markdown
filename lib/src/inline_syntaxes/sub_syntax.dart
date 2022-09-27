import 'package:markdown/markdown.dart';

class SubInlineSyntax extends DelimiterSyntax {
  SubInlineSyntax()
      : super(
          '<sub>',
          requiresDelimiterRun: true,
          allowIntraWord: true,
          tags: [
            DelimiterTag(
              'sub',
              1,
            ),
          ],
        );
}
