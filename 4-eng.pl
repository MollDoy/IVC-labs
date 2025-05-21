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
drink('herbal_tea', ['night'], ['stressed'], ['sugar_free']).               % Уникальный случай — в самый верх
drink('energy_drink', ['day'], ['tired'], ['sweet']).                       % Тоже уникален
drink('mint_tea', ['evening', 'night'], ['stressed'], ['hot', 'sugar_free']). % Перебивает tea
drink('hot_chocolate', ['evening'], ['stressed'], ['hot']).                % Тоже потенциальный конфликт с tea
drink('kompot', ['day'], ['energetic'], ['sweet']).                        % Может проиграть kvass — ставим выше
drink('kvass', ['day'], ['energetic'], ['cold', 'sweet']).                 % Шире kompot, но ещё до juice
drink('milkshake', ['day'], ['relaxed'], ['sweet']).                       % Может проиграть juice
drink('iced_tea', ['day'], ['energetic'], ['cold']).                       % juice может перехватить — ставим выше
drink('sparkling_water', ['day', 'evening'], ['energetic', 'relaxed'], ['sugar_free', 'cold']). % Лучше juice, выше
drink('matcha', ['morning'], ['energetic'], ['hot']).                      % Может пересечься с coffee
drink('lemonade', ['evening', 'night'], ['relaxed'], ['cold']).            % Частичный конфликт с juice
drink('tea', ['evening', 'night'], ['relaxed', 'stressed'], ['hot', 'sugar_free']). % Много перекрытий — ниже всех похожих
drink('coffee', ['morning', 'day'], ['tired', 'energetic'], ['hot']).      % Универсален
drink('juice', ['morning', 'day', 'night'], ['energetic', 'relaxed'], ['cold', 'sweet']). % Универсален — внизу
drink('water', ['morning', 'day', 'evening', 'night'], ['tired', 'energetic', 'stressed', 'relaxed'], ['sugar_free']). % Запасной случай — самый конец

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
