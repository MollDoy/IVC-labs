(deftemplate time_of_day
   (slot value))

(deftemplate mood
   (slot value))

(deftemplate preference
   (slot value))

(deftemplate matched)

(deftemplate drink
   (slot name)
   (multislot times)
   (multislot moods)
   (multislot preferences))

(defrule ask-time
   (not (time_of_day (value ?)))
   =>
   (printout t "Time of day (morning, day, evening, night): ")
   (bind ?time (read))
   (assert (time_of_day (value ?time))))

(defrule ask-mood
   (not (mood (value ?)))
   =>
   (printout t "Your mood (tired, energetic, stressed, relaxed): ")
   (bind ?mood (read))
   (assert (mood (value ?mood))))

(defrule ask-preference
   (not (preference (value ?)))
   =>
   (printout t "Preference (hot, cold, sweet, sugar_free): ")
   (bind ?pref (read))
   (assert (preference (value ?pref))))

(defrule recommend-drink
   (time_of_day (value ?t))
   (mood (value ?m))
   (preference (value ?p))
   (drink (name ?name)
          (times $? ?t $?)
          (moods $? ?m $?)
          (preferences $?prefs))
   (test (member$ ?p ?prefs))
   =>
   (printout t crlf "Recommended drink: " ?name crlf)
   (assert (matched))
   (halt))

(defrule fallback
   (time_of_day (value ?))
   (mood (value ?))
   (preference (value ?))
   (not (matched))
   =>
   (printout t crlf "Recommended drink: water" crlf)
   (halt))

;; -------------------------
;; База напитков
;; -------------------------

(deffacts drinks-base
   (drink (name herbal_tea) (times night) (moods stressed) (preferences sugar_free))
   (drink (name energy_drink) (times day) (moods tired) (preferences sweet))
   (drink (name mint_tea) (times evening night) (moods stressed) (preferences hot sugar_free))
   (drink (name hot_chocolate) (times evening) (moods stressed) (preferences hot))
   (drink (name kompot) (times day) (moods energetic) (preferences sweet))
   (drink (name kvass) (times day) (moods energetic) (preferences cold sweet))
   (drink (name milkshake) (times day) (moods relaxed) (preferences sweet))
   (drink (name iced_tea) (times day) (moods energetic) (preferences cold))
   (drink (name sparkling_water) (times day evening) (moods energetic relaxed) (preferences sugar_free cold))
   (drink (name matcha) (times morning) (moods energetic) (preferences hot))
   (drink (name lemonade) (times evening night) (moods relaxed) (preferences cold))
   (drink (name tea) (times evening night) (moods relaxed stressed) (preferences hot sugar_free))
   (drink (name coffee) (times morning day) (moods tired energetic) (preferences hot))
   (drink (name juice) (times morning day night) (moods energetic relaxed) (preferences cold sweet))
   (drink (name plain_tea) (times morning day evening night) (moods tired energetic stressed relaxed) (preferences sugar_free))
)