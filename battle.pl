:- include('enemy.pl').
:- dynamic(curr_enemy/1).
:- dynamic(player_cooldown/1).
:- dynamic(enemy_cooldown/1).
:- dynamic(enemy_now/1).
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
  %format("Enemy is approaching: ~w ~n",[Monster]),
  format("Level: ~w ~n",[Level]),
  format("Health: ~w ~n",[Temp_HP]),
  format("Attack: ~w ~n",[Temp_Attack]),
  format("Defense: ~w ~n",[Temp_Defence]),nl,
  format("What will you do:~n1.attack~n2.special_attack~n3.usePotion~n4.run",[]).
initBoss :-
	retract(state(_)),
	asserta(state(battle)),
	stat('EvilDragon',Enemy_HP,Enemy_Attack,Enemy_Defence,Enemy_Special),
	asserta(curr_enemy('EvilDragon')),
	asserta(enemy_max_HP(Enemy_HP)),
	asserta(enemy_curr_HP(Enemy_HP)),
	asserta(enemy_base_defense(Enemy_Defence)),
	asserta(enemy_base_attack(Enemy_Attack)),
	asserta(enemy_special_attack(Enemy_Special)),
	format("Enemy is approaching: ~w ~n",['EvilDragon']),
	format("Level: ~w ~n",[70]),
	format("Health: ~w ~n",[Enemy_HP]),
	format("Attack: ~w ~n",[Enemy_Attack]),
	format("Defense: ~w ~n",[Enemy_Defence]),nl,
	format("What will you do:~n1.attack~n2.special_attack~n3.usePotion~n4.run",[]).
check_dead_enemy:-
  enemy_curr_HP(X),
  X =< 0,
  % manajemen state
  reward,
  % curr_enemy(Enemy),
  retract(curr_enemy(Enemy)),
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

  write('Enemy is dead.'),nl,

  item_drop(Enemy),
  retract(enemy_now(_)).
  
%if not dead enemy attack
check_dead_enemy:-
  enemy_now(true),
  enemy_curr_HP(X),
  X > 0,
  curr_enemy(Enemy),
  enemy_curr_HP(HP),
  enemy_max_HP(MaxHP),
  format("Current enemy: ~w ~2f/~w HP~n",[Enemy,HP,MaxHP]).

add_curr_HP_enemy(Added_curr_Hp):- %buat ngeattack enemy
  enemy_max_HP(Max_HP),
  enemy_curr_HP(Temp_Curr_Hp),
  FinalHp is Temp_Curr_Hp + Added_curr_Hp,
  % Max_HP >= FinalHp,
  retract(enemy_curr_HP(Curr_Hp)),
  asserta(enemy_curr_HP(FinalHp)),
  check_dead_enemy.
 %  DAMAGE : -1*(BaseDamageEnemey + BonusDamage)+(0.2*BaseDefence+BonusDefence(armor))

enemy_turn:-
  enemy_now(true),
  enemy_cooldown(X),
  X == 0,
  random(1,3,HasilRandom),
  enemy_option(HasilRandom),!.
enemy_turn:-
  enemy_now(true),
  enemy_cooldown(X),
  X > 0,
  enemy_option(1),!.
enemy_turn :- !.

enemy_option(1):-
  enemy_attack,
  cooldown_management(1), %1 for player 2 for enemy
  cooldown_management(2).
enemy_option(2):-
  enemy_special_attack,
  cooldown_management(1),
  cooldown_management(2).

cooldown_management(1):-
  player_cooldown(X),
  X == 0,!.
cooldown_management(1):-
  player_cooldown(X),
  FinalCD is X - 1,
  retract(player_cooldown(_)),
  asserta(player_cooldown(FinalCD)).

cooldown_management(2):-
  enemy_cooldown(X),
  X == 0,!.
cooldown_management(2):-
  enemy_cooldown(X),
  FinalCD is X - 1,
  retract(enemy_cooldown(_)),
  asserta(enemy_cooldown(FinalCD)).

enemy_attack:-
  curr_enemy(Enemy),
  stat(Enemy,_,X,_,_),
  random(1,5,BonusDamage),
  FinalDamage is BonusDamage+X,
  base_defense(Z),
  equip_armor(_,ArmDef,_),
  accessory(_,_,AccDef,_,_),
  FinalDefencePlayer is 0.2*(ArmDef+Z+AccDef),
  FinalDamageEnemy is -1*FinalDamage+(FinalDefencePlayer),
  FinalDamageEnemy < 0,
  PrintDamage is -1*FinalDamageEnemy,
  format("~w deal ~2f damage ~n",[Enemy,PrintDamage]),
  retract(enemy_now(_)),
  add_curr_HP(FinalDamageEnemy).

