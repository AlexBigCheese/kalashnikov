/// These are the four Suits of cards,
enum Suit {
  Hearts,
  Diamonds,
  Clubs,
  Spades,
}

/// This is a mapping of the Suits to unicode representations of those suits
const Map<Suit, String> suitToString = {
  Suit.Hearts: '♥',
  Suit.Diamonds: '♦',
  Suit.Clubs: '♣',
  Suit.Spades: '♠',
};

/// This is a mapping of the card's value to a string representation (12 (A), Is the highest value, while 0 (2) is the lowest value)
const Map<int, String> symToString = {
  12: "A",
  11: "K",
  10: "Q",
  9: "J",
  8: "10",
  7: "9",
  6: "8",
  5: "7",
  4: "6",
  3: "5",
  2: "4",
  1: "3",
  0: "2",
};

/// This is a [Card], it's immutable because if you could mutate it that'd be weird (Imagine holding a card in your hand and it changes! That'd be strange!)
class Card with Comparable {
  /// What is the card's value? if [sym] is 12 then that means this card is an Ace, if [sym] is 0 then this card is a 2
  final int sym;

  /// Which suit is this card?
  final Suit suit;

  /// What is the extra ID on this card? (Useful for when you have a deck that's not a regular pack of 52 playing cards)
  final int extraId;

  /// Create a constant [Card]
  const Card(this.sym, this.suit, [this.extraId]);

  @override
  int compareTo(other) {
    if (other is! Card && other is! int) throw "Not a Card or integer";
    int otherV = (other is Card) ? other.sym : other;
    return sym.compareTo(otherV);
  }

  /// The hashCode of a card is a serialized representation of the card as bits
  /// 
  /// The bits of the card are `evvvvvss`
  /// 
  /// `e` is [extraId], 
  /// `v` is [sym] (stands for value),
  /// `s` is [suit]
  @override
  int get hashCode =>
      ((extraId ?? 0) << (7+extraId?.bitLength??0)) | (sym << 2) | Suit.values.indexOf(suit);
  operator ==(other) => other is Card && hashCode == other.hashCode;

  @override
  String toString() {
    return symToString[sym] + suitToString[suit];
  }
}

/// A regular pack of 52 cards
List<Card> get packOf52Cards => [
      for (var s in Suit.values) for (int i = 0; i < 13; ++i) Card(i, s),
    ];

const List<int> _gunParts = [12, 11, 2, 5];

/// Check if the [cards] make a gun
bool hasGun(Iterable<Card> cards) =>
    _gunParts.every((x) => cards.any((card) => card.sym == x));

/// Checks if the [cards] are in the same suit (doesn't matter if it's a gun or not)
bool goldenKalashnikov(Iterable<Card> cards) =>
    Suit.values.any((suit) => cards.every((card) => card.suit == suit));

/// Checks if the [Card] is part of a gun
bool isGunPart(Card card) => _gunParts.any((x) => x == card.sym);
