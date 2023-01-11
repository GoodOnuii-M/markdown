import 'package:markdown/markdown.dart';
import 'package:test/test.dart';

void main() {
  test('Subscript 인라인 구문 파싱 테스트', () {
    /// MD 다큐먼트 생성
    final document = Document(
      inlineSyntaxes: [
        /// <sub></sub> 구문 분석기 추가
        SubInlineSyntax(),
      ],
    );

    /// 파싱결과
    final result = document.parseInline('Text<sub>Sub</sub>');

    expect(result, hasLength(2));

    expect(
      result[0],
      const TypeMatcher<Text>().having(
        (e) => e.textContent,
        '<sub></sub> 구문 분석기에 걸러지지 않은 문자',
        equals('Text'),
      ),
    );

    expect(
      result[1],
      const TypeMatcher<Element>()
          .having(
            (e) => e.textContent,
            '<sub></sub> 구문 분석기에 걸러진 문자',
            equals('Sub'),
          )
          .having(
            (e) => e.tag,
            '태그',
            'sub',
          ),
    );
  });
}