enemy_special_attack:-
  curr_enemy(Enemy),
  stat(Enemy,_,_,_,X),
  format("~w use special attack deal ~2f damage ~n",[Enemy,X]),
  retract(enemy_cooldown(_)),
  asserta(enemy_cooldown(3)),
  retract(enemy_now(_)),
  add_curr_HP(-X).

attack:-
  state(battle),
  curr_enemy(Enemy),
  stat(Enemy,_,_,Y,_),
  base_attack(BaseAttack),
  equip_weapon(_,WeaponAtt,_),
  accessory(_,AccAtt,_,_,_),
  random(1,5,BonusDamage),
  DamagePlayer is BaseAttack+BonusDamage+0.2*(WeaponAtt + AccAtt),
  FinalDamagePlayer is -1*(DamagePlayer - 0.3*Y),
  FinalDamagePlayer < 0,
  PrintDamage is -1*FinalDamagePlayer,
  format("You deal ~2f damage ~n",[PrintDamage]),
  asserta(enemy_now(true)),
  add_curr_HP_enemy(FinalDamagePlayer),
  enemy_turn,!.

special_attack:-
  player_cooldown(X),
  X > 0,
  format("You still have ~w turn cooldown ~n",[X]),!.

special_attack:-
  state(battle),
  player_cooldown(X),
  X == 0,
  curr_enemy(Enemy),
  stat(Enemy,_,_,Y,_),
  special_attack(SpecialAttack),
  PrintDamage is SpecialAttack,
  write('You use your special attack.'),nl,
  format("You deal ~2f damage ~n",[PrintDamage]),
  asserta(enemy_now(true)),
  add_curr_HP_enemy(-SpecialAttack),
  retract(player_cooldown(_)),
  asserta(player_cooldown(3)),
  enemy_turn,!.

reward:-
  enemy_now(true),
  curr_enemy(Enemy),
  \+(Enemy == 'EvilDragon'),
  enemy_drop(Enemy,X,Y),
  random(1,20,BonusGold),
  FinalGold is BonusGold+Y,
  add_gold(FinalGold), %final gold = BaseGoldEnemey + RandomBonusGold
  quest_progress(Enemy),
  get_exp(X).
reward :- !.


item_drop(Enemy):-
  enemy_now(true),
  Enemy == 'EvilDragon',
  %write('YOU HAVE WON!!!!!!!!!!'),nl,
  print_file('YouHaveWon.txt'),
  quit,!.
  
item_drop(Enemy):-
  enemy_now(true),
    \+(Enemy == 'EvilDragon'),
  %write('item drop'),nl,
	% curr_enemy(Enemy),
	dropTable(Enemy,DropList),
	random(0,4,DropRandom),
	getElmt(DropList,DropRandom,Elmt),
	format("the ~w drop ~w ~n",[Enemy,Elmt]),
	add_item(Elmt),!.

usePotion:- %Potionnya ga ada
    inventory(X),
  	count(healthPotion,X,CountItem),
    CountItem == 0,
    write('You dont have potion').
usePotion:- %healthpotion
	add_curr_HP(50), %tambah 50 HP ke player
  write('You heal 50 HP!'),nl,
	delete_item(healthPotion). %hilangin 1 healthpotion di list

run:-
	random(1,10,ChanceRun),
	runSuccess(ChanceRun).

runSuccess(ChanceRun):-
	ChanceRun < 7,
	write('you successfully run away'),nl,
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
  retract(enemy_now(_)).

runSuccess(ChanceRun):-
	ChanceRun >= 7,
	write('you fail to run away'),nl,
  asserta(enemy_now(true)),
	enemy_turn.

quest_progress(Enemy) :-
  Enemy == slime,
  questGoal(Sg,Gg,Wg),
  retract(quest(S,G,W)),
  (S < Sg -> NextS is S+1, asserta(quest(NextS,G,W)),! ; asserta(quest(S,G,W)),!).
  
quest_progress(Enemy) :-
  Enemy == goblin,
  questGoal(Sg,Gg,Wg),
  retract(quest(S,G,W)),
  (G < Gg -> NextG is G+1, asserta(quest(S,NextG,W)),! ; asserta(quest(S,G,W)),!).
  

quest_progress(Enemy) :-
  Enemy == wolf,
  questGoal(Sg,Gg,Wg),
  retract(quest(S,G,W)),
  (W < Wg -> NextW is W+1, asserta(quest(S,G,NextW)),! ; asserta(quest(S,G,W)),!).
  