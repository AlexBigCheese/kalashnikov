import 'dart:collection' show ListQueue, Queue;
import 'package:kalashnikov/cards.dart';
import 'package:kalashnikov/players.dart';
import 'package:meta/meta.dart';

/// The state of a game of kalashnikov
class GameState {
  /// The players that are playing (There are usually two of them, but there can be more)
  List<Player> players;

  /// How much health did the players start with
  final int initialPlayerHealth;

  /// The shelf contains useful cards
  List<Card> shelf;

  /// The shelf's player attributes
  List<int> shelfAttributes;

  /// The scrap contains useful and not useful cards
  Queue<Card> scrap;

  /// The discard is useless
  List<Card> discard;

  /// Who's turn is it
  int whosTurn;

  /// Collect all the cards into the [scrap] pile and reshuffle them, and if [redeal] is true, perform [dealFromScrap]
  recollectCards({
    bool redeal = true,
    int redealRounds = 4,
  }) {
    shelfAttributes.clear();
    scrap.addAll([...discard, ...shelf, for (var p in players) ...p.cards]);
    discard.clear();
    shelf.clear();
    players.forEach((x) => x.cards.clear());
    scrap = ListQueue.from(scrap.toList()..shuffle());
    if (redeal) dealFromScrap(redealRounds);
  }

  /// Deals out cards to the [players] from the scrap pile
  dealFromScrap([int rounds = 4]) {
    for (var p in players) {
      for (int i = 0; i < rounds; ++i) {
        p.cards.add(scrap.removeLast());
      }
    }
  }

  /// Who is the current player?
  Player get currentPlayer => players[whosTurn];

  /// What is the current player's cards?
  List<Card> get currentCards => currentPlayer.cards;

  /// Make the current player discard the card at [index], and swaps the card out with [swapTo]
  playerDiscard(int index, Card swapTo) {
    if (isGunPart(currentCards[index])) {
      shelf.add(currentCards[index]);
      shelfAttributes.add(whosTurn);
    } else {
      discard.add(currentCards[index]);
    }
    currentCards[index] = swapTo;
  }

  /// Makes the player numbered [playerIndex] discard the card at [index], and swaps the card out with [swapTo]
  whoeverDiscard(int playerIndex, int index, Card swapTo) {
    if (isGunPart(players[playerIndex].cards[index])) {
      shelf.add(players[playerIndex].cards[index]);
      shelfAttributes.add(whosTurn);
    } else {
      discard.add(players[playerIndex].cards[index]);
    }
    players[playerIndex].cards[index] = swapTo;
  }

  /// Removes a card from the shelf at [index]
  Card shelfRemoveAt(int index) {
    shelfAttributes.removeAt(index);
    return shelf.removeAt(index);
  }

  /// Gets the shelf, but if the player specified by [who] didn't put the card on the shelf, they can't see it
  List<Card> playerShelfView(int who) => [
        for (int i = 0; i < shelf.length; ++i)
          if (shelfAttributes[i] == who) shelf[i] else null
      ];

  /// Move to the next turn, skipping dead players
  nextTurn() {
    do {
      whosTurn = (whosTurn + 1) % players.length;
    } while (currentPlayer.dead);
  }

  /// Performs the outcome of a duel unless a draw happens (In which case you, the programmer, should get the players to pick cards again)
  ///
  /// aPick is a's pick out of b's cards,
  /// the output is it's success (negative = a success, positive = b success, 0 = nobody won)
  int performDuelOutcome(Player a, Player b, int aPick, int bPick) {
    int aShoot = b.calcDamage(aPick);
    int bShoot = a.calcDamage(bPick);
    int cmp = aShoot.compareTo(bShoot);
    if (cmp.isNegative) {
      // b shoots
      a.healthLeft -= bShoot;
    } else if (cmp != 0) {
      b.healthLeft -= aShoot;
    }
    return cmp;
  }

  /// Initializes a game state
  GameState({
    this.initialPlayerHealth = 20,

    /// How many players are playing
    @required int numberOfPlayers,

    /// What scrap is in the pile to start with (defaults to a [packOf52Cards])
    List<Card> initialScrap,
  }) {
    players = [
      for (int i = 0; i < numberOfPlayers; ++i) Player(initialPlayerHealth)
    ];
    shelf = [];
    shelfAttributes = [];
    discard = [];
    whosTurn = 0;
    scrap = ListQueue.from(initialScrap ?? packOf52Cards
      ..shuffle());
  }
}
