import faker

fake = faker.Faker()
festival_ids = list(range(1, 12)) 
venues_per_festival = 3
TABLE_NAME = "venue"
OUTPUT_FILENAME = f"dummy_data_{TABLE_NAME}.sql"

# fixed capacities order
capacities = [50, 30, 10]

rows = []

for festival_id in festival_ids:
    for i in range(venues_per_festival):
        name = fake.company().replace('"', '\\"') + " Stage"
        description = fake.sentence().replace('"', '\\"')
        max_capacity = capacities[i]  # 50, 30, 10
        rows.append(f'({festival_id}, "{name}", "{description}", {max_capacity})')

values_str = ",\n".join(rows)

sql = f"""INSERT INTO {TABLE_NAME} (
    festival_id,
    name,
    description,
    max_capacity
) VALUES
{values_str};
"""


with open(OUTPUT_FILENAME, "w", encoding="utf-8") as f:
    f.write(sql)

print(f"Created {len(rows)} dummy venues with fixed capacities in '{OUTPUT_FILENAME}'")
