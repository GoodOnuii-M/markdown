import 'package:markdown/markdown.dart';
import 'package:test/test.dart';

void main() {
  test('Supscript 인라인 구문 파싱 테스트', () {
    /// MD 다큐먼트 생성
    final document = Document(
      inlineSyntaxes: [
        /// <sup></sup> 구문 분석기 추가
        SupInlineSyntax(),
      ],
    );

    /// 파싱결과
    final result = document.parseInline('Text<sup>Sup</sup>');

    expect(result, hasLength(2));

    expect(
      result[0],
      const TypeMatcher<Text>().having(
        (e) => e.textContent,
        '<sup></sup> 구문 분석기에 걸러지지 않은 문자',
        equals('Text'),
      ),
    );

    expect(
      result[1],
      const TypeMatcher<Element>()
          .having(
            (e) => e.textContent,
            '<sup></sup> 구문 분석기에 걸러진 문자',
            equals('Sup'),
          )
          .having(
            (e) => e.tag,
            '태그',
            'sup',
          ),
    );
  });
}
