:- use_module(library(plunit)).
:- use_module(word_freq).

:- begin_tests(word_freq_test).

test(word_frequencies) :-
    with_output_to(string(Output), word_frequencies('input.txt', 'tmp_stop_words.txt')),
    assertion(true),
    sub_string(Output, _, _, _, "test - 2"),
    sub_string(Output, _, _, _, "only - 1"),
    !.

test(read_stop_words) :-
    read_stop_words('tmp_stop_words.txt', StopWords),
    assertion(StopWords == ["a", "is", "this", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
                            "k", "l", "m", "n", "o", "p", "q", "r",
                            "s", "t", "u", "v", "w", "x", "y", "z"]).

test(filter_chars_and_normalize) :-
    filter_chars_and_normalize('This is a test, only a test.', FilteredText),
    assertion(FilteredText == "this is a test  only a test ").

test(scan) :-
    scan("this is a test", WordList),
    assertion(WordList == ["this", "is", "a", "test"]).

test(remove_stop_words) :-
    remove_stop_words(["this", "is", "a", "test"], ["a", "is"], FilteredWordList),
    assertion(FilteredWordList == ["this", "test"]).

test(frequencies) :-
    frequencies(["test", "only", "test"], WordFreq),
    permutation(WordFreq, [only-1, test-2]),
    !.

test(sorted) :-
    sorted([a-2, b-1, c-3], SortedWordList),
    assertion(SortedWordList == [c-3, a-2, b-1]).

test(print_top_n) :-
    with_output_to(string(Output), print_top_n([a-2, b-1, c-3], 3)),
    sub_string(Output, _, _, _, "a - 2"),
    sub_string(Output, _, _, _, "b - 1"),
    sub_string(Output, _, _, _, "c - 3"),
    !.

:- end_tests(word_freq_test).