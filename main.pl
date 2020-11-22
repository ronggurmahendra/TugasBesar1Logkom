:- include('player.pl').
:- include('map.pl').
:- include('shop.pl').
:- include('battle.pl').
/*Win Condition*/
:- dynamic(state/1).
%state(menu). belum diimplementasikan
state(normal).
/*Cek apakah sudah menang/kalah*/
%state(battle_player):-
%state(battle_enemy):-
%state(shop):-
state(win):-
  write('Kamu sudah menang.'),nl.
state(lose):-
  write('YOU DIED.'),nl.
/*Start adventure*/
/*Save Load*/
main:-write('Mulai adventure.'),nl.
/*Title*/
/*Help*/
/*Start of game*/

:- dynamic(option/1).
start:-
  write('Welcome, choose your job.'),nl,
  write('1. Swordsman'),nl,
  write('2. Archer'),nl,
  write('3. Sorcered'),nl,
  read(X),
  option(X),
  retract(job(_)),
  asserta(job(X)).
  % ceritanya nanti choose job, ini nantinya ada di player.pl
  % setup starting equipment
option(1):-
  write('You choose swordsman, let`s explore the world!'),nl.
option(2):-
  write('You choose archer, let`s explore the world!'),nl.
option(3):-
  write('You choose sorcerer, let`s explore the world!'),nl.
option(_):-
  write('False.'),nl.

map:-
  forall(between(0,21,Y), (forall(between(0,21,X), tulispeta(X,Y)),nl)),nl.
  % tulis peta, ada di peta.pl

status:-
  % placeholder fact
  write('Your status:'),nl,
  job(Job),
  format("Job: ~w ~n",[Job]),
  level(Level),
  format("Level: ~w ~n",[Level]),
  curr_HP(CurrHP), max_HP(MaxHP),
  format("Health: ~w/~w ~n",[CurrHP, MaxHP]),
  base_attack(Attack),
  equip_weapon(Weapon,X,_),
  equip_acc(Acc,A,B,_,_),
  TempAttack is X+A,
  format("Attack: ~w (+~w) ~n",[Attack,TempAttack]),
  special_attack(SAttack),
  format("Special Attack: ~w ~n",[SAttack]),
  base_defense(Defense),
  equip_armor(Armor,Y,_),
  TempDefense is Y+B,
  format("Defense: ~w (+~w)~n",[Defense,TempDefense]),
  experience(Experience),
  format("Experience: ~w ~n ~n",[Experience]),
  % inventory
  write('Equipment:'),nl,
  gold(Gold),
  format("Gold: ~w ~n",[Gold]),
  equip_weapon(Weapon,X,_), equip_armor(Armor,Y,_), equip_acc(Acc,A,B,_,_),
  format("Weapon: ~w ~n", [Weapon]),
  format("Armor: ~w ~n", [Armor]),
  format("Accessory: ~w ~n", [Acc]),!.
