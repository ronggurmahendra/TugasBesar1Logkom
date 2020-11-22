print_file(File):-
    open(File,read,Stream),
    %get char
    get_char(Stream,Char1),
    %output until eof
    process_stream(Char1,Stream),
    close(Stream).

print_title:-
    open('genshin.txt',read,Stream),
    %get char
    get_char(Stream,Char1),
    %output until eof
    process_stream(Char1,Stream),
    close(Stream).

%testing purpose
print_test:-
    open('ascii-art.txt',read,Stream),
    %get char
    get_char(Stream,Char1),
    %output until eof
    process_stream(Char1,Stream),sleep(1),
    close(Stream).

% basis
process_stream(end_of_file, _) :- !.

process_stream(Char,Stream) :-
  write(Char),
  get_char(Stream,Char2),
  process_stream(Char2, Stream).
