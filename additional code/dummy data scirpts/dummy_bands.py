import faker
import random
from datetime import date

fake = faker.Faker()
NUMBER_OF_BANDS = 20
TABLE_NAME = "band"
OUTPUT_FILENAME = "dummy_data_bands.sql"

subgenre_ids = list(range(1, 21))

rows = []

for _ in range(NUMBER_OF_BANDS):
    band_name = fake.company().replace('"', '\\"')  # use company names for realistic band names

    # formation date between 1970 and 2023
    formation_year = random.randint(1970, 2023)
    formation_month = random.randint(1, 12)
    formation_day = random.randint(1, 28)
    formation_date = date(formation_year, formation_month, formation_day)

    subgenre_id = random.choice(subgenre_ids)

    # 50% chance to have a webpage and Instagram
    web_page = fake.url().replace('"', '\\"') if random.random() < 0.5 else None
    instagram_profile = f"https://instagram.com/{fake.user_name()}" if random.random() < 0.5 else None

    # SQL NULL handling
    web_page_sql = f'"{web_page}"' if web_page else "NULL"
    instagram_sql = f'"{instagram_profile}"' if instagram_profile else "NULL"

    rows.append(f'("{band_name}", "{formation_date}", {subgenre_id}, {web_page_sql}, {instagram_sql})')

values_str = ",\n".join(rows)

sql = f"""INSERT INTO {TABLE_NAME} (
    name,
    formation_date,
    subgenre_id,
    web_page,
    instagram_profile
) VALUES
{values_str};
"""

with open(OUTPUT_FILENAME, "w", encoding="utf-8") as f:
    f.write(sql)

print(f"Created {NUMBER_OF_BANDS} dummy bands in '{OUTPUT_FILENAME}'")
