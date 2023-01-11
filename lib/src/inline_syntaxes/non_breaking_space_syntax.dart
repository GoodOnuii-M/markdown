import '../ast.dart';
import '../inline_parser.dart';
import 'inline_syntax.dart';

class NonBreakingSpace extends InlineSyntax {
  NonBreakingSpace() : super('(&nbsp;|&ensp;|&emsp;)');

  @override
  bool onMatch(InlineParser parser, Match match) {
    final hasMatch = match.groupCount > 0;

    if (hasMatch) {
      final matchedString = match.group(1);
      if (matchedString!.contains('ensp')) {
        parser.addNode(
          Text('  '),
        );
      } else if (matchedString.contains('emsp')) {
        parser.addNode(
          Text('   '),
        );
      } else {
        parser.addNode(
          Text(' '),
        );
      }
    }

    return hasMatch;
  }
}
