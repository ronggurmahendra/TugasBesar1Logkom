usePotion:- %Potionnya ga ada
    inventory(X),
  	count('Health Potion',X,CountItem),
    CountItem == 0,
    write('You dont have potion').
usePotion:- %healthpotion
	add_curr_HP(50), %tambah 50 HP ke player
	delete_item('Health Potion'). %hilangin 1 healthpotion di list
