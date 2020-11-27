/*Untuk File Player.pl*/

:-dynamic(max_HP/1).
:-dynamic(curr_HP/1).
:-dynamic(base_defense/1).
:-dynamic(base_attack/1).
:-dynamic(special_attack/1).
:-dynamic(level/1).
:-dynamic(experience/1).
:-dynamic(inventory/1).
:-dynamic(gold/1).
:-dynamic(equip_weapon/3).
:-dynamic(equip_armor/3).
:-dynamic(equip_acc/5).
:-dynamic(job/1).
:-dynamic(count_item/1).
% job(1).
/*
class 0 all
class 1 swordman
class 2 archer
class 3 sorcerer
*/
/*weapon(weapon,damageValue,Class)*/
weapon(beginnerSword,5,1).
weapon(longsword,8,1).
weapon(lamentSword,12,1).
weapon(totsukaBlade,18,1).
weapon(excalibur,24,1).

weapon(beginnerBow,5,2).
weapon(longbow,8,2).
weapon(pleiadesBow,12,2).
weapon(zephyrBow,18,2).
weapon(quintessenceBow,24,2).

weapon(beginnerStaff,5,3).
weapon(magicStaff,8,3).
weapon(wabbajack,12,3).
weapon(sanguineRose,18,3).
weapon(shadebinder,24,3).

weaponList([beginnerSword,beginnerBow,beginnerStaff,longsword,lamentSword,totsukaBlade,excalibur,longbow,pleiadesBow,zephyrBow,quintessenceBow,magicStaff,wabbajack,sanguineRose,shadebinder]).
/*armor(weapon,defenseValue,class)*/
armor(beginnerPlate,5,1).
armor(ironPlate,8,1).
armor(phoenixPlate,10,1).
armor(stronghold,15,1).

armor(beginnerLeather,5,2).
armor(stalkerVest,8,2).
armor(frumiousVest,10,2).
armor(gwisinVest,15,2).

armor(beginnerRobe,5,3).
armor(dreambaneRobes,8,3).
armor(calamityRobes,10,3).
armor(icefallMantle,15,3).

armorList([beginnerPlate,beginnerLeather,beginnerRobe,ironPlate,phoenixPlate,stronghold,stalkerVest,frumiousVest,gwisinVest,dreambaneRobes,calamityRobes,icefallMantle]).
/*equipment(weapon,damageValue,defenseValue,MaxHP,class)*/
accessory(none,0,0,0,0).
accessory(beltOfGiantStrengh,15,0,0,0).
accessory(bracersOfDefence,0,15,0,0).
accessory(amuletOfHealth,0,0,15,0).
accessory(dibellaAmulet,0,0,3,0).
accessory(gargoyleAmulet,0,3,0,0).
accessory(bloodlustAmulet,3,0,0,0).
accessory(ariculationAmulet,2,2,2,0).
accessory(exileCloak,0,0,10,0).
accessory(holdfastMark,0,10,0,0).
accessory(greatHuntBond,10,0,0,0).
accessory(crystalOfStrength,8,8,8,0).

accessoryList([beltOfGiantStrengh,bracersOfDefence,amuletOfHealth,dibellaAmulet,gargoyleAmulet,bloodlustAmulet,ariculationAmulet,exileCloak,holdfastMark,greatHuntBond,crystalOfStrength]).
/* Class Name */
class(0,Name):-
	Name = any.
class(1, Name) :-
	Name = swordsman.
class(2, Name) :-
	Name = archer.
class(3, Name) :-
	Name = sorcerer.

/*Level & EXP*/
get_exp(Added_Exp) :-
	retract(experience(Exp)),
	FinalXp is Exp + Added_Exp,
	asserta(experience(FinalXp)),
	level_up(FinalXp).

level_up(EXP) :-
	EXP >= 100,
	retract(level(Val_Level)),Temp_level is Val_Level+1,asserta(level(Temp_level)),
	add_max_HP(10),
	add_base_attack(1),
	add_special_attack(2),
	add_base_defense(1),
	format("YOU HAVE LEVEL UP ~w -> ~w ~n",[Val_Level,Temp_level]),
	retract(experience(Val_Exp)) ,FinalXp is Val_Exp - 100, asserta(experience(FinalXp)),
	level_up(FinalXp),!.
	
level_up(EXP) :- !.
level_up(EXP).
/*Inventory*/
push(Element,[],[Element]) :- !.
push(Element,[Head|Tail],[Head|Result]) :- push(Element,Tail,Result).

add_item(Item) :-
	count_item(Val_count_item),
	Val_count_item < 100,
	retract(count_item(Val_count_item)),
	Final_count_item is Val_count_item + 1,
	asserta(count_item(Final_count_item)),
	retract(inventory(Val_inventory)),
	push(Item,Val_inventory,Final_inventory),
	asserta(inventory(Final_inventory)),!.

add_item(Item) :-
	count_item(Val_count_item),!,
	Val_count_item >= 100,
	write('inventory Full'),nl.

