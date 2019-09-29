import 'package:kalashnikov/gamestate.dart';

main() {
  var state = GameState(
    numberOfPlayers: 2,
  );
  state.dealFromScrap();
  print(state.currentCards);
  state.playerDiscard(0, state.scrap.removeLast());
  state.nextTurn();
  print(state.currentCards);
  state.playerDiscard(0, state.scrap.removeLast());
  state.nextTurn();
  print(state.shelf);
}