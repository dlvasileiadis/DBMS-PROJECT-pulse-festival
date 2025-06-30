import faker
import random
import os

fake = faker.Faker()
DUMMY_DATA_NUMBER = 10  
TABLE_NAME = "location"
OUTPUT_FILENAME = f"dummy_data_{TABLE_NAME}.sql"


continents = [
    "Europe", "Asia", "Africa", "North America",
    "South America", "Australia", "Antarctica"
]

rows = []
for _ in range(DUMMY_DATA_NUMBER):
    lat = round(random.uniform(-90, 90), 6)
    lng = round(random.uniform(-180, 180), 6)
    address = fake.street_address().replace('"', '\\"')
    city = fake.city().replace('"', '\\"')
    country = fake.country().replace('"', '\\"')
    continent = random.choice(continents)

    rows.append(f'({lat}, {lng}, "{address}", "{city}", "{country}", "{continent}")')

values_str = ",\n".join(rows)


sql = f"""INSERT INTO {TABLE_NAME} (
    coordinates_lang,
    coordinates_long,
    adress,
    city,
    country,
    continent
) VALUES
{values_str};
"""


print("📄 Writing SQL to file...")
try:
    with open(OUTPUT_FILENAME, "w", encoding="utf-8") as f:
        f.write(sql)
    print(f"Done Generated {DUMMY_DATA_NUMBER} dummy locations in '{OUTPUT_FILENAME}'")
    print(f"File saved at: {os.path.abspath(OUTPUT_FILENAME)}")
except Exception as e:
    print(f"Failed to write file: {e}")
