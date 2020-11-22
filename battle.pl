:- include('enemy.pl').

%inisialisasi initialisasi
initbattle:-
  stat(slime,Enemy_HP,Enemy_Attack,Enemy_Defence,Enemy_Special),
  asserta(enemy_max_HP(Enemy_HP)),
  asserta(enemy_curr_HP(Enemy_HP)),
  asserta(enemy_base_defense(Enemy_Defence)),
  asserta(enemy_base_attack(Enemy_Attack)),
  asserta(enemy_special_attack(Enemy_Special)).


%basis
add_curr_HP_enemy(Added_curr_Hp):-
  enemy_curr_HP(HP),
  HP =< 0,
  write('Enemy DEAD').

add_curr_HP_enemy(Added_curr_Hp):-
  enemy_max_HP(Max_HP),
  enemy_curr_HP(Temp_Curr_Hp),
  FinalHp is Temp_Curr_Hp + Added_curr_Hp,
  Max_HP >= FinalHp,
  retract(enemy_curr_HP(Curr_Hp)),
  asserta(enemy_curr_HP(FinalHp)).

%enemy_attack:-

usePotion:- %Potionnya ga ada
    inventory(X),
  	count('Health Potion',X,CountItem),
    CountItem == 0,
    write('You dont have potion').
usePotion:- %healthpotion
	add_curr_HP(50), %tambah 50 HP ke player
	delete_item('Health Potion'). %hilangin 1 healthpotion di list
