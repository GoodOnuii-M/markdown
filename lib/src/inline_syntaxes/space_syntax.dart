import '../../markdown.dart';

class SpaceSyntax extends InlineSyntax {
  SpaceSyntax() : super('( {2,})');

  @override
  bool onMatch(InlineParser parser, Match match) {
    final hasMatch = match.groupCount > 0;
    if (hasMatch) {
      if (match.group(1) != null) {
        parser.addNode(Text(' '));
      }
    }

    return hasMatch;
  }
}
