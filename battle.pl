:- include('enemy.pl').
:- dynamic(curr_enemy/1).
:- dynamic(player_cooldown/1).
:- dynamic(enemy_cooldown/1).
%inisialisasi initialisasi

player_cooldown(0).
enemy_cooldown(0).

% slime,wolf,goblin
initbattle(Monster):-
  % manajemen state
  retract(state(_)),
  asserta(state(battle)),
  stat(Monster,Enemy_HP,Enemy_Attack,Enemy_Defence,Enemy_Special),
  level(Level),
  asserta(curr_enemy(Monster)),
  Temp_HP is Enemy_HP + Level*2,
  asserta(enemy_max_HP(Temp_HP)),
  asserta(enemy_curr_HP(Temp_HP)),
  Temp_Defence is Enemy_Defence + Level,
  asserta(enemy_base_defense(Temp_Defence)),
  Temp_Attack is Enemy_Attack + Level,
  asserta(enemy_base_attack(Temp_Attack)),
  Temp_Special is Enemy_Special + Level,
  asserta(enemy_special_attack(Temp_Special)),
  format("Enemy is approaching: ~w ~n",[Monster]),
  format("Level: ~w ~n",[Level]),
  format("Health: ~w ~n",[Temp_HP]),
  format("Attack: ~w ~n",[Temp_Attack]),
  format("Defense: ~w ~n",[Temp_Defence]).

check_dead_enemy:-
  enemy_curr_HP(X),
  X =< 0,
  % manajemen state
  retract(curr_enemy(_)),
  retract(enemy_max_HP(_)),
  retract(enemy_curr_HP(_)),
  retract(enemy_base_defense(_)),
  retract(enemy_base_attack(_)),
  retract(enemy_special_attack(_)),
  retract(enemy_cooldown(_)),
  asserta(enemy_cooldown(0)),
  retract(player_cooldown(_)),
  asserta(player_cooldown(0)),
  retract(state(_)),
  asserta(state(normal)),
  write('Enemy is dead.').
%if not dead enemy attack

add_curr_HP_enemy(Added_curr_Hp):- %buat ngeattack enemy
  enemy_max_HP(Max_HP),
  enemy_curr_HP(Temp_Curr_Hp),
  FinalHp is Temp_Curr_Hp + Added_curr_Hp,
  Max_HP >= FinalHp,
  retract(enemy_curr_HP(Curr_Hp)),
  asserta(enemy_curr_HP(FinalHp)),
  check_dead_enemy.
 %  DAMAGE : -1*(BaseDamageEnemey + BonusDamage)+(0.2*BaseDefence+BonusDefence(armor))

enemy_attack:-
  curr_enemy(Enemy),
  stat(Enemy,_,X,_,_),
  random(1,5,BonusDamage),
  FinalDamage is BonusDamage+X,
  base_defense(Z),
  equip_armor(Armor,Y,_),
  FinalDefencePlayer is 0.2*(Y+Z),
  FinalDamageEnemy is -1*FinalDamage+(FinalDefencePlayer),
  FinalDamageEnemy < 0,
  PrintDamage is -1*FinalDamageEnemy,
  format("~w deal ~w damage ~n",[Enemy,PrintDamage]),
  add_curr_HP(FinalDamageEnemy).

enemy_special_attack:-
  curr_enemy(Enemy),
  enemy_cooldown(0),
  stat(Enemy,_,_,_,X),
  format("~w deal ~w damage ~n",[Enemy,X]),
  add_curr_HP(-X).

player_attack:-
  state(battle),
  curr_enemy(Enemy),
  stat(Enemy,_,_,Y,_),
  base_attack(BaseAttack),
  equip_weapon(_,WeaponAtt,_),
  random(1,5,BonusDamage),
  DamagePlayer is BaseAttack+BonusDamage+0.2*WeaponAtt,
  FinalDamagePlayer is -1*(DamagePlayer - 0.3*Y),
  FinalDamagePlayer < 0,
  PrintDamage is -1*FinalDamagePlayer,
  format("You deal ~w damage ~n",[PrintDamage]),
  add_curr_HP_enemy(FinalDamagePlayer).
player_special_attack:-
  state(battle),
  player_cooldown(0),
  curr_enemy(Enemy),
  stat(Enemy,_,_,Y,_),
  special_attack(SpecialAttack),
  PrintDamage is -1*SpecialAttack,
  write('You use your special attack.'),ln,
  format("You deal ~w damage ~n",[PrintDamage]),
  add_curr_HP_enemy(-SpecialAttack).

/*
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
*/
enemy_drop(_,X,Y):-
  random(1,20,BonusGold),
  FinalGold is BonusGold+Y,
  add_gold(FinalGold), %final gold = BaseGoldEnemey + RandomBonusGold
  get_exp(X).

usePotion:- %Potionnya ga ada
    inventory(X),
  	count('Health Potion',X,CountItem),
    CountItem == 0,
    write('You dont have potion').
usePotion:- %healthpotion
	add_curr_HP(50), %tambah 50 HP ke player
	delete_item('Health Potion'). %hilangin 1 healthpotion di list
