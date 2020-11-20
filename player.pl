/*Untuk File Player.pl*/ 

:-dynamic(max_HP/1).
:-dynamic(curr_HP/1).
:-dynamic(base_defense/1).
:-dynamic(base_attack/1).
:-dynamic(special_Attack/1).
:-dynamic(level/1).
:-dynamic(experience/1).


level(1).
experience(0).
max_HP(100).
curr_HP(100).
base_attack(10).
special_attack(30).
base_defense(10).

equip_weapon(dull_sword).
equip_armor(iron_plate).
equip_acc(none).
gold(0).


level_up :-
	retract(level(X)), Temp is X+1, asserta(level(Temp)),
	retract(max_HP(X)), Temp is X+10, asserta(max_HP(Temp)),
	retract(base_attack(X)), Temp is X+1, asserta(attack(Temp)),
	retract(special_attack(X)), Temp is X+2, asserta(special_attack(Temp)),
	retract(base_defense(X)), Temp is X+1, asserta(base_defense(Temp)),
	retract(experience(X)), asserta(experience(0)).