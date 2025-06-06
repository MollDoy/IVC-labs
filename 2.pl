% Отношение 1: Определение максимума списка

max_list([X], X).
max_list([H|T], H) :- max_list(T, Max), H >= Max.
max_list([H|T], Max) :- max_list(T, Max), H < Max.

% Декларативно:
% 1. Максимум списка из одного элемента - сам этот элемент.
% 2. Если голова списка больше или равна максимуму хвоста, то максимум - голова.
% 3. Если голова списка меньше максимума хвоста, то максимум - максимум хвоста.

% Процедурно:
% 1. Базовый случай: для списка из одного элемента возвращаем этот элемент.
% 2. Рекурсивно находим максимум хвоста, сравниваем с головой, возвращаем голову если она больше.
% 3. Рекурсивно находим максимум хвоста, возвращаем его если он больше головы.
% ---------------------------
% Отношение 2: Удаление первого вхождения элемента из списка

remove_first(_, [], []).
remove_first(Elem, [Elem|T], T) :- !.  % Только первое вхождение удаляется
remove_first(Elem, [H|T], [H|R]) :-
    remove_first(Elem, T, R).

% Декларативно:
% 1. Удаление элемента из пустого списка даёт пустой список.
% 2. Если элемент совпадает с головой списка, результат - хвост.
% 3. Иначе сохраняем голову и рекурсивно обрабатываем хвост.

% Процедурно:
% 1. Базовый случай: пустой список остаётся пустым.
% 2. При совпадении элемента с головой возвращаем хвост (отсекаем другие варианты).
% 3. При несовпадении сохраняем голову и продолжаем поиск в хвосте.
% ---------------------------
% Задание: Удалить первое вхождение максимального элемента списка

remove_max(List, Result) :-
    max_list(List, Max),
    remove_first(Max, List, Result).

% Декларативно:
% 1. Max является максимальным элементом списка List.
% 2. Result получается удалением первого вхождения Max из List.
% 3. Отношение истинно, если оба этих условия выполнены.

% Процедурно:
% 1. Сначала находим максимум списка List.
% 2. Затем удаляем первое вхождение этого максимума из списка.
% 3. Возвращаем результат удаления как итоговый список.

% Пример работы программы:
% ?- remove_max([1, 5, 3, 7, 4], Result).
% Result = [1, 5, 3, 4].
