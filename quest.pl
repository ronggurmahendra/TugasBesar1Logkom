% activeQuest(questnumber, progress)
:- dynamic(activeQuest/2).

activeQuest(0,0).


fetchQuest :-
  activeQuest(X, _),
  (X > 0 -> write('You already have an ongoing quest!'),nl,fail ; !),
  retract(activeQuest(_,_)),
  random(1,6,R),
  write('Quest Fetched!'),nl,
  quest(R),!.


quest(1) :-
  write('Defeat 7 slime'),nl,
  asserta(activeQuest(1, 0)).
quest(2) :-
  write('Defeat 5 goblin'),nl,
  asserta(activeQuest(2, 0)).
quest(3) :-
  write('Defeat 3 wolf'),nl,
  asserta(activeQuest(3, 0)).
quest(4) :-
  write('Use special attack to kill enemy 3 times'),nl,
  asserta(activeQuest(4, 0)).
quest(5) :-
  write('Kill 10 enemies'),nl,
  asserta(activeQuest(5, 0)).



finishQuest :-
  activeQuest(1, 7),
  write('Quest finished!'),nl,
  %reward
  retract(activeQuest(_,_)),
  asserta(activeQuest(0,0)).

finishQuest :-
  activeQuest(2, 5),
  write('Quest finished!'),nl,
  %reward
  retract(activeQuest(_,_)),
  asserta(activeQuest(0,0)).

finishQuest :-
  activeQuest(3, 3),
  write('Quest finished!'),nl,
  %reward
  retract(activeQuest(_,_)),
  asserta(activeQuest(0,0)).

finishQuest :-
  activeQuest(4, 3),
  write('Quest finished!'),nl,
  %reward
  retract(activeQuest(_,_)),
  asserta(activeQuest(0,0)).

finishQuest :-
  activeQuest(5, 10),
  write('Quest finished!'),nl,
  %reward
  retract(activeQuest(_,_)),
  asserta(activeQuest(0,0)).

finishQuest :- !.
