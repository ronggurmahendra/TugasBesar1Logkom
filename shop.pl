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

shop:-
  state(normal),
  playerLoc(10,5),
  retract(state(_)),
  asserta(state(shop)),
  write('Welcome to the shop'),nl,
  write('What do you want to buy?'),nl,
  write('1. Health Potion (100 gold)'),nl,
  write('2. Gacha (1000 Gold)'),nl.

%command healthpotion
healthpotion:-
    gold(Gold),
    Gold >= 100,
    add_item('Health Potion'),
    add_gold(-100).
healthpotion:-
    gold(Gold),
    Gold < 100,
    write('Not enough money!'),nl,!.
%command gacha
gacha:-
    gold(Gold),
    Gold >= 1000,
    random(0,9,Gacha_Number),
    add_gold(-1000),
    gacharesult(Gacha_Number).
gacha:-
    gold(Gold),
    Gold < 1000,
    write('Not enough money!'),nl,!.
%exitshop
exitShop:-
  retract(state(_)),
  asserta(state(normal)),
  write('Thanks for coming'),nl. %masuk ke permainan lagi
