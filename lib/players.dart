import 'package:kalashnikov/cards.dart';

class Player {
  List<Card> cards;
  int healthLeft;
  bool get dead => healthLeft <= 0;
  bool get hasKalashnikov => hasGun(cards);
  bool get hasGoldenKalashnikov => goldenKalashnikov(cards);

  /// Remember: If is to complicated for you, just use dice to work out damage: Roll 6, damage is 6, Roll 1, damage is 1.
  int calcDamage(int card) {
    if (card.isNegative || card >= cards.length)
      throw RangeError.index(
        card,
        cards,
        "card",
        (card.isNegative)
            ? "There isn't a negative card"
            : "This player doesn't have ${card + 1} cards!",
      );
    //Highest damage is always counted
    List<int> damageZones = [];
    List<Card> cardSort = [for (var i in cards) i]..sort();
    int lastSym;
    for (var c in cardSort) {
      if (c.sym != lastSym) {
        lastSym = c.sym;
        damageZones.add(damageZones.isEmpty ? 4 : (damageZones.last - 1));
      } else {
        damageZones.add(damageZones.last);
      }
    }
    //Then the lowest one (if it's 2) becomes one
    if (damageZones.last == 2) {
      int wasDam = damageZones.last;
      for (int i = 2; i < damageZones.length; ++i)
        if (damageZones[i] == wasDam) damageZones[i] = 1;
    }
    return damageZones[cardSort.indexOf(cards[card])];
  }

  Player([this.healthLeft = 20]) {
    cards = [];
  }
}
