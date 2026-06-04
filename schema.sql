DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS seats;
DROP TABLE IF EXISTS movies;

CREATE TABLE movies (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    genre VARCHAR(100),
    duration_minutes INT,
    description TEXT,
    release_year INT
);

CREATE TABLE seats (
    id SERIAL PRIMARY KEY,
    movie_id INT REFERENCES movies(id) ON DELETE CASCADE,
    seat_row CHAR(1) NOT NULL,
    seat_number INT NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    UNIQUE(movie_id, seat_row, seat_number)
);

CREATE TABLE bookings (
    id SERIAL PRIMARY KEY,
    movie_id INT REFERENCES movies(id) ON DELETE CASCADE,
    seat_id INT REFERENCES seats(id) ON DELETE CASCADE,
    customer_name VARCHAR(255) NOT NULL,
    customer_email VARCHAR(255) NOT NULL,
    booked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE VIEW movies_with_availability AS
SELECT
    m.id,
    m.title,
    m.genre,
    m.duration_minutes,
    m.description,
    m.release_year,
    COUNT(s.id) AS total_seats,
    COUNT(s.id) FILTER (WHERE s.is_available) AS seats_available
FROM movies m
LEFT JOIN seats s ON s.movie_id = m.id
GROUP BY m.id;

CREATE OR REPLACE FUNCTION mark_seat_booked()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE seats SET is_available = FALSE WHERE id = NEW.seat_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_mark_seat_booked
AFTER INSERT ON bookings
FOR EACH ROW
EXECUTE FUNCTION mark_seat_booked();