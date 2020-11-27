% :-dynamic(max_HP/1).
% :-dynamic(curr_HP/1).
% :-dynamic(base_defense/1).
% :-dynamic(base_attack/1).
% :-dynamic(special_attack/1).
% :-dynamic(level/1).
% :-dynamic(experience/1).
% :-dynamic(inventory/1).
% :-dynamic(gold/1).
% :-dynamic(equip_weapon/3).
% :-dynamic(equip_armor/3).
% :-dynamic(equip_acc/5).
% :-dynamic(job/1).
% :-dynamic(count_item/1).
% :-dynamic(playerLoc/2).
% save(MaxHP,CurrHP,BaseDefense,BaseAttack,SpecialAttack,Level,Experience,Inventory,Gold,EquipWeapon,EquipArmor,EquipAcc,Job,CountItem,PlayerLocX,PlayerLocY).

save:-
  state(normal),
  open('save_file.txt',write,Stream),
  max_HP(MaxHP),
  curr_HP(CurrHP),
  base_defense(BaseDefense),
  base_attack(BaseAttack),
  special_attack(SpecialAttack),
  level(Level),
  experience(Experience),
  inventory(Inventory),
  gold(Gold),
  equip_weapon(EquipWeapon,_,_),
  equip_armor(EquipArmor,_,_),
  equip_acc(EquipAcc,_,_,_,_),
  job(Job),
  count_item(CountItem),
  playerLoc(PlayerLocX,PlayerLocY),
  write(Stream,save(MaxHP,CurrHP,BaseDefense,BaseAttack,SpecialAttack,Level,Experience,Inventory,Gold,EquipWeapon,EquipArmor,EquipAcc,Job,CountItem,PlayerLocX,PlayerLocY)),
  write(Stream,'.'),
  retract(state(_)),
  asserta(state(menu)),
  write('Save berhasil, kembali ke menu'),
  close(Stream).

load:-
  state(menu),
  open('save_file.txt',read,Stream),
  %format("~w~n",[Stream]),
  read(Stream,In),
  asserta(In),
  save(MaxHP,CurrHP,BaseDefense,BaseAttack,SpecialAttack,Level,Experience,Inventory,Gold,EquipWeapon,EquipArmor,EquipAcc,Job,CountItem,PlayerLocX,PlayerLocY),
  
  asserta(max_HP(MaxHP)),
  asserta(curr_HP(CurrHP)),
  asserta(base_defense(BaseDefense)),
  asserta(base_attack(BaseAttack)),
  asserta(special_attack(SpecialAttack)),
  asserta(level(Level)),
  asserta(experience(Experience)),
  asserta(inventory(Inventory)),
  asserta(gold(Gold)),
  weapon(EquipWeapon,WAttack,_),
  asserta(equip_weapon(EquipWeapon,WAttack,Job)),
  armor(EquipArmor,ADefense,_),
  asserta(equip_armor(EquipArmor,ADefense,Job)),
  accessory(EquipAcc,A1,A2,A3,A4),
  asserta(equip_acc(EquipAcc,A1,A2,A3,A4)),
  asserta(job(Job)),
  asserta(count_item(CountItem)),
  retract(playerLoc(_,_)),
  asserta(playerLoc(PlayerLocX,PlayerLocY)),
  retract(state(_)),
  asserta(state(normal)),
  write('Load berhasil, memulai petualangan'),
  retract(save(MaxHP,CurrHP,BaseDefense,BaseAttack,SpecialAttack,Level,Experience,Inventory,Gold,EquipWeapon,EquipArmor,EquipAcc,Job,CountItem,PlayerLocX,PlayerLocY)),
  close(Stream).
