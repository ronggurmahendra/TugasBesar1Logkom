:- dynamic(playerLoc/2).

%fact lokasi penting
playerLoc(10,10).
shop(10,5).
dungeonBoss(20,20).
questLoc(5,5).

% ukuran peta 20x20
% 0 & 21 border; 1-20 active area.
border(0,Y) :- Y>(-1), Y<22.
border(21,Y) :- Y>(-1), Y<22.
border(X,0) :- X>(-1), X<22.
border(X,21) :- X>(-1), X<22.
activeArea(X,Y) :- X>0, X<21, Y>0, Y<21.

% print peta
tulispeta(X,Y) :- playerLoc(X,Y), write('P').
tulispeta(X,Y) :- border(X,Y), write('#').
tulispeta(X,Y) :- shop(X,Y), write('S').
tulispeta(X,Y) :- dungeonBoss(X,Y), write('D').
tulispeta(X,Y) :- questLoc(X,Y), write('Q').
tulispeta(X,Y) :- activeArea(X,Y), write('-').

% move player
w :- state(normal),playerLoc(_,1), write('Border!'),nl,!.
w :- state(normal),retract(playerLoc(X,Y)), NewY is Y-1, asserta(playerLoc(X,NewY)),msg.
a :- state(normal),playerLoc(1,_), write('Border!'),nl,!.
a :- state(normal),retract(playerLoc(X,Y)), NewX is X-1, asserta(playerLoc(NewX,Y)),msg.
s :- state(normal),playerLoc(_,20), write('Border!'),nl,!.
s :- state(normal),retract(playerLoc(X,Y)), NewY is Y+1, asserta(playerLoc(X,NewY)),msg.
d :- state(normal),playerLoc(20,_), write('Border!'),nl,!.
d :- state(normal),retract(playerLoc(X,Y)), NewX is X+1, asserta(playerLoc(NewX,Y)),msg.

msg :-
    playerLoc(10,5),
    write('Your are at (10,5).'),nl,
    write('Type `shop.` to access shop.'),nl,!.
msg :-
    playerLoc(5,5),
    write('Your are at (5,5).'),nl,
    write('Type `quest.` to access quest log.'),nl,!.
msg :-
    playerLoc(X,Y),
    format("You are at (~w,~w). ~n", [X,Y]).
