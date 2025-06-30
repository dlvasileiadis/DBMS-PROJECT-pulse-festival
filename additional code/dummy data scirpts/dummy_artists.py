import faker
import random
from datetime import date

fake = faker.Faker()
NUMBER_OF_ARTISTS = 100
TABLE_NAME = "artist"
OUTPUT_FILENAME = "dummy_data_artists.sql"

# subgenre Ids
# Assuming subgenre_id = 1 to 20 (inserted 20 subgenres)
subgenre_ids = list(range(1, 21))

rows = []

for _ in range(NUMBER_OF_ARTISTS):
    name = fake.name().replace('"', '\\"')
    
    # 50% chance to have a nickname
    nickname = fake.user_name().replace('"', '\\"') if random.random() < 0.5 else None

    # birthdate between 1960 and 2010
    birth_year = random.randint(1960, 2010)
    birth_month = random.randint(1, 12)
    birth_day = random.randint(1, 28)  # Safe (no February overflow)
    birth_date = date(birth_year, birth_month, birth_day)

    # random subgenre
    subgenre_id = random.choice(subgenre_ids)

    # 50% chance to have a web page / Instagram
    web_page = fake.url().replace('"', '\\"') if random.random() < 0.5 else None
    instagram_profile = f"https://instagram.com/{fake.user_name()}" if random.random() < 0.5 else None

    # SQL NULL handling
    nickname_sql = f'"{nickname}"' if nickname else "NULL"
    web_page_sql = f'"{web_page}"' if web_page else "NULL"
    instagram_sql = f'"{instagram_profile}"' if instagram_profile else "NULL"

    rows.append(f'("{name}", {nickname_sql}, "{birth_date}", {subgenre_id}, {web_page_sql}, {instagram_sql})')

values_str = ",\n".join(rows)

#final SQL
sql = f"""INSERT INTO {TABLE_NAME} (
    name,
    nickname,
    birth_date,
    subgenre_id,
    web_page,
    instagram_profile
) VALUES
{values_str};
"""

with open(OUTPUT_FILENAME, "w", encoding="utf-8") as f:
    f.write(sql)

print(f"Created {NUMBER_OF_ARTISTS} dummy artists in '{OUTPUT_FILENAME}'")
