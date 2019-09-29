import 'package:test/test.dart';
import 'package:kalashnikov/cards.dart';

main() {
  group("card tests", () {
    const List<Card> cards = [
      const Card(12,Suit.Diamonds),
      const Card(11,Suit.Diamonds),
      const Card(2,Suit.Diamonds),
      const Card(5,Suit.Diamonds),
    ];
    test("kalashnikov", () {
      expect(hasGun(cards), true);
    });
    test("golden kalashnikov", () {
      expect(goldenKalashnikov(cards), true);
    });
  });
}