% Вариант 23. Есть факты об отцах некотоpых людей и о бpатьях некотоpых людей. Опpеделить отношение ДЯДЯ.

% Факты об отцах
father(john, mike).
father(john, david).
father(michael, sophia).
father(david, emily).
father(robert, john).
father(robert, michael).
father(robert, william).
father(william, charles).
father(charles, alice).
father(charles, henry).

% Правило для определения братьев в семье
brother(X, Y) :- father(F, X), father(F, Y), X \= Y.

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
