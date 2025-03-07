:- dynamic(quest/3).
:- dynamic(questGoal/3).
% quest(slimeKills, goblinKills, wolfKills).
% questGoal(slimeKillsGoal, goblinKillsGoal, wolfKillsGoal).
quest(0,0,0).
questGoal(5,3,1).

quest :-
  write('Your quest progress: '),nl,
  questGoal(Sg, Gg, Wg),
  quest(S,G,W),
  format(" Slimes: ~w/~w kills ~n Goblin: ~w/~w kills ~n Wolf: ~w/~w kills ~n", [S, Sg, G, Gg, W, Wg]),
  (S >= Sg -> (G >= Gg -> (W >= Wg -> write('Turn in quest at the quest board!'),nl,!;!);!);!).

turnInQuest :-
  playerLoc(X,Y),
  X == 10,
  Y == 15,
  quest(S, G, W),
  questGoal(Sg, Gg, Wg),
  (S < Sg -> write('you need more slime kills'),nl,fail; !),
  (G < Gg -> write('you need more goblin kills'),nl,fail; !),
  (W < Wg -> write('you need more wolf kills'),nl,fail; !),
  write('Quest finished!'),nl,

  GoldReward is 2000 * Wg,
  XPReward is 100 * Wg,
  format("You get ~w Gold and ~w XP ~n", [GoldReward, XPReward]),
  add_gold(GoldReward),
  get_exp(XPReward),

  retract(quest(_,_,_)),
  asserta(quest(0,0,0)),
  NextSg is Sg + 3, NextGg is Gg + 2, NextWg is Wg + 1,
  retract(questGoal(_,_,_)),
  asserta(questGoal(NextSg, NextGg, NextWg)),
  write('Your next quest: '),nl,
  format(" Kill ~w slimes ~n Kill ~w goblin ~n Kill ~w wolf ~n ~n", [NextSg, NextGg, NextWg]),!.

turnInQuest :-
  playerLoc(_,Y),
  Y \== 15,
  write('Your are not at the quest board'),nl,!.

turnInQuest :-
  playerLoc(X,_),
  X \== 10,
  write('Your are not at the quest board'),nl,!.

turnInQuest :- !.
