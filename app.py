import os
import psycopg2
from psycopg2.extras import RealDictCursor
from flask import Flask, render_template, request, redirect, url_for, flash

app = Flask(__name__)
app.secret_key = "cinema_secret_key"

def get_db():
    conn = psycopg2.connect(
        host="db",
        dbname="cinema_db",
        user="postgres",
        password="password"
    )
    return conn

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/movies")
def movies():
    conn = get_db()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM movies ORDER BY title")
    all_movies = cur.fetchall()
    cur.close()
    conn.close()
    return render_template("movies.html", movies=all_movies)

@app.route("/seats/<int:movie_id>")
def seats(movie_id):
    conn = get_db()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM movies WHERE id = %s", (movie_id,))
    movie = cur.fetchone()
    cur.execute("SELECT * FROM seats WHERE movie_id = %s ORDER BY seat_row, seat_number", (movie_id,))
    all_seats = cur.fetchall()
    cur.close()
    conn.close()
    rows = {}
    for seat in all_seats:
        row = seat["seat_row"]
        rows.setdefault(row, []).append(seat)
    return render_template("seats.html", movie=movie, rows=rows)

@app.route("/book", methods=["POST"])
def book():
    movie_id = request.form.get("movie_id")
    seat_id = request.form.get("seat_id")
    name = request.form.get("customer_name", "").strip()
    email = request.form.get("customer_email", "").strip()

    conn = get_db()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT is_available FROM seats WHERE id = %s", (seat_id,))
    seat = cur.fetchone()

    if not seat or not seat["is_available"]:
        flash("That seat is no longer available.", "error")
        return redirect(url_for("seats", movie_id=movie_id))

    cur.execute(
        "INSERT INTO bookings (movie_id, seat_id, customer_name, customer_email) VALUES (%s, %s, %s, %s)",
        (movie_id, seat_id, name, email)
    )
    cur.execute("UPDATE seats SET is_available = FALSE WHERE id = %s", (seat_id,))
    conn.commit()
    cur.close()
    conn.close()
    flash("Booking confirmed!", "success")
    return redirect(url_for("movies"))

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)