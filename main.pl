/*Win Condition*/
:- dynamic(state/1).
state(normal).
% :- dynamic state(win).
% :- dynamic state(lose).
/*Cek apakah sudah menang/kalah*/
state(X):-
  state(win),
  write("Kamu sudah menang."),nl.
state(X):-
  state(lose),
  write("YOU DIED."),nl.
/*Start adventure*/
/*Save Load*/
main:-write("Mulai adventure."),nl.
/*Title*/
/*Help*/
/*Start of game*/
:- dynamic(option/1).
start:-
  write("Welcome, choose your job."),nl.
  read(X),
  asserta(option(X)),
  asserta(job(X)).
  % ceritanya nanti choose job, ini nantinya ada di player.pl
  % setup starting equipment
option(X):-
  option(1),
  write("You choose swordsman, let’s explore the world"),nl.
option(X):-
  option(2),
  write("You choose archer, let’s explore the world"),nl.
option(X):-
  option(3),
  write("You choose sorcerer, let’s explore the world"),nl.
map:-
  tulispeta(true).
  % ceritanya tulis peta, ini nantinya ada di peta.pl
status:-
  % placeholder fact
  write("Your status:"),nl,
  job(Job),
  format('Job: ~w ~n',[Job]),
  level(Level),
  write("Level: ~w ~n",[Level]),
  health(Health),
  write("Health: ~w ~n",[Health]),
  attack(Attack),
  write("Attack: ~w ~n",[Attack]),
  defense(Defense),
  write("Defense: ~w ~n",[Defense]),
  experience(Experience),
  write("Experience: ~w ~n",[Experience]),
  % inventory
  experience(Gold),
  write("Gold: ~w ~n",[Gold]).

equipment:-
  %nanti ada di equipment
