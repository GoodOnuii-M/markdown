import 'package:markdown/markdown.dart';
import 'package:test/test.dart';

void main() {
  test('Space Syntax Test', () {
    /// MD 다큐먼트 생성
    final document = Document(
      inlineSyntaxes: [
        /// ~ 구문 분석기 추가
        SpaceSyntax(),
      ],
    );

    /// 파싱결과
    final result = document.parseInline('ASD    ASD');
    expect(
      result[0].textContent.contains(RegExp(' {2,}')),
      false,
    );
  });
}
