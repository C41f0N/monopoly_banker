import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:monopoly_banker/class_structure/player.dart';
import 'package:monopoly_banker/class_structure/transaction.dart';

class Game extends ChangeNotifier {
  Game() {
    gameName = _myBox.get("__CURRENT_GAME_NAME__");
    print("gameName $gameName");

    if (gameName == null) {
      List<String>? gamesList = _myBox.get("__GAMES_LIST__");

      print("gameList $gamesList");

      if (gamesList == null) {
        gameName = "First Game";
        _myBox.put("__CURRENT_GAME_NAME__", gameName);
        setDefaultData();
        addGameNameToList();

        saveGameToHive();
      } else {
        gameName = gamesList[0];
        _myBox.put("__CURRENT_GAME_NAME__", gameName);
        getGameFromHive();
      }
    }
  }

  String? gameName;
  final _myBox = Hive.box("__MONOPOLY_BANKER_DATABASE__");

  int startingAmount = 500;
  int goAmount = 200;

  List<Player> players = [];
  List<Transaction> transactions = [];

  void setDefaultData() {
    goAmount = 200;
    startingAmount = 500;

    // Set initial Players
    players = [
      Player("Player 1", startingAmount),
      Player("Player 2", startingAmount),
      Player("Player 3", startingAmount),
    ];

    transactions = [];
  }

  void addGameNameToList() {
    List<String>? gamesList = _myBox.get("__GAMES_LIST__");

    gamesList ??= [];
    gamesList.add(gameName!);

    _myBox.put("__GAMES_LIST__", gamesList);

    notifyListeners();
  }

  void addNewGame(String newGameName) {
    // Set the game name
    gameName = newGameName;
    addGameNameToList();

    switchToGame(newGameName);

    setDefaultData();

    // Save the new game
    saveGameToHive();
    notifyListeners();
  }

  void removeGame(String gameNameToRemove) {
    // Remove from the game names list
    List<String> gamesList = _myBox.get("__GAMES_LIST__");

    gamesList.remove(gameNameToRemove);

    _myBox.put("__GAMES_LIST__", gamesList);

    // Delete Save Amount
    _myBox.put("${gameNameToRemove}__startingAmount", null);

    // Delete Go Amount
    _myBox.put("${gameNameToRemove}__goAmount", null);

    // Delete Players List
    _myBox.put("${gameName}__players", null);

    // Delete Transactions List
    _myBox.put("${gameName}__transactions", null);

    notifyListeners();
  }

  void saveGameToHive() {
    // Save Starting Amount
    _myBox.put("${gameName}__startingAmount", startingAmount);

    // Save Go Amount
    _myBox.put("${gameName}__goAmount", goAmount);

    // Save Players List
    List<String> playersListString = [];

    for (Player player in players) {
      playersListString.add("${player.name},${player.accountBalance}");
    }

    _myBox.put("${gameName}__players", playersListString);

    // Save Transactions List
    List<String> transactionsListString = [];

    for (Transaction transaction in transactions) {
      transactionsListString.add(
          "${transaction.fromPlayer}|${transaction.toPlayer}|${transaction.amount}|${transaction.transactionTime.millisecondsSinceEpoch}");
    }

    _myBox.put("${gameName}__transactions", transactionsListString);
  }

  void getGameFromHive() {
    // Get Starting Amount

    // If data is null, check if the game name exists in list
    if (!dataForGameExists(gameName!)) {
      List<String>? gamesList = _myBox.get("__GAMES_LIST__");

      // If game name is valid, then create data for a new game
      // and save it.
      if (gamesList!.contains(gameName)) {
        _myBox.put("__CURRENT_GAME_NAME__", gameName);
        setDefaultData();
        saveGameToHive();
      }
    } else {
      startingAmount = _myBox.get("${gameName}__startingAmount");

      // Get Go Amount
      goAmount = _myBox.get("${gameName}__goAmount");

      // Get Players List
      List<String> playersListString = _myBox.get("${gameName}__players");
      players = [];

      for (String playerData in playersListString) {
        String playerName = playerData.split(",")[0];
        int accountBalance = int.parse(playerData.split(",")[1]);
        players.add(Player(playerName, accountBalance));
      }

      // Get Transactions List
      List<String> transactionsListString =
          _myBox.get("${gameName}__transactions");

      transactions = [];

      for (String transactionData in transactionsListString) {
        String fromPlayer = transactionData.split("|")[0];
        String toPlayer = transactionData.split("|")[1];
        int amount = int.parse(transactionData.split("|")[2]);
        DateTime transactionTime = DateTime.fromMillisecondsSinceEpoch(
            int.parse(transactionData.split("|")[3]));

        transactions
            .add(Transaction(fromPlayer, toPlayer, amount, transactionTime));
      }
    }
  }

  bool dataForGameExists(String gameNameToCheck) {
    return _myBox.get("${gameName}__startingAmount") != null &&
        _myBox.get("${gameName}__goAmount") != null &&
        _myBox.get("${gameName}__players") != null &&
        _myBox.get("${gameName}__transactions") != null;
  }

  void addPlayer(String playerName) {
    if (playerName != "__BANK__") {
      players.add(Player(playerName, startingAmount));
    }

    saveGameToHive();
    notifyListeners();
  }

  void removePlayer(String playerName) {
    players.removeWhere((element) => element.name == playerName);

    saveGameToHive();
    notifyListeners();
  }

  bool playerExists(String playerName) {
    getGameFromHive();
    return players.indexWhere((player) => player.name == playerName) != -1;
  }

  void addTransaction(String fromPlayer, String toPlayer, int amount) {
    print("adding transaction");
    if ((fromPlayer == "__BANK__" ||
            players
                .where((element) => element.name == fromPlayer)
                .isNotEmpty) &&
        (toPlayer == "__BANK__" ||
            players.where((element) => element.name == toPlayer).isNotEmpty)) {
      // subtract money from fromPlayer
      if (fromPlayer != "__BANK__") {
        int fromPlayerIndex =
            players.indexWhere((element) => element.name == fromPlayer);

        players[fromPlayerIndex].takeMoney(amount);
      }

      // add money to toPlayer
      if (toPlayer != "__BANK__") {
        int toPlayerIndex =
            players.indexWhere((element) => element.name == toPlayer);

        players[toPlayerIndex].giveMoney(amount);
      }

      // add transaction object to list
      transactions
          .add(Transaction(fromPlayer, toPlayer, amount, DateTime.now()));

      saveGameToHive();
      notifyListeners();
    }
  }

  List<String> getGameNamesList() {
    List<String>? gameNamesList = _myBox.get("__GAMES_LIST__");

    if (gameNamesList == null) {
      return [];
    }

    return gameNamesList;
  }

  void switchToGame(String gameNameToSwitch) {
    print("Attempting to switch to game");
    if (getGameNamesList().contains(gameNameToSwitch)) {
      print("Switching game");
      gameName = gameNameToSwitch;
      _myBox.put("__CURRENT_GAME_NAME__", gameNameToSwitch);
      getGameFromHive();
    } else {
      print("Name Doesnt Exist");
    }
  }

  void resetAllAccounts() {
    for (Player player in players) {
      player.accountBalance = startingAmount;
    }

    saveGameToHive();
    notifyListeners();
  }

  void changeStartingAmount(int newAmount) {
    startingAmount = newAmount;
    saveGameToHive();
    notifyListeners();
  }
}
