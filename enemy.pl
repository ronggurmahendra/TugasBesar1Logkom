%dynamic variable enemy
:-dynamic(enemy_max_HP/1).
:-dynamic(enemy_curr_HP/1).
:-dynamic(enemy_base_defense/1).
:-dynamic(enemy_base_attack/1).
:-dynamic(enemy_special_attack/1).

%sementara random disini dlu, masukin di win state di battle.pl
random(1,20,TempGold).
FinalGoldSlime is TempGold+100.
FinalGoldGoblin is TempGold+200.
FinalGoldWolf is TempGold+300.
%tipe musuh + exp musuh + gold
enemy_drop(slime,10,FinalGoldSlime).
enemy_drop(goblin,20,FinalGoldGoblin).
enemy_drop(wolf,25,FinalGoldWolf).

%stat(Tipe_Enemy,max_HP,base_attack,base_defense,special_attack)
stat(slime,35,5,2,10).
stat(goblin,50,8,3,14).
stat(wolf,75,5,2,10).
