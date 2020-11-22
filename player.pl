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
:-dynamic(equip_acc/6).
:-dynamic(job/1).
job(1).
level(1).
experience(0).
max_HP(100).
curr_HP(100).
base_attack(10).
special_attack(30).
base_defense(10).
gold(0).

equip_weapon(beginnerSword,5,1).
equip_armor(beginnerPlate,5,1).
equip_acc(none,0,0,0,0).
inventory([longsword, ironPlate, beginnerBow, ironPlate]).

/*
class 0 all
class 1 sswordman
class 2 archer
class 3 sorcerer
*/
/*weapon(weapon,damageValue,Class)*/
weapon(beginnerSword,5,1).
weapon(beginnerBow,5,2).
weapon(beginnerStaff,5,3).
weapon(longsword,10,1).
/*armor(weapon,defenseValue,class)*/
armor(beginnerPlate,5,1).
armor(beginnerLeather,5,2).
armor(beginnerRobe,5,3).
armor(ironPlate,10,1).

/*equipment(weapon,damageValue,defenseValue,MaxHP,class)*/
accessory(none,0,0,0,0).

/* Class Name */
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
	retract(experience(Val_Exp)) ,FinalXp is Val_Exp - 100, asserta(experience(FinalXp)).
/*Inventory*/
push(Element,[],[Element]).
push(Element,[Head|Tail],[Head|Result]) :- push(Element,Tail,Result).

add_item(Item) :-
	retract(inventory(Val_inventory)),
	push(Item,Val_inventory,Final_inventory),
	asserta(inventory(Final_inventory)).

delete_item(Item) :-
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
	asserta(curr_HP(FinalHp)).
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
	write('Choose the weapon that you want to swap: '),nl,
	print_inventory,
	repeat,
		read(Input),
		weapon(Input, Dmg, Class),
		job(Class1),
		Class == Class1,

	retract(equip_weapon(X,_,_)),
	asserta(equip_weapon(Input,Dmg,Class)),
	add_item(X),
	delete_item(Input).

swap_armor :-
	write('Choose the armor that you want to swap: '),nl,
	print_inventory,
	repeat,
		read(Input),
		armor(Input, Def, Class),
		job(Class1),
		Class == Class1,

	retract(equip_armor(X,_,_)),
	asserta(equip_armor(Input,Def,Class)),
	add_item(X),
	delete_item(Input).

swap_accessory :-
	write('Choose the accessory that you want to swap: '),nl,
	print_inventory,
	repeat,
		read(Input),
		accessory(Input, Dmg, Def, HP, Class),
		job(Class1),
		Class == Class1,

	retract(equip_accessory(X,_,_,_,_)),
	asserta(equip_accessory(Input,Dmg,Def,HP,Class)),
	add_item(X),
	delete_item(Input).


print_inventory :-
	inventory(List),
	write('Your Inventory: '),nl,
	print_inventory_(List).

print_inventory_([Head|Tail]) :-
	weapon(Head, _, Class),
	class(Class, Name),
	format("~w (~w) ~n",[Head, Name]),
	print_inventory_(Tail).

print_inventory_([Head|Tail]) :-
	armor(Head, _, Class),
	class(Class, Name),
	format("~w (~w) ~n",[Head, Name]),
	print_inventory_(Tail).

print_inventory_([Head|Tail]) :-
	accessory(Head, _, _, _, Class),
	class(Class, Name),
	format("~w (~w) ~n",[Head, Name]),
	print_inventory_(Tail).

print_inventory_([]).

inventory :-
	inventory([Head|Tail]),
	inventory_([Head|Tail]).

inventory_([Head|Tail]) :-
	count(Head,[Head|Tail],CountItem),
	format("~w (~w) ~n",[Head, CountItem]),
	deleteAllElmt(Head,Tail,DelResult),
	inventory_(DelResult).

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


getElmt([Head|Tail],I,Elmt):-
	Temp is I-1,
	getElmt(Tail,Temp,Elmt).

getElmt([Head|Tail],0,Elmt):-
	Elmt is Head.