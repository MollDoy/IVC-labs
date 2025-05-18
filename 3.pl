% Вариант 23. Задание: Найти все кратчайшие маршруты коня между двумя заданными позициями.

% Проверка, что позиция внутри доски 8x8
valid_pos(X,Y) :-
    between(1,8,X),
    between(1,8,Y).

move((X, Y), (X1, Y1)) :-
    member(DX-DY, [2-1, 2-(-1), -2-1, -2-(-1), 1-2, 1-(-2), -1-2, -1-(-2)]),
    X1 is X + DX,
    Y1 is Y + DY,
    valid_pos(X1, Y1).

% Путь коня длины L из Start в End, Path - список клеток [Start, ..., End]
% path(Start, End, L, Path) :-
%    path(Start, End, L, [Start], RevPath),
%    reverse(RevPath, Path).

% Базовый случай: путь длины 0, начальная и конечная позиции совпадают
% path(Pos, Pos, 0, Visited, Visited).

% Рекурсивный случай: путь длины L, ход конём, без повторных посещений
% ---------------------------
% Первый, неоптимизированный вариант path:
% Реализован без запрета на повторные посещения клеток (позволяет циклы)
% Трудоемкость: очень высокая, так как алгоритм может посещать одну и ту же клетку множество раз,
% что приводит к росту числа путей, особенно при больших длинах путей.
% Это вызывает огромную избыточность, множество циклов и сильно увеличивает время поиска.

% path(Pos, Pos, 0, Visited, Visited).
% path(Pos, End, L, Visited, Path) :-
%    L > 0,
%    move(Pos, Next),
%    L1 is L - 1,
%    path(Next, End, L1, [Next|Visited], Path).
% ---------------------------

% ---------------------------
% Второй, оптимизированный вариант path:
% Запрещаем повторные посещения клеток с помощью условия \+ member(Next, Visited).
% Это существенно сокращает пространство поиска, так как каждый путь 
% рассматривает только уникальные позиции, предотвращая циклы.
% Таким образом, уменьшается количество ветвлений и рекурсивных вызовов,
% что ведёт к снижению времени работы и памяти.
% На практике эта оптимизация даёт примерно двукратное ускорение в данной задаче.

% Итог: оптимизация снижает трудоемкость с большого количества путей с повторами
% до гораздо меньшего числа уникальных путей без циклов.
% path(Pos, End, L, Visited, Path) :-
%    L > 0,
%    move(Pos, Next),
%    \+ member(Next, Visited),
%    L1 is L - 1,
%    path(Next, End, L1, [Next|Visited], Path).
% ---------------------------

% Поиск всех кратчайших путей коня из Start в End
% shortest_paths(Start, End, Paths) :-
%    between(0, 63, L),
%    findall(P, path(Start, End, L, P), Paths),
%    Paths \= [], !.

% Вместо рекурсивного перебора реализуем алгоритм A* — классический
% алгоритм искусственного интеллекта для поиска кратчайшего пути.
% Он использует эвристику для оценки расстояния до цели, что
% значительно сокращает время поиска и исключает перебор неэффективных путей.

% Реализация A* в этом задании должна заменить функцию path/5 и работать
% по принципу:
% - Состояния — позиции коня на доске.
% - Переходы — легальные ходы move/2.
% - Стоимость перехода — 1 ход.
% - Эвристика — приближённое минимальное число ходов от текущей позиции до цели.

% Благодаря этому подходу поиск кратчайшего пути станет намного
% эффективнее и будет считаться примером искусственного интеллекта
% в сравнении с полным перебором.

% Эвристика: минимальное количество ходов коня от Pos до End.
% Используем простое приближение — манхэттенское расстояние с поправкой:
% так как конь ходит по диагонали и в L-образных шагах, оценка не точная,
% но admissible (не переоценивает), например, ceil((|dx|+|dy|)/3).
heuristic((X,Y),(X1,Y1),H) :-
    DX is abs(X1 - X),
    DY is abs(Y1 - Y),
    D is DX + DY,
    H is (D + 2) // 3.  % приближенная оценка ходов коня