delete_item(Item) :-
	retract(count_item(Val_count_item)),
	Final_count_item is Val_count_item - 1,
	asserta(count_item(Final_count_item)),

	retract(inventory(Val_inventory)),
	delete_item_(Val_inventory,Item,Final_inventory),
	asserta(inventory(Final_inventory)).

delete_item_([Head|Tail],Item,Result) :-
	Head == Item,
	Result = Tail.

delete_item_([Head|Tail],Item,[Head|Result]) :-
	\+(Head == Item),
	delete_item_(Tail,Item,Result).

delete_item_([],Item,Result) :-
	write('you dont have the Item').

check_dead:-
	curr_HP(X),
	X =< 0,
	write('You are dead.'),
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
	quit.

check_dead.

/*Stat Manipulation*/
add_max_HP(Added_Hp):-
	retract(max_HP(Hp)),
	Final_Max_Hp is Hp + Added_Hp,
	asserta(max_HP(Final_Max_Hp)).
%heal normal
add_curr_HP(Added_curr_Hp):-
	max_HP(Max_HP),
	curr_HP(Temp_Curr_Hp),
	FinalHp is Temp_Curr_Hp + Added_curr_Hp,
	Max_HP >= FinalHp,
	retract(curr_HP(Curr_Hp)),
	asserta(curr_HP(FinalHp)),
	check_dead.

%overheal
add_curr_HP(Added_curr_Hp):-
	max_HP(Max_HP),
	curr_HP(Temp_Curr_Hp),
	FinalHp is Temp_Curr_Hp + Added_curr_Hp,
	Max_HP < FinalHp,
	retract(curr_HP(Curr_Hp)),
	asserta(curr_HP(Max_HP)).

add_base_attack(Added_base_attack):-
	retract(base_attack(Base_attack)),
	Final_MaxBase_attack is Base_attack + Added_base_attack,
	asserta(base_attack(Final_MaxBase_attack)).

add_special_attack(Added_special_attack):-
	retract(special_attack(Special_attack)),
	Final_Special_attack is Special_attack + Added_special_attack,
	asserta(special_attack(Final_Special_attack)).

add_base_defense(Added_base_defense):-
	retract(base_defense(Base_defense)),
	Final_Base_defense is Base_defense + Added_base_defense,
	asserta(base_defense(Final_Base_defense)).

add_gold(Added_gold):-
	retract(gold(Gold)),
	Final_Gold is Gold + Added_gold,
	asserta(gold(Final_Gold)).


swap_weapon :-
	state(normal),
	write('Choose the weapon that you want to swap: '),nl,
	print_weapon,

	read(Input),
	inventory(List),
	isElmt(List,Input,Bool),
	(Bool == 0 -> write('You don`t have that item!'),nl,fail; !),
	weapon(Input, Dmg, Class),
	job(Class1),
	(Class \== Class1 -> write('You can`t equip item for different class!'),nl,fail; write('Weapon Swapped!'),nl,!),

	retract(equip_weapon(X,_,_)),
	asserta(equip_weapon(Input,Dmg,Class)),
	add_item(X),
	delete_item(Input).

swap_armor :-
	state(normal),
	write('Choose the armor that you want to swap: '),nl,
	print_armor,

	read(Input),
	inventory(List),
	isElmt(List,Input,Bool),
	(Bool == 0 -> write('You don`t have that item!'),nl,fail; !),
	armor(Input, Def, Class),
	job(Class1),
	(Class \== Class1 -> write('You can`t equip item for different class!'),nl,fail; write('Armor Swapped!'),nl,!),

	retract(equip_armor(X,_,_)),
	asserta(equip_armor(Input,Def,Class)),
	add_item(X),
	delete_item(Input).

swap_accessory :-
	state(normal),
	write('Choose the accessory that you want to swap: '),nl,
	print_accessory,

	read(Input),
	inventory(List),
	isElmt(List,Input,Bool),
	(Bool == 0 -> write('You don`t have that item'),nl,fail; write('Accessory Swapped!'),nl,!),
	accessory(Input, Dmg, Def, HP, Class),

	retract(equip_acc(X,_,_,_,_)),
	asserta(equip_acc(Input,Dmg,Def,HP,Class)),
	add_item(X),
	delete_item(Input).

%vvvvvvvvvvvvvvvvvvvvvvvv
print_inventory :-
	inventory(List),
	write('Your Inventory: '),nl,
	print_inventory_(List),!.

print_inventory_([Head|Tail]) :-
	weapon(Head, _, Class),
	class(Class, CName),
	count(Head,[Head|Tail],CountItem),
	deleteAllElmt(Head,Tail,DelResult),
	format("~w (~w) (~w) ~n",[Head, CName, CountItem]),
	print_inventory_(DelResult).

print_inventory_([Head|Tail]) :-
	armor(Head, _, Class),
	class(Class, CName),
	count(Head,[Head|Tail],CountItem),
	deleteAllElmt(Head,Tail,DelResult),
	format("~w (~w) (~w) ~n",[Head, CName, CountItem]),
	print_inventory_(DelResult).

