import pymysql
import random

# database connection
conn = pymysql.connect(
    host="localhost",
    user="root",
    password="",
    database="pulse_festival",
    port=3306
)
cursor = conn.cursor()

# find all active tickets
cursor.execute("""
    SELECT ticket_id, person_id, event_id
    FROM ticket
    WHERE activated = TRUE
""")
tickets = cursor.fetchall()

print(f"Found {len(tickets)} active tickets.")

# for every active ticket
for ticket_id, person_id, event_id in tickets:
    #find a random performance of the event it belongs
    cursor.execute("""
        SELECT performance_id
        FROM performances
        WHERE event_id = %s
    """, (event_id,))
    performances = cursor.fetchall()

    if not performances:
        print(f"No performances found for event_id={event_id}")
        continue

    performance_id = random.choice(performances)[0]  # pick a random performance

    artist_rating = random.randint(1, 3)
    sound_light_rating = random.randint(1, 3)
    stage_presence = random.randint(1, 3)
    organization_rating = random.randint(1, 3)
    overall_impression = random.randint(1, 3)

    try:
        cursor.execute("""
            INSERT INTO review (
                ticket_id,
                person_id,
                performance_id,
                artist_rating,
                sound_light_rating,
                stage_presence,
                organization_rating,
                overall_impression,
                review_date
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, CURRENT_DATE)
        """, (
            ticket_id,
            person_id,
            performance_id,
            artist_rating,
            sound_light_rating,
            stage_presence,
            organization_rating,
            overall_impression
        ))
    except pymysql.MySQLError as err:
        print(f"Skipping ticket_id={ticket_id}, performance_id={performance_id} - Reason: {err}")
        continue


conn.commit()
print("Reviews inserted successfully.")


cursor.close()
conn.close()
