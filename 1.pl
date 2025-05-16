% Общие факты по заданию
 dog(flash).
 dog(rover).
 cat(bootsy).
 horse(star).

 color(flash, black).
 color(bootsy, brown).
 color(rover, ginger).
 color(star, white).

% Общие правила для определения питомцев и животных
 pet(X) :- dog(X); cat(X).
 animal(X) :- pet(X); horse(X).

% Владельцы животных
 owner(tom, X) :- dog(X), color(X, C), C \= black.
 owner(keith, X) :- horse(X); color(X, black).

% Вопросы
% Ровер - рыжая?
% ?- color(rover, ginger).

% Определить клички всех собак
% ?- dog(X).

% Определить владельцев чего-либо
% ?- owner(Name, Animal).

% Определить владельцев животных небелого цвета
% ?- owner(Name, Animal), color(Animal, Color), Color \= white.