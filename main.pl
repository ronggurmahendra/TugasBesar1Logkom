:- include('player.pl').
:- include('map.pl').
:- include('shop.pl').
:- include('battle.pl').
/*Win Condition*/
:- dynamic(state/1).
state(menu).
% state(normal).
/*Cek apakah sudah menang/kalah*/

menu:-
  write('Welcome!Type start. to begin your adventure'),nl.
state(menu):-
  write('Menu: start'),nl.
state(battle_player):-
  write('Your turn').
state(battle_enemy):-
  write('Enemy turn').
state(shop):-
  write('Gacha is available'),nl.
state(win):-
  write('Kamu sudah menang.'),nl.
state(lose):-
  write('YOU DIED.'),nl.
/*Start adventure*/
/*Save Load*/
/*Title*/
/*Help*/
/*Start of game*/

:- dynamic(option/1).
start:-
  state(menu),
  retract(state(_)),
  asserta(state(normal)),
  write('Welcome, choose your job.'),nl,
  write('1. Swordsman'),nl,
  write('2. Archer'),nl,
  write('3. Sorcered'),nl,
  read(X),
  option(X),
  asserta(job(X)).
  % ceritanya nanti choose job, ini nantinya ada di player.pl
  % setup starting equipment
option(1):-
  write('You choose swordsman, let`s explore the world!'),nl,
  asserta(equip_weapon(beginnerSword,5,1)),
  asserta(equip_armor(beginnerPlate,5,1)),
  asserta(equip_acc(none,0,0,0,0)),
  asserta(inventory(['Health Potion','Health Potion','Health Potion','Health Potion','Health Potion'])).
option(2):-
  write('You choose archer, let`s explore the world!'),nl,
  asserta(equip_weapon(beginnerBow,5,2)),
  asserta(equip_armor(beginnerLeather,5,2)),
  asserta(equip_acc(none,0,0,0,0)),
  asserta(inventory(['Health Potion','Health Potion','Health Potion','Health Potion','Health Potion'])).
option(3):-
  write('You choose sorcerer, let`s explore the world!'),nl,
  asserta(equip_weapon(beginnerStaff,5,3)),
  asserta(equip_armor(beginnerRobe,5,3)),
  asserta(equip_acc(none,0,0,0,0)),
  asserta(inventory(['Health Potion','Health Potion','Health Potion','Health Potion','Health Potion'])).
option(_):-
  write('False.'),nl.

help:-
  write('1.map,2.status,3.map,4.status,5.shop(saat di shop),6.quit'),nl.

map:-
  state(normal),
  forall(between(0,21,Y), (forall(between(0,21,X), tulispeta(X,Y)),nl)),nl.
  % tulis peta, ada di peta.pl

status:-
  % status player di player.pl
  state(normal),
  write('Your status:'),nl,
  job(Job),
  class(Job,JobName),
  format("Job: ~w ~n",[JobName]),
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

quit:-
  state(normal),
  retract(equip_weapon(_,_,_)),
  retract(equip_armor(_,_,_)),
  retract(equip_acc(_,_,_,_,_)),
  retract(job(_)),
  retract(state(_)),
  asserta(state(menu)).
