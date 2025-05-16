% Вариант 23. Есть факты об отцах некотоpых людей и о бpатьях некотоpых людей. Опpеделить отношение ДЯДЯ.

% Факты об отцах и братьях
father(john, mike).
father(john, david).
father(michael, sophia).
father(david, emily).

brother(mike, david).
brother(david, mike).

% Правило для определения отношения ДЯДЯ
uncle(Uncle, Person) :- father(Father, Person), brother(Uncle, Father).

% Вопросы
% Опpеделить бpатьев конкpетного человека.
% ?- brother(X, Person).

% Кто является отцом конкретного лица?
% ?- father(Father, Person).

% Связаны ли два человека отношением ОТЕЦ?
% ?- father(X, Y); father(Y, X).

% Опpеделить, является ли один человек дядей другого.
% ?- uncle(Uncle, Person).