% Вариант 23. Есть факты об отцах некотоpых людей и о бpатьях некотоpых людей. Опpеделить отношение ДЯДЯ.

% Факты об отцах
father(robert, john).
father(robert, michael).
father(robert, william).
father(john, mike).
father(john, david).
father(michael, sophia).
father(william, charles).
father(david, emily).
father(charles, alice).
father(charles, henry).

% Факты о гендерах людей
male(john).
male(mike).
male(david).
male(michael).
male(robert).
male(william).
male(charles).
male(henry).

female(sophia).
female(emily).
female(alice).

% Правило для определения братьев в семье
brother(X, Y) :- father(F, X), father(F, Y), male(X), X \= Y.

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
