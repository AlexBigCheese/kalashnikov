enum Suit {
  Hearts,
  Diamonds,
  Clubs,
  Spades,
}

const Map<Suit, String> suitToString = {
  Suit.Hearts: '♥',
  Suit.Diamonds: '♦',
  Suit.Clubs: '♣',
  Suit.Spades: '♠',
};


const Map<int,String> symToString = {
  12:"A",
  11:"K",
  10:"Q",
  9:"J",
  8:"10",
  7:"9",
  6:"8",
  5:"7",
  4:"6",
  3:"5",
  2:"4",
  1:"3",
  0:"2",
};

class Card with Comparable {
  ///When is 12, is an Ace, when is 0, is a 2
  final int sym;
  final Suit suit;
  final int extraId;

  const Card(this.sym, this.suit,[this.extraId]);

  @override
  int compareTo(other) {
    if (other is! Card && other is! int) throw "Not a Card or integer";
    int otherV = (other is Card) ? other.sym : other;
    return sym.compareTo(otherV);
  }

  @override
  int get hashCode => ((extraId ?? 0) << 7) | (sym << 2) | Suit.values.indexOf(suit);
  operator ==(other) => other is Card && hashCode == other.hashCode;

  @override
  String toString() {
    return symToString[sym]+suitToString[suit];
  }
}

List<Card> get packOf52Cards => [
      for (var s in Suit.values) for (int i = 0; i < 13; ++i) Card(i, s),
    ];

const List<int> _gunParts = [12, 11, 2, 5];

bool hasGun(List<Card> cards) =>
    _gunParts.every((x) => cards.any((card) => card.sym == x));
/// Deals 8 damage every time
bool goldenKalashnikov(List<Card> cards) =>
    Suit.values.any((suit) => cards.every((card) => card.suit == suit));
bool isGunPart(Card card) => _gunParts.any((x) => x==card.sym);