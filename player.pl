/*Untuk File Player.pl*/ 

:-dynamic(player/7).

:-dynamic(max_HP/1).
max_HP(0).
:-dynamic(curr_HP/1).

:-dynamic(defence/1).

:-dynamic(attack/1).
:-dynamic(special_Attack/1).

:-dynamic(level/1).
level(0).
:-dynamic(experience/1).


hp(swordman, 200).
hp(archer, 150).
hp(sorcerer, 100).



add_level(X):-
	retract(level(Y)),Temp is Y+X,asserta(level(Temp)).