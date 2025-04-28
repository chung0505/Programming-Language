word_frequencies(File, StopWordsFile) :-
    read_file_to_string(File, Text, []),
    filter_chars_and_normalize(Text, FilteredText),
    scan(FilteredText, WordList),
    read_stop_words(StopWordsFile, StopWords),
    remove_stop_words(WordList, StopWords, FilteredWordList),
    frequencies(FilteredWordList, WordFreq),
    sorted(WordFreq, SortedWordFreq),
    print_top_n(SortedWordFreq, 25).

read_stop_words(File, StopWords) :-
    read_file_to_string(File, Text, []),
    split_string(Text, ",\n", " ", Lines),
    maplist(string_lower, Lines, LowerStopWords),
    append(LowerStopWords, ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
                            "k", "l", "m", "n", "o", "p", "q", "r",
                            "s", "t", "u", "v", "w", "x", "y", "z"], StopWords).

filter_chars_and_normalize(Text, FilteredText) :-
    string_lower(Text, Lower),
    string_chars(Lower, Chars),
    maplist(replace_non_alpha, Chars, CleanChars),
    string_chars(FilteredText, CleanChars).

replace_non_alpha(Char, Char) :-
    char_type(Char, alpha), !.
replace_non_alpha(_, ' ').

scan(Text, WordList) :-
    split_string(Text, " ", " ", Words),
    exclude(=( ""), Words, WordList).

remove_stop_words(WordList, StopWords, FilteredWordList) :-
    findall( W, ( member(W, WordList), \+ member(W, StopWords)), FilteredWordList ).

frequencies(WordList, WordFreq) :-
    word_counts(WordList, dict{}, CountsDict),
    dict_pairs(CountsDict, _, Pairs),
    WordFreq = Pairs.

word_counts([], Dict, Dict).
word_counts([Word|Rest], Dict0, Dict) :-
    atom_string(WordAtom, Word),
    (get_dict(WordAtom, Dict0, Count) ->
        Count1 is Count + 1,
        put_dict(WordAtom, Dict0, Count1, Dict1)
    ;
        put_dict(WordAtom, Dict0, 1, Dict1)
    ),
    word_counts(Rest, Dict1, Dict).

sorted(WordList, SortedWordList) :-
    sort(2, @>=, WordList, SortedWordList).

print_top_n(_, 0).
print_top_n([], _).
print_top_n([Word-Freq|Rest], N) :-
    format('~w - ~w~n', [Word, Freq]),
    N1 is N - 1,
    print_top_n(Rest, N1).