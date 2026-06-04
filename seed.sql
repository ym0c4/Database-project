INSERT INTO movies (title, genre, duration_minutes, description, release_year) VALUES
(
    'Interstellar',
    'Sci-Fi',
    169,
    'A team of explorers travel through a wormhole in space to ensure humanity''s survival.',
    2014
),
(
    'Inception',
    'Sci-Fi / Thriller',
    148,
    'A thief who steals corporate secrets through dream-sharing technology is given the task of planting an idea.',
    2010
),
(
    'The Grand Budapest Hotel',
    'Comedy / Drama',
    99,
    'A legendary concierge and his protege become embroiled in the theft of a priceless painting.',
    2014
),
(
    'Parasite',
    'Thriller / Drama',
    132,
    'A poor family schemes to become employed by a wealthy household by posing as unrelated, qualified individuals.',
    2019
),
(
    'Spirited Away',
    'Animation / Fantasy',
    125,
    'A young girl wanders into a world of spirits and must find a way to free herself and her parents.',
    2001
),
(
    'Mad Max: Fury Road',
    'Action / Adventure',
    120,
    'In a post-apocalyptic wasteland, a woman rebels against a tyrant in search of her homeland.',
    2015
),
(
    'Coco',
    'Animation / Family',
    105,
    'A young musician journeys to the Land of the Dead to uncover his family''s history.',
    2017
);

-- Generate seats for each movie (rows A-E, seats 1-8)
DO $$
DECLARE
    movie RECORD;
    row_letter CHAR(1);
    seat_num INT;
BEGIN
    FOR movie IN SELECT id FROM movies LOOP
        FOREACH row_letter IN ARRAY ARRAY['A','B','C','D','E'] LOOP
            FOR seat_num IN 1..8 LOOP
                INSERT INTO seats (movie_id, seat_row, seat_number, is_available)
                VALUES (movie.id, row_letter, seat_num, TRUE);
            END LOOP;
        END LOOP;
    END LOOP;
END $$;