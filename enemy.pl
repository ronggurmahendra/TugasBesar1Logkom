%dynamic variable enemy
:-dynamic(enemy_max_HP/1).
:-dynamic(enemy_curr_HP/1).
:-dynamic(enemy_base_defense/1).
:-dynamic(enemy_base_attack/1).
:-dynamic(enemy_special_attack/1).

%tipe musuh + exp musuh + base gold
enemy_drop(slime,20,100).
enemy_drop(goblin,40,200).
enemy_drop(wolf,80,300).
enemy_drop('EvilDragon',1000000,1000000).

%stat(Tipe_Enemy,max_HP,base_attack,base_defense,special_attack)
stat(slime,35,5,2,10).
stat(goblin,50,8,3,14).
stat(wolf,75,12,5,20).
stat('EvilDragon',200,50,40,70).
%drop
dropTable(slime,[slimeSword,slimeStaff,slimeBow,healthPotion,healthPotion]).
dropTable(wolf,[wolfSword,wolfStaff,wolfBow,healthPotion,healthPotion]).
dropTable(goblin,[goblinSword,goblinStaff,goblinBow,healthPotion,healthPotion]).
dropTable('EvilDragon',[dragonSword,dragonStaff,dragonBow,healthPotion,healthPotion]).
