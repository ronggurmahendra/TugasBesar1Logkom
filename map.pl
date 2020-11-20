:- dynamic(playerLoc/2).

%fact lokasi penting
playerLoc(10,10).
store(10,5).
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
tulispeta(X,Y) :- store(X,Y), write('S').
tulispeta(X,Y) :- dungeonBoss(X,Y), write('D').
tulispeta(X,Y) :- questLoc(X,Y), write('Q').
tulispeta(X,Y) :- activeArea(X,Y), write('-').

% move player
w :- retract(playerLoc(X,Y)), NewY is Y-1, asserta(playerLoc(X,NewY)).
a :- retract(playerLoc(X,Y)), NewX is X-1, asserta(playerLoc(NewX,Y)).
s :- retract(playerLoc(X,Y)), NewY is Y+1, asserta(playerLoc(X,NewY)).
d :- retract(playerLoc(X,Y)), NewX is X+1, asserta(playerLoc(NewX,Y)).
