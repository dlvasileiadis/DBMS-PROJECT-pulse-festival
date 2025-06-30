import random
from datetime import date, timedelta

DUMMY_DATA_NUMBER = 11
TABLE_NAME = "festival"
OUTPUT_FILENAME = f"dummy_data_{TABLE_NAME}.sql"

location_ids = list(range(1, DUMMY_DATA_NUMBER + 1))
years = list(range(2017, 2028))  # 2017 to 2027 inclusive

rows = []
for i in range(DUMMY_DATA_NUMBER):
    year = years[i]
    start = date(year, 8, 12)
    end = start + timedelta(days=random.randint(1, 3))  # 1–3 day festival
    location_id = location_ids[i]
    rows.append(f'({year}, "{start}", "{end}", {location_id})')

values_str = ",\n".join(rows)

sql = f"""INSERT INTO {TABLE_NAME} (
    year,
    start_date,
    end_date,
    location_id
) VALUES
{values_str};
"""

with open(OUTPUT_FILENAME, "w", encoding="utf-8") as f:
    f.write(sql)

print(f"Created {DUMMY_DATA_NUMBER} dummy festivals in '{OUTPUT_FILENAME}'")


# we made some delitions in the sql file, but the generator wat this script