% A* поиск с накоплением пути и g, f = g + h
% Открытый список (frontier) — очередь с приоритетом по f
% Используем findall и сортировку для упрощения
% Чтобы найти все кратчайшие пути, собираем пути с минимальным g в конечной точке

% Основной предикат для A* (ищет пути)
path(Start, End, Paths) :-
    heuristic(Start, End, H),
    path_search([node(Start, [Start], 0, H)], End, [], Paths).

% path_search(OpenList, Goal, ClosedList, ResultPaths)
% OpenList - список узлов node(Pos, Path, G, F)
path_search(Open, End, Closed, Paths) :-
    % Выбираем узлы с минимальным F
    findall(F, member(node(_,_,_,F), Open), Fs),
    min_list(Fs, MinF),
    % Отбираем узлы с F = MinF
    include(has_f(MinF), Open, BestNodes),
    % Отбираем среди них узлы с минимальным G (короткий путь)
    maplist(arg_g, BestNodes, Gs),
    min_list(Gs, MinG),
    include(has_g(MinG), BestNodes, BestGNodes),

    % Проверяем, есть ли среди BestGNodes узлы с позицией End
    include(at_pos(End), BestGNodes, GoalNodes),
    ( GoalNodes \= [] ->
        % Если есть узлы с конечной позицией, собираем все пути
        findall(Path, (member(node(_, Path, MinG, _), GoalNodes)), Paths)
    ;
        % Иначе расширяем узлы с минимальным F и минимальным G
        findall(
            node(NextPos, [NextPos|Path], G1, F1),
            (
                member(node(Pos, Path, G, _), BestGNodes),
                move(Pos, NextPos),
                \+ member(NextPos, Path),
                G1 is G + 1,
                heuristic(NextPos, End, H1),
                F1 is G1 + H1
            ),
            NewNodes
        ),
        % Удаляем BestGNodes из Open
        subtract(Open, BestGNodes, RestOpen),
        % Добавляем NewNodes
        append(RestOpen, NewNodes, NewOpen),
        path_search(NewOpen, End, [BestGNodes|Closed], Paths)
    ).

% Предикаты для include
has_f(F, node(_,_,_,F1)) :- F1 =:= F.
arg_g(node(_,_,G,_), G).
has_g(G, node(_,_,G1,_)) :- G1 =:= G.
at_pos(Pos, node(Pos, _, _, _)).

% Запуск и вывод
run_and_print :-
    path((1,1), (8,8), Paths),
    print_paths(Paths).

print_paths([]).
print_paths([P|Ps]) :-
    reverse(P, RP), % путь в нормальном порядке
    write(RP), nl,
    print_paths(Ps).

% Время выполнения работы до оптимизации:
% 211,446 inferences, 0.016 CPU in 2.017 seconds (1% CPU, 13532544 Lips)
% 211,446 inferences, 0.031 CPU in 2.125 seconds (1% CPU, 6766272 Lips)
% 211,446 inferences, 0.031 CPU in 2.019 seconds (2% CPU, 6766272 Lips)

% Время выполнения работы после оптимизации:
% 196,814 inferences, 0.047 CPU in 1.012 seconds (5% CPU, 4198699 Lips)
% 196,814 inferences, 0.031 CPU in 1.123 seconds (3% CPU, 6298048 Lips)
% 196,814 inferences, 0.016 CPU in 1.081 seconds (1% CPU, 12596096 Lips)

% Время выполнения работы после второй оптимизации, введения алгоритма ИИ:
% 104,004 inferences, 0.031 CPU in 0.400 seconds (8% CPU, 3328128 Lips)
% 85,806 inferences, 0.016 CPU in 0.768 seconds (2% CPU, 5491584 Lips)
% 85,806 inferences, 0.031 CPU in 0.701 seconds (4% CPU, 2745792 Lips)

