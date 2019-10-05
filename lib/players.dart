import 'package:kalashnikov/cards.dart';

/// This is a [Player], They are trying to have the [cards] A, K, 4, and 7 (AK-47 basically), or have a golden version of it (all cards in the same suit).
/// They can die.
class Player {
  /// What cards does the player have in their hand (Under normal circumstances, there should only be four. If there's not, panic.)
  List<Card> cards;

  /// How much health does the player have left?
  int healthLeft;

  /// Is the player dead?
  bool get dead => healthLeft <= 0;

  /// Does the player have a gun?
  bool get hasKalashnikov => hasGun(cards);

  /// Is the player's gun a golden kalashnikov?
  bool get hasGoldenKalashnikov => goldenKalashnikov(cards);

  /// Calculates the damage depending on what card index was picked from the player's [cards]
  int calcDamage(int card) {
    if (card.isNegative || card >= cards.length) {
      throw RangeError.index(
        card,
        cards,
        "card",
        (card.isNegative)
            ? "There isn't a negative card"
            : "This player doesn't have ${card + 1} cards!",
      );
    }
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
      for (int i = 2; i < damageZones.length; ++i) {
        if (damageZones[i] == wasDam) damageZones[i] = 1;
      }
    }
    return damageZones[cardSort.indexOf(cards[card])];
  }

  /// Creates a [Player] and initializes their [cards]
  Player([this.healthLeft = 20]) {
    cards = [];
  }
}
