/*Untuk File Player.pl*/ 

:-dynamic(max_HP/1).
:-dynamic(curr_HP/1).
:-dynamic(base_defense/1).
:-dynamic(base_attack/1).
:-dynamic(special_attack/1).
:-dynamic(level/1).
:-dynamic(experience/1).
:-dynamic(inventory/1).


level(1).
experience(0).
max_HP(100).
curr_HP(100).
base_attack(10).
special_attack(30).
base_defense(10).

equip_weapon(dull_sword).
equip_armor(iron_plate).
equip_acc(none).
inventory([]).
gold(0).

/*
class 0 all
class 1 sswordman
class 2 archer
class 3 sorcerer
*/
/*weapon(weapon,damageValue,Class)*/
weapon(beginerSword,5,1).
weapon(beginerBow,5,2).
weapon(beginerStaff,5,3).
/*armor(weapon,defenceValue,class)*/
armor(beginerIronplate,5,1).
armor(beginerLeather,5,2).
armor(beginerRobe,5,3).

/*equipment(weapon,damageValue,defenceValue,MaxHP,class)*/
accessory(none,0,0,0,0).
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
	