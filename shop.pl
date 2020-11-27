
/*
gacharesult(0):-
    add_item(Healthpotion), %masukin equipment yang mau digacha
    write('Congratulation you got Nol'),nl.
gacharesult(1):-
    add_item(Healthpotion),
    write('Congratulation you got One'),nl.
gacharesult(2):-
    add_item(Healthpotion),
    write('Congratulation you got Two'),nl.
gacharesult(3):-
    add_item(Healthpotion),
    write('Congratulation you got Three'),nl.
gacharesult(4):-
    add_item(Healthpotion),
    write('Congratulation you got Four'),nl.
gacharesult(5):-
    add_item(Healthpotion),
    write('Congratulation you got Five'),nl.
gacharesult(6):-
    add_item(Healthpotion),
    write('Congratulation you got Six'),nl.
gacharesult(7):-
    add_item(Healthpotion),
    write('Congratulation you got Seven'),nl.
gacharesult(8):-
    add_item(Healthpotion),
    write('Congratulation you got Eight'),nl.
gacharesult(9):-
    add_item(Healthpotion),
    write('Congratulation you got Nine'),nl.
*/
gachaList([beginnerSword,beginnerBow,beginnerStaff,longsword,lamentBlade,totsukaBlade,excalibur,longbow,pleiadesBow,zephyrBow,quintessenceBow,magicStaff,wabbajack,sanguineRose,shadebinder,beginnerPlate,beginnerLeather,beginnerRobe,ironPlate,phoenixPlate,stronghold,stalkerVest,frumiousVest,gwisinVest,dreambaneRobes,calamityRobes,icefallMantle,beltOfGiantStrengh,bracersOfDefence,amuletOfHealth,dibellaAmulet,gargoyleAmulet,bloodlustAmulet,ariculationAmulet,exileCloak,holdfastMark,greatHuntBond,crystalOfStrength,paimon]).
shop:-
  state(normal),
  playerLoc(10,5),
  retract(state(_)),
  asserta(state(shop)),
  write('Welcome to the shop'),nl,
  write('What do you want to buy?'),nl,
  write('1. Health Potion (100 gold)'),nl,
  write('2. Gacha (1000 Gold)'),nl,
  write('3. Sell '),nl.

%command healthpotion
healthpotion:-
	state(shop),
    gold(Gold),
	Gold >= 100,
    add_item('Health Potion'),
	add_gold(-100),
	write('You bought Health Potion for 100 gold'),!.
healthpotion:-
	state(shop),
    gold(Gold),
    Gold < 100,
    write('Not enough money!'),nl,!.
%command gacha
gacha:-
	state(shop),
    gold(Gold),
    Gold >= 1000,
    random(0,39,Gacha_Number),
    add_gold(-1000),
	gachaList(GachaList),
	getElmt(GachaList,Gacha_Number,GachaResult),
	%format("~w ~n",[GachaResult]),
	getGacha(GachaResult),!.
	%add_item(GachaResult).
gacha:-
	state(shop),
    gold(Gold),
    Gold < 1000,
    write('Not enough money!'),nl,!.
%exitshop
getGacha(GachaResult):-
	companionList(CompanionList),
	isElmt(CompanionList,GachaResult,Bool),
	Bool == 1,
	get_companion(GachaResult),
	print_file('paimon.txt').

getGacha(GachaResult):-
    format("You got ~w! ~n",[GachaResult]),
	add_item(GachaResult).

sell:-
	state(shop),
	inventory([Head|Tail]),
	inventory_([Head|Tail]),
	write('What do you want to sell'),nl,
	read(Input),
	inventory(ListInventory),
	isElmt(ListInventory,Input,Bool),
	Bool == 1,
	delete_item(Input),
	add_gold(50),
	format("you sold ~w for 50 gold ~n",[Input]),!.
	/*
sell:-
	state(shop),
	inventory,
	write('What do you want to sell'),nl,
	read(Input),
	inventory(ListInventory),
	isElmt(ListInventory,Input,Bool),
	Bool == 0,
	format("you don't have ~w ~n",[Input]).
	*/
%companion(ID,max_HP,base_defense,base_attack,special_attack)
companion(paimon,20,20,20,50).
companionList([paimon]).
get_companion(Companion):-
	companion(Companion,Max_HP_Bonus,Base_Defence_Bonus,Base_attack_Bonus,Special_attack_Bonus),
	format("~w has join your party ~nyou gain numerous benefit~n",[Companion]),
	add_max_HP(Max_HP_Bonus),
	add_base_attack(Base_attack_Bonus),
	add_special_attack(Special_attack_Bonus),
	add_base_defense(Base_Defence_Bonus).

exitShop:-
	state(shop),
	retract(state(_)),
	asserta(state(normal)),
	write('Thanks for coming'),nl. %masuk ke permainan lagi
