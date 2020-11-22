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

slime_attack:-
  stat(slime,_,X,_,_),
  equip_armor(Armor,Y,_),
  add_curr_HP(-1*X-(0.3*(Y+10))).%DAMAGE : (BaseDamageEnemey)-(0.3*DEFENSE)
slime_special_attack:-
  %hitung turn buat special attack
  stat(slime,_,_,_,X),
  equip_armor(Armor,Y,_),
  add_curr_HP(-1*X-(0.3*(Y+10))).%DAMAGE : 10
goblin_attack:-
  stat(goblin,_,X,_,_),
  equip_armor(Armor,Y,_),
  add_curr_HP(-1*X-(0.3*(Y+10))).
goblin_special_attack:-
  %hitung turn buat special attack
  stat(goblin,_,_,_,X),
  equip_armor(Armor,Y,_),
  add_curr_HP(-1*X-(0.3*(Y+10))).
wolf_attack:-
  stat(wolf,_,X,_,_),
  equip_armor(Armor,Y,_),
  add_curr_HP(-1*X-(0.3*(Y+10))).
wolf_special_attack:-
  %hitung turn buat special attack
  stat(wolf,_,_,_,X),
  equip_armor(Armor,Y,_),
  add_curr_HP(-1*X-(0.3*(Y+10))).

enemy_drop(_,X,Y):-
  random(1,20,BonusGold),
  FinalGold is BonusGold+Y,
  add_gold(FinalGold),
  get_exp(X).

usePotion:- %Potionnya ga ada
    inventory(X),
  	count('Health Potion',X,CountItem),
    CountItem == 0,
    write('You dont have potion').
usePotion:- %healthpotion
	add_curr_HP(50), %tambah 50 HP ke player
	delete_item('Health Potion'). %hilangin 1 healthpotion di list
