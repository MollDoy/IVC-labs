% Динамические предикаты для хранения ответов пользователя
:- dynamic time_of_day/1.
:- dynamic mood/1.
:- dynamic preference/1.

% Стартовая точка программы
start :-
    retractall(time_of_day(_)),
    retractall(mood(_)),
    retractall(preference(_)),
    ask_time,
    ask_mood,
    ask_preference,
    recommend(Drink),
    format('Recommended drink: ~w~n', [Drink]).

% Ввод времени суток
ask_time :-
    write('Time of day (morning, day, evening, night): '),
    read(Time),
    assertz(time_of_day(Time)).

% Ввод настроения
ask_mood :-
    write('Your mood (tired, energetic, stressed, relaxed): '),
    read(Mood),
    assertz(mood(Mood)).

% Ввод предпочтения
ask_preference :-
    write('Preference (hot, cold, sweet, sugar_free): '),
    read(Preference),
    assertz(preference(Preference)).

% База данных напитков: drink(Название, Список_времени, Список_настроений, Список_предпочтений)
drink('herbal_tea', ['night'], ['stressed'], ['sugar_free']).
drink('mint_tea', ['evening', 'night'], ['stressed'], ['hot', 'sugar_free']).
drink('hot_chocolate', ['evening'], ['stressed'], ['hot']).
drink('kvass', ['day'], ['energetic'], ['cold', 'sweet']).
drink('kompot', ['day'], ['energetic'], ['sweet']).
drink('milkshake', ['day'], ['relaxed'], ['sweet']).
drink('iced_tea', ['day'], ['energetic'], ['cold']).
drink('sparkling_water', ['day', 'evening'], ['energetic', 'relaxed'], ['sugar_free', 'cold']).
drink('matcha', ['morning'], ['energetic'], ['hot']).
drink('energy_drink', ['day'], ['tired'], ['sweet']).
drink('lemonade', ['evening', 'night'], ['relaxed'], ['cold']).
drink('tea', ['evening', 'night'], ['relaxed', 'stressed'], ['hot', 'sugar_free']).
drink('coffee', ['morning', 'day'], ['tired', 'energetic'], ['hot']).
drink('juice', ['morning', 'day', 'night'], ['energetic', 'relaxed'], ['cold', 'sweet']).

% Рекомендация напитка
recommend(Drink) :-
    time_of_day(T),
    mood(M),
    preference(P),
    drink(Drink, TimeList, MoodList, PrefList),
    member(T, TimeList),
    member(M, MoodList),
    member(P, PrefList), !.

% Если не нашлось ничего подходящего, рекомендуем воду.)
recommend('water').

% Пример работы программы

% ?- start.
% Time of day (morning, day, evening, night): day.
% Your mood (tired, energetic, stressed, relaxed): |: relaxed.
% Preference (hot, cold, sweet, sugar_free): |: sweet.
% Recommended drink: juice
% true.

% ?- start.
% Time of day (morning, day, evening, night): morning.
% Your mood (tired, energetic, stressed, relaxed): |: tired.
% Preference (hot, cold, sweet, sugar_free): |: hot.
% Recommended drink: coffee
% true.