print_inventory_([Head|Tail]) :-
	accessory(Head, _, _, _, Class),
	class(Class, CName),
	count(Head,[Head|Tail],CountItem),
	deleteAllElmt(Head,Tail,DelResult),
	format("~w (~w) (~w) ~n",[Head, CName, CountItem]),
	print_inventory_(DelResult).

print_inventory_([Head|Tail]) :-
	count(Head,[Head|Tail],CountItem),
	deleteAllElmt(Head,Tail,DelResult),
	format("~w (~w) ~n",[Head, CountItem]),
	print_inventory_(DelResult).

print_inventory_([]).
%^^^^^^^^^^^^^^^^^^^
%vvvvvvvvvvvvvvvvvvvvvvvv
print_weapon :-
	inventory(List),
	write('Your Weapon: '),nl,
	print_weapon_(List).

print_weapon_([Head|Tail]) :-
	weaponList(WeaponList),
	isElmt(WeaponList,Head,Bool),
	Bool == 1,
	weapon(Head, _, Class),
	class(Class, Name),
	format("~w (~w) ~n",[Head, Name]),
	print_weapon_(Tail).

print_weapon_([Head|Tail]) :-
	weaponList(WeaponList),
	isElmt(WeaponList,Head,Bool),
	Bool == 0,
	print_weapon_(Tail).


print_weapon_([]).
%^^^^^^^^^^^^^^^^^^^

%vvvvvvvvvvvvvvvvvvvvvvvv
print_armor :-
	inventory(List),
	write('Your Armor: '),nl,
	print_armor_(List).

print_armor_([Head|Tail]) :-
	armorList(ArmorList),
	isElmt(ArmorList,Head,Bool),
	Bool == 1,
	armor(Head, _, Class),
	class(Class, Name),
	format("~w (~w) ~n",[Head, Name]),
	print_armor_(Tail).

print_armor_([Head|Tail]) :-
	armorList(ArmorList),
	isElmt(ArmorList,Head,Bool),
	Bool == 0,
	print_armor_(Tail).


print_armor_([]).
%^^^^^^^^^^^^^^^^^^^

%vvvvvvvvvvvvvvvvvvvvvvvv
print_accessory :-
	inventory(List),
	write('Your Accessory: '),nl,
	print_accessory_(List).

print_accessory_([Head|Tail]) :-
	accessoryList(AccessoryList),
	isElmt(AccessoryList,Head,Bool),
	Bool == 1,
	accessory(Head,_,_,_,Class),
	class(Class, Name),
	format("~w (~w) ~n",[Head, Name]),
	print_accessory_(Tail).

print_accessory_([Head|Tail]) :-
	accessoryList(AccessoryList),
	isElmt(AccessoryList,Head,Bool),
	Bool == 0,
	print_accessory_(Tail).


print_accessory_([]).
%^^^^^^^^^^^^^^^^^^^
inventory :-
	state(normal),
	inventory([Head|Tail]),
	inventory_([Head|Tail]).
inventory :-
	state(shop),
	inventory([Head|Tail]),
	inventory_([Head|Tail]).
inventory :-
	state(battle),
	inventory([Head|Tail]),
	inventory_([Head|Tail]).
inventory_([Head|Tail]) :-
	count(Head,[Head|Tail],CountItem),
	format("~w (~w) ~n",[Head, CountItem]),
	deleteAllElmt(Head,Tail,DelResult),
	inventory_(DelResult).
inventory_([]).

count(_,[],Result):-
	Result is 0.

count(Elmt,[Head|Tail],Result) :-
	Head == Elmt,
	count(Elmt,Tail,TempResult),
	Result is 1 + TempResult.

count(Elmt,[Head|Tail],Result) :-
	\+(Head == Elmt),
	count(Elmt,Tail,TempResult),
	Result is TempResult.

deleteAllElmt(Elmt,[Head|Tail],Result):-
	Head == Elmt,
	deleteAllElmt(Elmt,Tail,TempResult),
	Result = TempResult.

deleteAllElmt(Elmt,[Head|Tail],Result):-
	\+(Head == Elmt),
	deleteAllElmt(Elmt,Tail,TempResult),
	Result = [Head|TempResult].

deleteAllElmt(_,[],[]).

getElmt([Head|Tail],0,Elmt):-
	Elmt = Head,!.

getElmt([Head|Tail],I,Elmt):-
	Temp is I-1,
	getElmt(Tail,Temp,Elmt).

% getElmt([Head|Tail],0,Elmt):-
% 	Elmt = Head,!.

isElmt([],_,Bool):-
	Bool is 0.

isElmt([Head|Tail],Elmt,Bool):-
	Head == Elmt,
	Bool is 1.

isElmt([Head|Tail],Elmt,Bool):-
	\+(Head == Elmt),
	isElmt(Tail,Elmt,Bool).
