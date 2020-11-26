:- include('enemy.pl').
:- dynamic(curr_enemy/1).
%inisialisasi initialisasi
initbattle(Monster):-
  stat(Monster,Enemy_HP,Enemy_Attack,Enemy_Defence,Enemy_Special),
  asserta(curr_enemy(Monster)),
  asserta(enemy_max_HP(Enemy_HP)),
  asserta(enemy_curr_HP(Enemy_HP)),
  asserta(enemy_base_defense(Enemy_Defence)),
  asserta(enemy_base_attack(Enemy_Attack)),
  asserta(enemy_special_attack(Enemy_Special)).
  format("Enemy is approaching: ~w ~n",[Monster]),
check_dead_enemy:-
  enemy_curr_HP(X),
  X =< 0,
  write('Enemey is dead.').

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
  add_curr_HP(FinalDamageEnemy).

enemy_special_attack:-
  curr_enemy(Enemy),
  stat(Enemy,_,_,_,X),
  add_curr_HP(-X).

player_attack:-
  curr_enemy(Enemy),
  stat(Enemy,_,_,Y,_),
  base_attack(BaseAttack),
  equip_weapon(_,WeaponAtt,_),
  random(1,5,BonusDamage),
  DamagePlayer is BaseAttack+BonusDamage+0.2*WeaponAtt,
  FinalDamagePlayer is -1*(DamagePlayer - 0.3*Y),
  FinalDamagePlayer < 0,
  add_curr_HP_enemy(FinalDamagePlayer).
player_special_attack:-
  curr_enemy(Enemy),
  stat(Enemy,_,_,Y,_),
  special_attack(SpecialAttack),
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
