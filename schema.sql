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