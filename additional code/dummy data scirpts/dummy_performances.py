# performances must finish before 22:00
# each event has up to 3 performances.
# first performance is always Warm-Up (type_id = 1).
# second and third are randomly Headliner (2) or Special Guest (3).
# no performer in 3 consecutive years.
# no manual performance_id (auto_increment).
# start at 17:00.
# all performances end before or exactly at 22:00.

# Due to some "no data" results we added some performances manualy. they exit in load file

import random
from datetime import datetime, timedelta


NUM_EVENTS = 45
PERFORMANCES_PER_EVENT = 3
EVENT_START_TIME = "17:00:00"
EVENT_END_TIME = "22:00:00"

#Performers ids
performer_ids = list(range(1, 91))

#Event info 
event_info = {
    1: ("2017-08-12", 1), 2: ("2017-08-12", 1), 3: ("2017-08-12", 1),
    4: ("2017-08-13", 1), 5: ("2017-08-13", 1), 6: ("2017-08-13", 1),
    7: ("2018-08-12", 2), 8: ("2018-08-12", 2), 9: ("2018-08-12", 2),
    10: ("2019-08-12", 3), 11: ("2019-08-12", 3), 12: ("2019-08-12", 3),
    13: ("2019-08-13", 3), 14: ("2019-08-13", 3), 15: ("2019-08-13", 3),
    16: ("2020-08-12", 4), 17: ("2020-08-12", 4), 18: ("2020-08-12", 4),
    19: ("2021-08-12", 5), 20: ("2021-08-12", 5), 21: ("2021-08-12", 5),
    22: ("2021-08-13", 5), 23: ("2021-08-13", 5), 24: ("2021-08-13", 5),
    25: ("2022-08-12", 6), 26: ("2022-08-12", 6), 27: ("2022-08-12", 6),
    28: ("2023-08-12", 7), 29: ("2023-08-12", 7), 30: ("2023-08-12", 7),
    31: ("2023-08-13", 7), 32: ("2023-08-13", 7), 33: ("2023-08-13", 7),
    34: ("2024-08-12", 8), 35: ("2024-08-12", 8), 36: ("2024-08-12", 8),
    37: ("2025-08-12", 9), 38: ("2025-08-12", 9), 39: ("2025-08-12", 9),
    40: ("2025-08-13", 9), 41: ("2025-08-13", 9), 42: ("2025-08-13", 9),
    43: ("2026-08-12", 10), 44: ("2026-08-12", 10), 45: ("2026-08-12", 10),
}

#Performance types
WARMUP_TYPE_ID = 1
HEADLINER_TYPE_ID = 2
SPECIALGUEST_TYPE_ID = 3

TABLE_NAME = "performances"
OUTPUT_FILENAME = "dummy_data_performances.sql"


performer_years = {pid: set() for pid in performer_ids}



rows = []

random.shuffle(performer_ids)

available_performers = performer_ids.copy()

for event_id, (event_date_str, festival_id) in event_info.items():
    event_year = 2016 + festival_id

    start_time = datetime.strptime(f"{event_date_str} {EVENT_START_TIME}", "%Y-%m-%d %H:%M:%S")
    hard_end_time = datetime.strptime(f"{event_date_str} {EVENT_END_TIME}", "%Y-%m-%d %H:%M:%S")
    current_time = start_time

    performers_this_event = []

    for i in range(PERFORMANCES_PER_EVENT):
        # check if there is still time left for a performance
        minutes_left = int((hard_end_time - current_time).total_seconds() // 60)

        if minutes_left < 30:
            break  # not enough time for a new performance, stop adding

        # find a performer respecting 3-year rule
        while True:
            if not available_performers:
                available_performers = performer_ids.copy()
                random.shuffle(available_performers)

            performer_id = available_performers.pop()

            years = performer_years[performer_id]

            if (event_year - 1 in years) and (event_year - 2 in years):
                continue  # would make 3 consecutive years, skip

            break

        performer_years[performer_id].add(event_year)
        performers_this_event.append(performer_id)

        # Select type
        if i == 0:
            type_id = WARMUP_TYPE_ID
        else:
            type_id = random.choice([HEADLINER_TYPE_ID, SPECIALGUEST_TYPE_ID])

        # random duration  30-180 minutes but limited to remaining time
        max_possible_duration = min(180, minutes_left)
        duration = random.randint(30, max_possible_duration)

        end_time = current_time + timedelta(minutes=duration)

        # insert performance row 
        rows.append(f"({event_id}, {type_id}, '{current_time.strftime('%Y-%m-%d %H:%M:%S')}', '{end_time.strftime('%Y-%m-%d %H:%M:%S')}', (SELECT venue_id FROM event WHERE event_id = {event_id}), {performer_id})")

        #next performance
        current_time = end_time + timedelta(minutes=random.randint(5, 30))



values_str = ",\n".join(rows)

sql = f"""USE pulse_festival;

INSERT INTO {TABLE_NAME} (
    event_id,
    type_id,
    start_time,
    end_time,
    venue_id,
    performer_id
) VALUES
{values_str};
"""

with open(OUTPUT_FILENAME, "w", encoding="utf-8") as f:
    f.write(sql)

print(f"Created {len(rows)} performances into '{OUTPUT_FILENAME}' (respecting 22:00 end)")
