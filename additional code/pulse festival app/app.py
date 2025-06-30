from flask import Flask, render_template, request
import pymysql

app = Flask(__name__)

DB_HOST = 'localhost'
DB_USER = 'root'
DB_PASSWORD = ''
DB_NAME = 'pulse_festival'

query_descriptions = {
    1: "1. Festival revenue per year, broken down by ticket payment method.",
    2: "2. Artists belonging to a specific genre and their participation status in that year's festival. (Rock 2024)",
    3: "3. Artists who performed as a warm-up act more than twice within the same festival.",
    4: "4. Average rating of an artist for performance quality and overall impression. (artist = 1)",
    5: "5. Young artists (under 30 years old) with the highest number of festival participations.",
    6: "6. Events attended by a visitor and their average rating per event. (person_id = 37)",
    7: "7. Festival with the lowest average experience level among technical staff.",
    8: "8. Support staff not scheduled to work on a specific date (2021-08-12).",
    9: "9. Visitors who attended the same number of events (more than three) within a single year.",
    10: "10. Top-3 most common pairs of musical genres among artists.",
    11: "11. Artists with at least five fewer festival participations than the top-participating artist.",
    12: "12. Required staff per festival day, categorized by staff type (technical, security, support).",
    13: "13. Artists who have performed at festivals across at least three different continents.",
    14: "14. Genres with the same number of festival appearances in two consecutive years (at least three appearances each year).",
    15: "15. Top-5 visitors who have given the highest total ratings to an artist."
}


def run_query(query_file):
    connection = pymysql.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
        cursorclass=pymysql.cursors.DictCursor
    )

    with connection:
        with connection.cursor() as cursor:
            with open(f"queries/{query_file}", 'r', encoding='utf-8') as f:
                sql = f.read()
            cursor.execute(sql)
            result = cursor.fetchall()
    return result

@app.route('/')
def index():
    return render_template('index.html', query_descriptions=query_descriptions)

@app.route('/query/<int:query_id>')
def execute_query(query_id):
    try:
        results = run_query(f"Q{query_id:02}.sql")
        description = query_descriptions.get(query_id, "Unknown Query")
        return render_template('result.html', results=results, description=description)
    except Exception as e:
        return f"Error: {e}"

if __name__ == '__main__':
    app.run(debug=True)
