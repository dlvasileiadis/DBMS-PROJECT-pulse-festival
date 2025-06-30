import faker

fake = faker.Faker()
DUMMY_DATA_NUMBER = 240
TABLE_NAME = "person"
OUTPUT_FILENAME = f"dummy_data_{TABLE_NAME}.sql"

rows = []
for _ in range(DUMMY_DATA_NUMBER):
    first_name = fake.first_name().replace('"', '\\"')
    last_name = fake.last_name().replace('"', '\\"')
    age = fake.random_int(min=10, max=80)  
    contact_info = fake.email().replace('"', '\\"')

    rows.append(f'("{first_name}", "{last_name}", {age}, "{contact_info}")')

values_str = ",\n".join(rows)

sql = f"""INSERT INTO {TABLE_NAME} (
    first_name,
    last_name,
    age,
    contact_info
) VALUES
{values_str};
"""

with open(OUTPUT_FILENAME, "w", encoding="utf-8") as f:
    f.write(sql)

print(f"Created {DUMMY_DATA_NUMBER} dummy persons in '{OUTPUT_FILENAME}'")


