import 'dart:collection' show ListQueue, Queue;
import 'package:kalashnikov/cards.dart';
import 'package:kalashnikov/players.dart';
import 'package:meta/meta.dart';

class GameState {
  List<Player> players;
  final int initialPlayerHealth;

  /// The shelf contains useful cards
  List<Card> shelf;

  /// The shelf's player attributes
  List<int> shelfAttributes;

  /// The scrap contains useful and not useful cards
  Queue<Card> scrap;

  /// The discard is useless
  List<Card> discard;

  int whosTurn;

  recollectCards({bool redeal=true,int redealRounds:4,}) {
    shelfAttributes.clear();
    scrap.addAll([...discard, ...shelf, for (var p in players) ...p.cards]);
    discard.clear();
    shelf.clear();
    players.forEach((x) => x.cards.clear());
    scrap = ListQueue.from(scrap.toList()..shuffle());
    if (redeal) dealFromScrap(redealRounds);
  }

  dealFromScrap([int rounds = 4]) {
    for (var p in players) {
      for (int i = 0; i < rounds; ++i) {
        p.cards.add(scrap.removeLast());
      }
    }
  }

  Player get currentPlayer => players[whosTurn];
  List<Card> get currentCards => currentPlayer.cards;

  playerDiscard(int index, Card swapTo) {
    if (isGunPart(currentCards[index])) {
      shelf.add(currentCards[index]);
      shelfAttributes.add(whosTurn);
    } else {
      discard.add(currentCards[index]);
    }
    currentCards[index] = swapTo;
  }

  whoeverDiscard(int playerIndex, int index, Card swapTo) {
    if (isGunPart(players[playerIndex].cards[index])) {
      shelf.add(players[playerIndex].cards[index]);
      shelfAttributes.add(whosTurn);
    } else {
      discard.add(players[playerIndex].cards[index]);
    }
    players[playerIndex].cards[index] = swapTo;
  }

  Card shelfRemoveAt(int index) {
    shelfAttributes.removeAt(index);
    return shelf.removeAt(index);
  }

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

  /// aPick is a's pick out of b's cards
  /// the output is it's success (negative=a success, positive=b success,0=nobody won)
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

  GameState(
      {this.initialPlayerHealth: 20,
      @required int numberOfPlayers,
      List<Card> initialScrap}) {
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
