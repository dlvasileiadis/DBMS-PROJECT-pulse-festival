
from datetime import datetime, timedelta

TABLE_NAME = "event"
OUTPUT_FILENAME = "dummy_data_events.sql"

# Real festival data
festivals = {
    1: ("2017-08-12", "2017-08-13"),
    2: ("2018-08-12", "2018-08-12"),
    3: ("2019-08-12", "2019-08-13"),
    4: ("2020-08-12", "2020-08-12"),
    5: ("2021-08-12", "2021-08-13"),
    6: ("2022-08-12", "2022-08-12"),
    7: ("2023-08-12", "2023-08-13"),
    8: ("2024-08-12", "2024-08-12"),
    9: ("2025-08-12", "2025-08-13"),
    10: ("2026-08-12", "2026-08-12"),
}

# Empty list to store all the rows we will insert
rows = []

# loop over each festival
for festival_id, (start_date_str, end_date_str) in festivals.items():
    # convert the start_date and end_date strings into real datetime objects
    start_date = datetime.strptime(start_date_str, "%Y-%m-%d")
    end_date = datetime.strptime(end_date_str, "%Y-%m-%d")

    # find out how many days the festival lasts (1 or 2)
    num_days = (end_date - start_date).days + 1

    # loop over each day of the festival
    for day_offset in range(num_days):
        # calculate the exact date of the event
        current_date = start_date + timedelta(days=day_offset)

        # find the base venue id for this festival
        # since each festival has 3 venues (festival_id - 1) * 3 + 1
        base_venue_id = (festival_id - 1) * 3 + 1

        # loop over the 3 venues of the festival
        for i in range(3):
            # calculate the correct venue_id
            venue_id = base_venue_id + i

            # define the start and end time for the event
            # events start at 17:00 and end at 22:00 everyday
            start_datetime = datetime.combine(current_date.date(), datetime.strptime("17:00:00", "%H:%M:%S").time())
            end_datetime = datetime.combine(current_date.date(), datetime.strptime("22:00:00", "%H:%M:%S").time())

            start_str = start_datetime.strftime('%Y-%m-%d %H:%M:%S')
            end_str = end_datetime.strftime('%Y-%m-%d %H:%M:%S')

            # event name and description 
            event_name = f"Event at Venue {venue_id} on {current_date.date()}"
            description = f"Exciting event held at venue {venue_id} during the festival."

            rows.append(f"('{event_name}', '{description}', '{current_date.date()}', '{start_str}', '{end_str}', {venue_id}, {festival_id})")


values_str = ",\n".join(rows)

sql = f"""USE pulse_festival;

INSERT INTO {TABLE_NAME} (
    name,
    description,
    date,
    start_time,
    end_time,
    venue_id,
    festival_id
) VALUES
{values_str};
"""


with open(OUTPUT_FILENAME, "w", encoding="utf-8") as f:
    f.write(sql)

print(f"Created {len(rows)} events in '{OUTPUT_FILENAME}' (starting at 17:00, no manual event_id)")
